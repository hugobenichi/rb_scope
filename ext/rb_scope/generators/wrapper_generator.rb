module RbScope

  module API
  
    
    module Wrapper
    
      require 'rb_scope/api/template'
      
      def self.build file_name=nil
        output = file_name ? File.open(file_name, 'w') : $stdout        
        [          
          "/*", 
          " *   This file has been automatically generated",
          " *   by rb_scope/ext/rb_scope/#{File.basename __FILE__}",
          " *",
          " *   software: rb_scope gem",
          " *   author: hugo benichi",
          " *   contact: hugo.benichi@m4x.org",
          " *",
          " */",
          "",
          '#include "niScope.h"',
          "",
          "#define DLL extern __declspec(dllexport)",
          "",        
        ].each{|line| output.puts line}          
        RbScope::API::Template.each do |sig|           
          i = 0
          args_chain_decla, args_chain_invoc = *sig[1].map{ |type|
            ctype = RbScope::API::Types[:c][type] || type.to_s
            arg   = "arg#{i+=1}"
            [ "%s %s" % [ctype, arg], arg ]           
          }.transpose.map{ |chain| chain.join ", "}
          ext_name = sig[0].to_s.sub "niScope", "rbScope"   #do not hardcode this
          int_name = sig[0].to_s
          ret_type = RbScope::API::Types[:c][sig[2]] || sig[2].to_s
          substitu = [ret_type, ext_name, args_chain_decla, int_name, args_chain_invoc]  
          template = "DLL %s %s(%s)\n{\n  return %s(%s);\n}\n\n"        
          output.puts template % substitu              
        end            
        output.close unless output == $stdout    
      end
    
    end
    
  end
  
end

RbScope::API::Wrapper.build ARGV[0]  #argv[0] is the path to the output file || stdout if nul
