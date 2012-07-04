module RbScope
  
  # Helper class to encapsulate data and state relative to a device Session
  # This is the main class that clients instantiate to use the gem.
  # <TO_DO> 1) implement errors 2) attributes setters/getters
  #
  # typical usage: RbScope::Session.new("mydevice").configure parameters
  # 
  class Session

    attr_reader :address, :visa_id, :status

    #starts a new connection
    def initialize address, &block
      @address = address      
      session_p = FFI::MemoryPointer.new :pointer, 1      
      @status = API::rbScope_init address, 1, 1, session_p
      #handle error if @status < 0
      @visa_id = session_p.read_pointer.read_uint32
      prompt "session ##{@visa_id} for device #{@address} initalized with status #{@status}"
      self.instance_eval &block if block
      self
    end
  
    # cleanup method called by the garbage collector
    def self.release session
      if API::rbScope_close(session.visa_id) < 0
        #handle error
      end
    end
    
    require 'rb_scope/session_methods'
    require 'rb_scope/session_attributes'   
    
  end

end