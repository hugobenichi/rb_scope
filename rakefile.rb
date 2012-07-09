require 'rake/clean'

name = 'rb_scope'

# at installation

  task :gem_build do
    sh "gem build %s.gemspec" % name
  end

  task :gem_install => :gem_build do
    gemfile = Dir.new("./").entries.select{ |f| f =~ /rb_scope-[\d]+\.[\d]+\.[\d]+.gem/ }.sort[-1]
    sh "gem install %s" % gemfile
  end

  task :doc do  
    sh 'rdoc lib' 
  end


# testing tasks

task :debug => [:gem_install, :test_gem]

task :test_local do
  sh "ruby -I./lib test/test_rb_scope.rb"
end

task :test_gem do
  sh "ruby -I./lib test/test_rb_scope.rb"
end

task :load do
  sh "ruby -Ilib -Iext lib/rb_scope/api/niScope_api.rb"
end

# post-install compilation tasks

  task :dll_install => [:dll_rb_scope, :dll_fetch] do
    #mark down 
  end
  
  path_include = ""
  path_library = ""
  
  task :set_path do
    puts "you might need to run the command prompt as Administrator"
    #ask for VC env var batch script
      #sh '"C:\Program Files (x86)\MVS10.0\VC\vcvarsall.bat"'
      #ask for path to niScope.h
      #ask for path to ivi.h and visa.h
      path_include = '"C:\Program Files (x86)\IVI Foundation\VISA\WinNT\include"'
      #ask for path to niScope.lib
      path_library = '"C:\Program Files (x86)\IVI Foundation\VISA\WinNT\Lib\msc\niScope.lib"'
  end

  task :dll_rb_scope => :set_path do
    #write down wrapper.c
      #ruby -Ilib ext\ni_scope\wrapper_generator.rb > ext\ni_scope\wrapper.c
    #compile
      sh 'cl -c .\ext\rb_scope\wrapper.c -I%s' % path_include
      #compile rb_scope.c with good dependency
    #link
      sh 'link /DLL /OUT:lib\rb_scope\rb_scope.dll wrapper.obj %s' % path_library   
  end

  task :dll_fetch => :set_path do
    sh 'cl -c .\ext\rb_scope\fetching\fetch.c -I%s -I.\ext\rb_scope\fetching' % path_include
    sh 'link /DLL /OUT:lib\rb_scope\fetch.dll fetch.obj %s' %path_library
  end

# cleaning  
  
  CLEAN.include 'ext/**/*{.o,.obj}'
  CLEAN.include '*{.gem}'
  CLOBBER.include 'lib/**/*.{dll,exp,lib}'

