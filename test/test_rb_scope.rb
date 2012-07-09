require "rb_scope"
require "c_buffer"

records = 10000
points  = 1000
chunk   = 1000
buf_num = 32
size    = 2 * chunk * points
dc      = RbScope::API::Values::NISCOPE_VAL_DC
megaohm = 50.0 #RbScope::API::Values::NISCOPE_VAL_1_MEG_OHM

digitizer = RbScope::Session.new 'Dev1' do |d|
  d.stop
  d.horizontal(rate: 1E9, points: points, records: records, position: 0.5)
  d.channel     0, { range: 0.1, coupling: dc, impedance: megaohm}
  d.channel     1, { range: 0.1, coupling: dc, impedance: megaohm}
  d.trigger( type: :edge, level: 0.5, coupling: dc)  
end

buffer     = CBuffer.new( path: "data.raw", chunk: size, length: buf_num)
buffer_get = FFI::Function.new(:pointer, [:pointer]){ |v| buffer.input }

buffer.output

digitizer.run( 
  records:  records,
  chunk:    chunk,
  buf:      [buffer_get, nil]
)

buffer.stop

RbScope::Session.release digitizer

puts "ok"
