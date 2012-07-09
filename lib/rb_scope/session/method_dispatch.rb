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
        "ConfigureTriggerEdge",
        [API::Values::NISCOPE_VAL_EXTERNAL, :level, :slope, :coupling, :deadtime, 0.0]],

      [:vertical,   "ConfigureVertical",
        [:channel, :range, 0.0, :coupling, 1.0, 1]],
      [:channel,    "ConfigureChanCharacteristics",
        [:channel, :impedance, :bandwidth]],
      [:horizontal, "ConfigureHorizontalTiming",
        [:rate, :points, :position, :records, 1]],      
    ]

    # default values for parameters of configuration functions
    Defaults = {
      deadtime:         0.0,
      slope:            API::Values::NISCOPE_VAL_POSITIVE,
      trig_coupling:    API::Values::NISCOPE_VAL_DC,
      level:            0.5,
      position:         0.5,
      coupling:         API::Values::NISCOPE_VAL_DC,
      impedance:        API::Values::NISCOPE_VAL_1_MEG_OHM,
      #impedance:        50.0,
      bandwidth:        API::Values::NISCOPE_VAL_BANDWIDTH_FULL,
      rate:             100000000.0,
      points:           1000,
      records:          1000,
      range:            1.0,
    }
    
    # this block of code does the actual patching
    # for each method declared in Methods, 
    # it deynamically defines a dispatch method
    # which sets arguments according to the info found in Methods
    #   if a symbol is found
    #     the dispatcher looks for the user provided hash
    #     and tries to get a value
    #     if it is null, it used the defaults value
    #   if not a symbol, then the hardcoded value is used
    Methods.each do |sig|   
      define_method(sig[0]) do |args=nil|
        meth = "rbScope_#{sig[1]}".to_sym           # generate the method name found in RbScope::API
        args_chain  = [@visa_id] +                  # first arg is always the session Id number
                      sig[2].map{ |x|
                        if x.is_a? Symbol           # if x is a symbol, check for user provided value
                          args[x] || Defaults[x]    # if no value use default
                        else
                          x                         # else use the hardcoded value
                        end
                      }
        check API::send meth, *args_chain           # finally dispatch the method call to RbScope::API
        self
      end
    end

    # helper method for horizontal configuration    
    alias_method :horizontal_pre, :horizontal
    def horizontal param
      @points = param[:points] || Defaults[:points]
      horizontal_pre param
    end
    
    # helper method for vertical configuration
    alias_method :channel_pre, :channel
    def channel i, param
      param.clone.tap{ |hash| 
          hash[:channel] = i.to_s 
          self.channel_pre hash
          self.vertical    hash
      }
    end
    
    # helper method for trigger configuration
    def trigger param
      case param[:type] || :edge
        when :edge then self.trig_edge param
        when :digi then self.trig_digi param
        when :now  then self.trig_now  param 
        when :soft then self.trig_now  param      
      end
    end
    
    # 1-in-5 configuration methods with the convention that there is a :channel key 
    # which points to an array of subhash for both channels which looks like:
    #   parameters = {:channel [ {range: 0.1, chan_impendance: 50, ... }, {...} ]}
    def configure parameters
      self.horizontal parameters
      parameters[:channel].each_with_index{ |chan_param, i|    
        self.channel i, param
      } if parameters[:channel]
      self.trigger parameters
    end
  
  end
  
end