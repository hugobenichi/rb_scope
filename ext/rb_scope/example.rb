require 'rb_scope'

# old
settings = {
	  rate:                   1000E6, 
	  bandwidth:              300E6, 
	  size:                   2000, 
	  packet:                 1000, 
    shot:                   10000,
	  tomo:                   100000,	
	  tomo_ohp:               100000,
	  tomo_full:              100000,
    byte:                   1,
    trig_ref:               62,
  }

    pxi = Scope::start :pxi5152 do 
    self[:timeout]        = -1 #= infinity
    return_self           false 
	  config                1
    trigger_edge    
	  vertical              "0", 0.2, settings[:bandwidth], 11
    vertical              "1", 1.0, settings[:bandwidth], 11  
	  horizontal            settings[:rate], settings[:size], settings[:shot], settings[:trig_ref]
    set_buffer            settings[:packet], settings[:byte]
	end
 
#new change this to

  settings = {
      rate:                   1000E6, 
      bandwidth:              300E6, 
      size:                   1000, 
      trig_ref:               62,
      trig_voltage:           1.0, 
      
    }
  
  parameters = {
  rate:           1000000,
  frame_size      500,
  frame_total     1000000,
  channel: [
    {chan_impedance: 50, range: 0.4 },
    {chan_impedance: 50, range: 0.2 }
  ],
  
}

session = RbScope.new.configure parameters
  
#old  
      pxi[:chan0] = sender[name][:quad]
      pxi[:chan1] = sender[name][:phase]
      pxi.set_num_record settings[name]
  
      pxi.acquire
      trigger :on 
      pxi.fetch
      trigger :off

#new: change this to 
      pxi.run conf( records: 10000, chunk: 1000, frame: 500, timeout: 500, chan0: foo, chan1: bar) { trigger :on} 
      trigger :off      
      # assume foo and bar are object with two 
      # methods, :context and :call with return 
      # a struct pointer and a function pointer

