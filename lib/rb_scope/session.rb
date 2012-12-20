module RbScope

    # Helper class to encapsulate data and state relative to a device Session
    # This is the main class that clients instantiate to use the gem.
    class Session

        attr_reader :address, :visa_id, :status

        # starts a new connection
        def initialize address, &block
            @address = address
            session_p = FFI::MemoryPointer.new :pointer, 1
            check API::rbScope_init address, 1, 1, session_p
            @visa_id = session_p.read_uint32
            RbScope::prompt "init session #%i, device %s, status %i" % [@visa_id, @address, @status]
            check API::rbScope_ConfigureAcquisition @visa_id, API::Values::NISCOPE_VAL_NORMAL
            self.instance_eval &block if block
            self
        end

        # cleanup method called by the garbage collector
        # TODO: check if it is really called
        def self.release session
            session.check API::rbScope_close(session.visa_id)
        end

        # store the NiScope return code into @status 
        # and check if the return code is an error code
        #   if error, call error_handler
        def check name = nil, code
            @status = code
            puts "return code for %s: %i" % [name, @status] if name
            API::handle_error @address, @visa_id, @status if @status < 0
        end

        %w{method_dispatch attributes}.each{|mod| require 'rb_scope/session/' + mod}

    end

end
