#!/usr/local/bin/ruby
#
# This script will extract the #define NAME VALUE pairs from
# a header file specified in ARGV[0] and write them into ARGV[1]
# if ARGV[1] is not specified, output is stdin
#
# call with extract.rb scope.h filtered_scope.
#

output = ARGV[1] ? File.open(ARGV[1], "w") : $stdout

output.puts '#include "niScope.h"'

File.open(ARGV[0],'r').readlines.select{ |line|
    line =~ /^#define[\s]+[\w]+[\s]+\S[\s\S]+/
}.each{ |line| 
    #name, val = line.match(/^#define[\s]+([\w]+)[\s]+(\S[\s\S]+)/)[1..2]
    match = line.match(/^#define[\s]+([\w]+)[\s]+(\S[\s\S]+)/)
    name = match[1]
    val  = match[2]  #
    #output.puts "%s\n    %s" % [name, val.gsub( %r|[\s]*/\*[\s\w]*\*/[\s]*|, '')]
    #output.puts "%s\n    %s" % [name, val.gsub( %r|[\s]*/\*[\s\S]*?\*/[\s]*|, '')]
    output.puts '"%s"; %s;' % [name, name]
}

output.close unless output == $stdin
