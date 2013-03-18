#!/usr/local/bin/ruby

module RbScope

  module API

    module Wrapper

      require 'rb_scope/api/niScope_template'

      def self.source_header
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
        ]
      end

      def self.source_core
        ctypes = RbScope::API::types[:c]

        RbScope::API::c_signatures.map do |sig|

          args_types = sig[1].map{ |type| ctypes[type] || type.to_s }
          args_names = 1.upto(sig[1].length).map { |i| "arg#{i}" }

          "DLL %s %s(%s)\n{\n  return %s(%s);\n}\n\n" % [
            (RbScope::API::types[:c][sig[2]] || sig[2].to_s),
            sig[0].to_s.sub("niScope", "rbScope"),
            args_types.zip(args_names).map{|s| s.join " "}.join(", "),
            sig[0].to_s,
            args_names.join(", ")
          ]

        end

      end

      def self.build file_name=nil
        output = file_name ? File.open(file_name, 'w') : $stdout
        (source_header + source_core).each{|line| output.puts line}
        output.close unless output == $stdout
      end

    end

  end

end


#argv[0] is the path to the output file || stdout if nul
RbScope::API::Wrapper.build ARGV[0]
