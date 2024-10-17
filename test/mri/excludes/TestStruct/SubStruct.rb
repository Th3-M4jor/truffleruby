exclude :test_attrset_id, "ArgumentError expected but nothing was raised."
exclude :test_inspect, "Expected /^#<struct a=#<struct #<.*?>:...>>$/ to match \"#<struct a=[...]>\"."
exclude :test_keyword_args_warning, "<{:a=>1}> expected but was <nil>."
exclude :test_larger_than_largest_pool, "NameError: uninitialized constant GC::INTERNAL_CONSTANTS"
exclude :test_nonascii, "Expected /redefining constant TestStruct::SubStruct::SubStruct::R\\u{e9}sum\\u{e9}/ to match \"/b/b/e/main/test/mri/tests/ruby/test_struct.rb:390: warning: already initialized constant TestStruct::SubStruct::SubStruct::Résumé\\n\"."
exclude :test_parameters, "<[[:req, :_]]> expected but was <[[:req, :value]]>."
exclude :test_redefinition_warning, "Expected /redefining constant TestStruct::SubStruct::SubStruct::RedefinitionWarning/ to match \"/b/b/e/main/test/mri/tests/ruby/test_struct.rb:364: warning: already initialized constant TestStruct::SubStruct::SubStruct::RedefinitionWarning\\n\"."
