

Gem::Specification.new do |spec|

  spec.name        = 'rb_scope'
  spec.version     = '2.0.2'
  spec.date        = '2012-06-15'
  spec.summary     = "C2Ruby wrapper to NI-Scope drivers"
  spec.description = "A Ruby layer wrapping around C calls to the NI-Scope drivers based on the ffi gem api"
  spec.authors     = ["Hugo Benichi"]
  spec.email       = 'hugo.benichi@m4x.org'
  spec.homepage    = "http://github.com/hugobenichi/rb_scope"
  
  spec.files       = Dir.glob( 'lib/**/*.{rb,const,dll,ext,lib}') 
  spec.files      += Dir.glob( 'ext/**/*.{c,h,rb,sh}') 
  spec.files      += Dir.glob( 'test/**/*.rb') 
  spec.files      << 'compile_cl.bat'
  spec.files      << 'rakefile.rb'
  spec.files      << 'README.txt'
  
  ### add post install message to ask user to do compilation using rake script
  
end
  


