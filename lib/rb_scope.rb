##
 #              rb_scope
 #
 #    ( C2Ruby wrapper to NI-Scope drivers )
 #    
 #  author      hugo benichi
 #  email       hugo.benichi@m4x.org
 #  copyright   2012 hugo benichi
 #  
 #  description 
 #  
 #    A Ruby layer wrapping around C calls to the NI-Scope drivers.
 #    Most C data manipulation and C calls are done through the FFI gems.
 #	  In addition a few C methods are provided for improved efficiency when handling data
 #
 ##

# main namespace module which encapsulates the helper methods and wrappring API calls
module RbScope
  
  # <TO_DO> all addressedd from conf file / NiScope to auto-detect them ?

  class << self

    # prefix a message before writing to stdout
	  def prompt message
      puts "RbScope >> #{message}"
    end

  end

  [
    'rb_scope/api',
    'rb_scope/fetch',
    'rb_scope/session',
  ].each{ |mod| require mod }
  
end

