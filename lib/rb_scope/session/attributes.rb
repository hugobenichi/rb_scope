module RbScope

  class Session 
  
    Attribute_Types = {
      int:      "Int32",
      int32:    "Int32",     
      bool:     "Boolean",
      uint16:   "Boolean",
      boolean:  "Boolean",     
      real64:   "Real64",
      double:   "Real64",
      float:    "Real64",
      string:   "String",
      pchar:    "String"
    }

    Pointer_Types = [
      int:      :int32,
      int32:    :int32,     
      bool:     :uint16,
      uint16:   :uint16,
      boolean:  :uint16,     
      real64:   :double,
      double:   :double,
      float:    :double,
      string:   :string,
      pchar:    :string
    ]
    
    # gives the actual lengtt of one measured frame
    def actual_points
      p = FFI::MemoryPointer.new :int32, 1
      check API::rbScope_ActualRecordLength( @visa_id, p)
      p.read_int32
    end

    # gives the actual number of recorded waveform
    def actual_records chan = "0,1"
      p = FFI::MemoryPointer.new :int32, 1
      check API::rbScope_ActualNumWfms( @visa_id, chan, p)
      p.read_int32    
    end
    
    # attributes getter
    def [] attrb_name = nil, attrb_type = nil
      if attrb_name && attrb_type
        getter   = "rbScope_GetAttributeVi%s" % Attribute_Types[attrb_type]
        attrb_id = API::Values.const_get "NISCOPE_ATTR_#{attrb_name}".to_sym
        store_t = Pointer_Types[attrb_type]
        store   = FFI::MemoryPointer.new store_t, case store_t
          when :string then 128
          when :double then 2
          else 1
        end
        check API.send setter, @visa_id, nil, attrb_name, store      
        case store_t
          when :int32  then store.read_int32
          when :uint16 then store.read_uint16
          when :double then store.read_double
          when :string then store.read_string 
        end
      end
    end

    # attributes setter    
    def []= attrb_name = nil, attrb_type = nil, attrb_value
      if attrb_name && attrb_type    
        setter   = "rbScope_SetAttributeVi#{Attribute_Types[attrb_type]}".to_sym
        attrb_id = API::Values.const_get "NISCOPE_ATTR_#{attrb_name}".to_sym
        check API.send setter, @visa_id, nil, attrb_id, attrb_value
        self
      end    
    end
    
  end
  
end