exclude :test_argument_count, "NoMethodError: undefined method `freed?' for #<#<Class:0x3a8>:0x418>"
exclude :test_argument_errors, "[TypeError] exception expected, not #<NoMethodError: undefined method `map' for 8:Integer>."
exclude :test_argument_type_conversion, "NotImplementedError: #<struct int=8, call_count=0> not implemented"
exclude :test_default_abi, "<:default_abi> expected but was <nil>."
exclude :test_function_as_method, "NotImplementedError: NotImplementedError"
exclude :test_function_as_proc, "NotImplementedError: NotImplementedError"
exclude :test_last_error, "Expected nil to not be nil."
exclude :test_name, "<\"sin\"> expected but was <nil>."
exclude :test_need_gvl?, "ArgumentError: unknown keyword: :need_gvl"
exclude :test_strcpy, "NotImplementedError: NotImplementedError"
