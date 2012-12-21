module RbScope

    class << self; attr_reader :attribute_types, :pointer_types end
        
    class Session 

        def with_int_p &block
            FFI::MemoryPointer.new(:int32, 1).tap{|p| block.call(p) }.read_int32
        end

        # gives the actual length of one measured frame
        def actual_points
            with_int_int{|p| check API::rbScope_ActualRecordLength(@visa_id, p) }
        end

        # gives the actual number of recorded waveform
        def actual_records chan="0,1"
            with_int_int{|p| check API::rbScope_ActualNumWfms(@visa_id, chan, p) }
        end

        # attributes getter TODO: check arity ??
        def [](attr_name=nil, attr_type=nil)
            return nil unless attr_name && attr_type
            getter  = "rbScope_GetAttributeVi%s" % RbScope.attribute_types[attr_type]
            attr_id = API::Values.const_get "NISCOPE_ATTR_#{attr_name}".to_sym
            store_t = RbScope.pointer_types[attr_type]
            store_l = ({string: 128, double: 2})[store_t] || 1
            store   = FFI::MemoryPointer.new store_t, store_l
            check API.send(getter, @visa_id, nil, attr_id, store)
            store.send "read_#{store_t}".to_sym
        end

        # attributes setter
        def []=(attr_name=nil, attr_type=nil, attr_value)
            return nil unless attr_name && attr_type
            setter  = "rbScope_SetAttributeVi%s" % RbScope.attribute_types[attr_type]
            attr_id = API::Values.const_get "NISCOPE_ATTR_#{attr_name}".to_sym
            check API.send(setter, @visa_id, nil, attr_id, attr_value)
        end

    end

    @attribute_types, @pointer_types = {}, {}

    type_symbols = {
        int:    ["Int32",   :int32],
        bool:   ["Boolean", :uint16],
        real:   ["Real64",  :double],
        strg:   ["String",  :string],
    }

    type_aliases = {
        int:    [:int, :int32],
        bool:   [:bool, :uint16, :boolean],
        real:   [:real64, :double, :float],
        strg:   [:string, :pchar]
    }

    type_aliases.each{ |type, aliases|
        ni_name, ffi_name = *type_symbols[type]
        aliases.each{ |alt|
            @attribute_types[alt] = ni_name
            @pointer_types[alt] = ffi_name
        }
    }

end
