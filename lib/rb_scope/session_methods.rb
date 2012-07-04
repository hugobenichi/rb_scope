module RbScope

  class Session 

    # This table defines the how the methods from the niScope dll are hooked to instances
    # of the Session class.
    # Arguments are passed to each methods with an Hash and through their Hash keys
    Methods = [
      [:calibrate,  "CalSelfCalibrate", ["0,1", 0]],
      [:acquire,    "InitiateAcquisition", []],
      [:stop,       "Abort", []],

      [:trig_now,   "ConfigureTriggerImmediate", []],
      [:trig_digi,
        "ConfigureTriggerDigital",
        [API::Values::NISCOPE_VAL_EXTERNAL, :slope, :deadtime, 0.0]],
      [:trig_edge,
        "Configure_TriggerEdge",
        [API::Values::NISCOPE_VAL_EXTERNAL, :trig_voltage, :slope, :trig_coupling, :deadtime, 0.0]],

      [:vertical,   "ConfigureVertical",
        [:channel, :range, 0.0, :coupling, 1.0, 1]],
      [:channel,    "ConfigureChanCharacteristics",
        [:channel, :impedance, :bandwidth]],
      [:horizontal, "ConfigureHorizontalTiming",
        [:rate, :points, :trig_reference, :records, 1]],      
    ]
    
    #this block of code does the actual patching
    Methods.each do |sig|   
      define_method(sig[0]) do |*args|
        meth = "rbScope_#{sig[1]}".to_sym           # generate the good method name found in RbScope::API
        args_chain  = [@visa_id]                     # first arg is always the session Id number
                    + sig[2].map{ |x|
                      if x.is_a? Symbol             # if x is a symbol, check for user provided value
                        args[x] || Defaults[x]      # if no value use default
                      else
                        x                           # else use the hardcoded value
                      end
                    }
        @status = API::send meth, args_chain        # finally dispatch the method call to RbScope::API
        #handle_error if rez < 0
        self
      end
    end
    
    # 1-in-4 configuration methods with the convention that there is a :channel key 
    # which points to an array of subhash for both channels which looks like:
    #   parameters = {:channel [ {range: 0.1, chan_impendance: 50, ... }, {...} ]}
    def configure parameters
      @points = parameters[:points] || Defaults[:points]
      self.horizontal parameters
      parameters[:channel].each_with_index{ |p,i|
        self.channel i.to_s, p
      } if parameters[:channel]
    end
    
    #shortcut for channel configuration
    def channel chan, parameters
      param = parameters.clone.tap{ |hash| hash[:channel] = chan }
      [:channel, :vertical].each{ |meth| self.send meth, parame }
    end
      
    # default values for parameters of configuration functions
    Defaults = {
      deadtime:         0.0,
      slope:            API::Values::NISCOPE_VAL_POSITIVE,
      trig_coupling:    API::Values::NISCOPE_VAL_DC,
      trig_voltage:     0.5,
      trig_reference:   0.5,
      coupling:         API::Values::NISCOPE_VAL_AC,
      impedance:        API::Values::NISCOPE_VAL_1_MEG_OHM,
      bandwidth:        API::Values::NISCOPE_VAL_BANDWIDTH_FULL,
      rate:             1000000,
      points:           1000,
      records:          1000,
      range:            1.0,
    }
  
  end
  
end