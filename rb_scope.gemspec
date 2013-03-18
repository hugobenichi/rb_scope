Gem::Specification.new do |spec|

  spec.name        = 'rb_scope'
  spec.version     = '2.0.7'
  spec.date        = '2013-03-18'
  spec.summary     = "C2Ruby wrapper to National Instruments NI-Scope drivers."
  spec.description = "A Ruby layer wrapping C calls to the NI-Scope drivers."
  spec.authors     = ["Hugo Benichi"]
  spec.email       = 'hugo [dot] benichi [at] m4x [dot] org'
  spec.homepage    = "http://github.com/hugobenichi/rb_scope"

  spec.files       = Dir.glob( 'lib/**/*.{rb,const,dll}')
  spec.files      += Dir.glob( 'ext/**/*.{c,h,rb,sh,dll,ext,lib}')
  spec.files      += Dir.glob( 'test/**/*.rb')
  spec.files      << 'rakefile.rb'
  spec.files      << 'README'

  spec.add_dependency 'ffi'

end
