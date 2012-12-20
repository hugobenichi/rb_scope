module RbScope

    class Session 

        class << self; attr_reader :defaults end

        # This table says which methods from the niScope dll
        # are hooked to instances of the Session class.
        # Arguments are passed to each methods with an Hash
        niscope_methods = [
            [:calibrate,    "CalSelfCalibrate", 
                ["0,1", 0]],
            [:acquire,      "InitiateAcquisition", 
                []],
            [:stop,         "Abort", 
                []],
            [:trig_now,     "ConfigureTriggerImmediate", 
                []],
            [:trig_soft,    "ConfigureTriggerImmediate", 
                []],
            [:trig_digi,    "ConfigureTriggerDigital",
                [API::Values::NISCOPE_VAL_EXTERNAL, :slope, :deadtime, 0.0]],
            [:trig_edge,    "ConfigureTriggerEdge",
                [API::Values::NISCOPE_VAL_EXTERNAL, :level, :slope, :coupling, :deadtime, 0.0]],
            [:vertical,     "ConfigureVertical",
                [:channel, :range, 0.0, :coupling, 1.0, 1]],
            [:channel,      "ConfigureChanCharacteristics",
                [:channel, :impedance, :bandwidth]],
            [:horizontal,   "ConfigureHorizontalTiming",
                [:rate, :points, :position, :records, 1]],
        ]

        # this block of code does the actual patching
        # for each method declared in niscope_methods, 
        # it dynamically defines a dispatch method
        # which sets arguments according to the info found in niscope_methods
        niscope_methods.each do |symbol, meth, signature|
            define_method(symbol) do |inputs={}|
                check API::send "rbScope_#{meth}".to_sym , *args_chain(signature, inputs)
                self
            end
        end

        # builds the actual args from the method signature
        # if x is a symbol check for input in params
        # if not in params use default
        # if not a symbol use x in place of the value
        def args_chain sign, params
            [@visa_id] + sign.map{ |x| (params[x]||defaults[x] if x.is_a? Symbol ) || x }
        end

        # protects method from name overwrite
        alias_method :horizontal_dispatch, :horizontal
        alias_method :channel_dispatch, :channel
        
        # helper method for horizontal configuration
        def horizontal param
            @points = param[:points] || defaults[:points]
            horizontal_dispatch param
        end
    
        # helper method for vertical configuration
        def channel i, param
            param.clone.tap{ |hash| 
                hash[:channel] = i.to_s
                self.channel_dispatch hash
                self.vertical hash
            }
        end
    
        # helper method for trigger configuration
        def trigger param
            self.send "trig_#{param[:type] || :edge}".to_sym, param
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

        # default values for parameters of configuration functions
        @defaults = {
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

    end

end
