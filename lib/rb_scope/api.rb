module RbScope

    # This module acts as the Ruby interface to the C API.
    # It loads the niScope dll library and links itself to the dll functions.
    # It also loads all the macro constants defined in niScope.h for easier
    # scripting of the digitizer devices from Ruby.
    module API

        %w{template values}.each{|mod| require 'rb_scope/api/niScope_' + mod}

        begin
            extend FFI::Library
            ffi_lib $LOAD_PATH.map{|path| path+"/rb_scope/rb_scope.dll"}
            ffi_signatures.each{ |sig| attach_function *sig }
        rescue
            RbScope::prompt "could not load rb_scope.dll library"
        end

        class << self
            def handle_error address, visa_id, err_code, &block
                buf1 = FFI::MemoryPointer.new :char, 1024   # TODO: add some way to clean this
                buf2 = FFI::MemoryPointer.new :char, 1024   # buffer or is it handled by FFI ?
                rbScope_errorHandler(visa_id, err_code, buf1, buf2)
                puts  "RbScope error for session id %s / address %i:" % [address, visa_id],
                      "  source:  %s" % buf1.read_string(),
                      "  message: %s" % buf2.read_string()
                #abord acquisition 
                #close ses
                block.call if block
            end
        end

    end

end
