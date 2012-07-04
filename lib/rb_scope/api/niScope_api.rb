module RbScope

  # This module acts as the Ruby interface to the C API.
  # It loads the niScope dll library and links itself to the dll functions.
  # It also loads all the macro constants defined in niScope.h for easier
  # scripting of the digitizer devices from Ruby.
  module API

    require 'ffi'
    require 'rb_scope/api/niScope_template'
    require 'rb_scope/api/niScope_values'
    
    extend FFI::Library
    
    begin
      ffi_lib $LOAD_PATH.map{ |path| path+"/rb_scope/rb_scope.dll"}    
      Template.each{ |sig| 
        attach_function(  
          sig[0].to_s.sub("niScope", "rbScope").to_sym, 
          sig[1].map{|t| Types[:ruby][t] || t }, 
          sig[2] 
        )     
      }
    rescue
      RbScope::prompt "could not load rb_scope.dll library"
    end

  end
  
end