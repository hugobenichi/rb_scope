module RbScope

  module Fetch

    require 'ffi'
    extend FFI::Library
    
    begin
      ffi_lib $LOAD_PATH.map{ |path| path+"/rb_scope/fetch.dll"}
      attach_function :fetch, [:pointer], :int32, :blocking => true
    rescue
      RbScope::prompt "could not load fetch.dll library"
    end
    
    # simple Struct wrapper to pass information to fetch.c/fetch()
    class Helper < FFI::ManagedStruct      
      layout  :address,   :pointer,
              :error,     :pointer,
              :buff0,     :pointer,
              :buff1,     :pointer,
              :context0,  :pointer,
              :context1,  :pointer,
              :timeout,   :double,
              :points,    :int32,     #also frn_siz
              :records,   :int32,     #also frm_tot
              :chunk,     :int32,     #also chunk
              :session,   :uint32

      Default = {
        error:    nil,
        buff0:    nil,
        buff1:    nil,
        context0: nil,
        context1: nil,
        timeout:  10.0,
        records:  1,
        chunk:    1,
      }
      
    end
    
  end
      
  class Session

    def run param, &block 
    
      h = Helper.new
      Helper::Default.each_pair{ |k,v| h[k] = param[k] || v }  #configure from parameters or ortherwise use default 
      
      h[:address] = FFI::MemoryPointer.from_string @address
      h[:session] = FFI::MemoryPointer.from_string @visa_id      
      h[:points]  = @points
      begin
      h[:buff0], h[:context0] = param[:chan0].call, param[:chan0].context if param[:chan0]
      h[:buff1], h[:context1] = param[:chan1].call, param[:chan1].context if param[:chan1]
      rescue
        RbScope::prompt "could not configure channels output buffers"
      end
    
      self.acquire
      block.call if block   # call pre-fetching block if necessary
      Fetch::fetch  h
      self
      
    end
  
  end
  
end