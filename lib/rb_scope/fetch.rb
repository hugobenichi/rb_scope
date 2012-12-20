module RbScope

    module Fetch

        WfmInfoSize = 7 * 8 + 4  # necessary info for mockup struct allocation

        begin
            extend FFI::Library
            ffi_lib $LOAD_PATH.map{ |path| path+"/rb_scope/fetch.dll"}
            attach_function :fetch, [:pointer], :int32, :blocking => true
        rescue
            RbScope::prompt "could not load fetch.dll library"
        end

        # simple Struct wrapper to pass information to fetch.c/fetch()
        # no internal memory allocation so no need to use ManagedStruct
        class Helper < FFI::Struct
            class << self; attr_reader :default end
            @default = {timeout: 10.0, records: 1, chunk: 1}
            layout  :address,   :pointer,
                    :error,     :pointer,
                    :buf_get,   :pointer,
                    :context,   :pointer,
                    :timeout,   :double,
                    :points,    :int32,     #also frn_siz
                    :records,   :int32,     #also frm_tot
                    :chunk,     :int32,     #also chunk
                    :session,   :uint32
        end

    end

    class Session

        def run param, &block 
            self[:ALLOW_MORE_RECORDS_THAN_MEMORY,:bool] = 1
            self[:HORZ_NUM_RECORDS,:int]                = param[:records]   # number of records to fetch
            self[:FETCH_NUM_RECORDS,:int]               = param[:chunk]     # number of records to fetch per call to Fetch
            self.acquire                                                    # starts acquisition
            block.call if block                                             # call pre-fetching block if necessary
            start = Time.new
            case param[:fetcher] || :c
            when :c
                Fetch::fetch  Fetch::Helper.new.tap{ |h|
                    Fetch::Helper.default.each_pair{ |k,v| h[k] = param[k] || v }  # params or use default
                    h[:address] = FFI::MemoryPointer.from_string @address
                    h[:session] = @visa_id
                    h[:points]  = @points
                    h[:buf_get], h[:context] = param[:buf]
                    h[:error] = param[:error] || FFI::Function.new(:void,[:int32]){ |code| self.check code }
                }
            when :ruby
                records, chunk = param[:records], param[:chunk]
                wfm_info_p = FFI::MemoryPointer.new :int32, 2 * chunk * Fetch::WfmInfoSize
                Array.new(records/chunk){|i| i*chunk}.each do |frame_pos|
                    self[:FETCH_RECORD_NUMBER, :int] = frame_pos
                    check API::niScope_FetchBinary8 @visa_id, "0,1", 10.0, @points, param[:buf].call, wfm_info_p
                    done = self[:RECORDS_DONE, :int]
                    puts "RbScope::Fetching (ruby) >> %s, frames fetched #%i | measured #%i | in dev mem %i" % 
                        [@address, frame_pos, done, done - frame_pos]
                end
            end
            puts "elapsed %ssec" % (Time.new - start) if param[:timer]
            self.stop
            self
        end

        # acquire and fetch one waveform from the device
        def waveform channel="0"
            wfm_info_p = FFI::MemoryPointer.new :int32, 2 * Fetch::WfmInfoSize
            buffer     = FFI::MemoryPointer.new :char, 2 * @points
            self[:ALLOW_MORE_RECORDS_THAN_MEMORY,:bool] = 1
            self[:HORZ_NUM_RECORDS,:int]                = 1 
            self[:FETCH_NUM_RECORDS,:int]               = 1
            self.acquire
            self[:FETCH_RECORD_NUMBER, :int] = 0
            check API::niScope_FetchBinary8 @visa_id, channel, 10.0, @points, buffer, wfm_info_p
            self.stop
            buffer.get_array_of_char 0, 2 * @points
        end

    end

end
