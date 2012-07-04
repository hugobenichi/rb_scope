module RbScope

  module API

    # Provide a type translator between Ruby::FFI and C for automatic code generation
    Types = {
      c: {
        p_char:   "char*",   
        p_int16:  "short*", 
        p_uint16: "unsigned short*",  
        p_int32:  "ViInt32*",   #ViInt32 might be changed into long by visatype.h
        p_uint32: "ViUInt32*",  #ViUInt32 might be changed into unsigned long by visatype.h
        p_double: "double*",
        pointer:  "void*",
        int16:    "short",
        int32:    "int",
        uint16:   "unsigned short",
        uint32:   "unsigned int"
      },
      ruby: {
        p_char:   :pointer, 
        p_int16:  :pointer,   
        p_int32:  :pointer,
        p_uint16: :pointer,
        p_uint32: :pointer,
        p_double: :pointer
      }
    }

    # Contains a partial list of the signature of the niScope.h functions
    # This array is used by rb_scope/api/niScope_api.rb to dynamically attach the niScope function to Ruby
    # It is also used by ext/rb_scope/generators/wrapper_generator to construct a statically linked dll that Ruby::FFI can link to
    Template =  [      
      ## open/close ##
    
      [:niScope_init,   
        [ :p_char,                      # device address(char*) 
          :uint16,                      # perform an Id query ?
          :uint16,                      # reset device ?
          :p_uint32                     # pointer to session id (uint32*)
        ],  
        :int32 ],
        
      [:niScope_close,  
        [ :uint32],                     # session id 
        :int32],
 
 
      ## configurationg ##  
        
      [:niScope_CalSelfCalibrate, 
        [ :uint32,                      # session id 
          :p_char,                      # channel list (const char*) 
          :int32                        # option (VI_NULL for normal self-cal)
        ], 
         :int32],
         
      [:niScope_ConfigureAcquisition,
        [ :uint32,                      # session id  
          :int32                        # acq type (NISCOPE_VAL_NORMAL)
        ],
        :int32],
        
      [:niScope_ConfigureTriggerDigital,
        [ :uint32,                      # session id 
          :p_char,                      # trig src (const char*) NISCOPE_VAL_EXTERNAL
          :int32,                       # slope (rising or falling edge) NISCOPE_VAL_POSITIVE
          :double,                      # holdoff (dead time)
          :double                       # delay before acquisition
        ],
        :int32],
        
      [:niScope_ConfigureTriggerEdge,
        [ :uint32,                      # session id  
          :p_char,                      # trig src (const char*) NISCOPE_VAL_EXTERNAL
          :double,                      # voltage value
          :int32,                       # slope (rising or falling) NISCOPE_VAL_POSITIVE
          :int32,                       # trig coupling (NISCOPE_VAL_DC)
          :double,                      # holdoff
          :double                       # delay
        ],
        :int32],
        
      [:niScope_ConfigureTriggerImmediate,
        [ :uint32],                     # session id 
        :int32],
        
      [:niScope_ConfigureChanCharacteristics,
        [ :uint32,                      # session id  
          :p_char,                      # channel list (const char*)
          :double,                      # input impedance (50 / 1000000)
          :double                       # bandwidth
        ],
        :int32],
        
      [:niScope_ConfigureVertical,
        [ :uint32,                      # session id  
          :p_char,                      # channel list (const char*)
          :double,                      # voltage range
          :double,                      # voltage offset (0.0)
          :int32,                       # coupling
          :double,                      # probe attenuation (1.0)
          :uint16                       # enable (VI_TRUE)
        ],
        :int32],
        
      [:niScope_ConfigureHorizontalTiming,
        [ :uint32,                      # session id  
          :double,                      # sample rate
          :int32,                       # num pts per frame
          :double,                      # reference event position as a % 
          :int32,                       # num record (# of frames)
          :uint16                       # real_time (VI_TRUE)
        ],
        :int32],
        
      [:niScope_ActualRecordLength,
        [ :uint32,                      # session id  
          :p_int32,                     # output val (int*)
        ],
        :int32],
        
      [:niScope_ActualNumWfms,
        [ :uint32,                      # session id  
          :p_char,                      # channel list (const char*)
          :p_int32                      # output val (int32*)
        ],
        :int32],
         

      ## getters ##
         
      [:niScope_GetAttributeViBoolean,
        [ :uint32,                      # session id
          :p_char,                      # channel list (const char*)
          :uint32,                      # attribute id
          :p_uint16                     # output val (uint16*)
        ],
        :int32],
        
      [:niScope_GetAttributeViInt32,
        [ :uint32,                      # session id
          :p_char,                      # channel list (const char*)
          :uint32,                      # attribute id
          :p_int32                      # output val (int32*)
        ],
        :int32],
        
      [:niScope_GetAttributeViReal64,
        [ :uint32,                      # session id
          :p_char,                      # channel list (const char*)
          :uint32,                      # attribute id
          :p_double                     # output val (double*)
        ],
        :int32],
        
      [:niScope_GetAttributeViString,
        [ :uint32,                      # session id
          :p_char,                      # channel list (const char*)
          :uint32,                      # attribute id
          :int32,                       # buffer size
          :p_char,                      # buffer (char*)
        ],
        :int32],
        
        
      ## setters ##  
      
      [:niScope_SetAttributeViBoolean,
        [ :uint32,                      # session id
          :p_char,                      # channel list (const char*)
          :uint32,                      # attribute id
          :uint16                       # value
        ],
        :int32],

      [:niScope_SetAttributeViInt32,
        [ :uint32,                      # session id
          :p_char,                      # channel list (const char*)
          :uint32,                      # attribute id
          :int32                        # value
        ],
        :int32],

      [:niScope_SetAttributeViReal64,
        [ :uint32,                      # session id
          :p_char,                      # channel list (const char*)
          :uint32,                      # attribute id
          :double                       # value
        ],
        :int32],

      [:niScope_SetAttributeViString,
        [ :uint32,                      # session id
          :p_char,                      # channel list (const char*)
          :uint32,                      # attribute id
          :p_char                       # value (const char*)
        ],
        :int32],
        
        
      ## error handling functions ##
        
      [:niScope_errorHandler,
        [ :uint32,                      # session id 
          :int32,                       # error code
          :p_char,                      # error source buffer (char*)
          :p_char                       # error desc buffer (char*)
        ],
        :int32],
        
      [:niScope_GetError,
        [ :uint32,                      # session id
          :p_int32,                     # error code output (int32*)
          :int32,                       # buffer size
          :p_char                       # buffer for error (char*)
        ],
        :int32],
        
      [:niScope_GetErrorMessage,
        [ :uint32,                      # session id
          :int32,                       # error code
          :int32,                       # buffer size
          :p_char                       # buffer for error msg (char*)
        ],
        :int32],
        
   
      ## acquisition functions ##
   
      [:niScope_InitiateAcquisition,
        [ :uint32],                     # session id          
        :int32],

      [:niScope_AcquisitionStatus,
        [ :uint32,                      # session id
          :p_int32                      # output acquisition status (int32*)
        ],
        :int32],
        
      # <TO_DO> check timeout error, if so, abort and go back to idle state      
      [:niScope_FetchBinary8,
        [ :uint32,                      # session id
          :p_char,                      # channel list (const char*)
          :double,                      # timeout (0: available, -1: inf)
          :int32,                       # numSamples to fetch (-1 fetch all)
          :p_char,                      # pointer to buffer (signed int8*)
          :pointer,                     # timing info (struct niScope_wfmInfo*)
        ],  
        :int32],
        
      [:niScope_FetchBinary16,
        [ :uint32,                      # session id
          :p_char,                      # channel list (const char*)
          :double,                      # timeout (0: available, -1: inf)
          :int32,                       # numSamples to fetch (-1 fetch all)
          :p_int16,                     # pointer to buffer (signed int16*)
          :pointer,                     # timing info (struct niScope_wfmInfo*)
        ],  
        :int32],
        
      #Aborts an acquisition and returns the digitizer to the Idle state. 
      #Call this function if the digitizer times out waiting for a trigger.         
      [:niScope_Abort,
        [ :uint32],                     # session id       
        :int32],   
      
    ]
  
  end
  
end
