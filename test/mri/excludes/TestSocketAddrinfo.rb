exclude :test_addrinfo_ip, "SocketError: Name or service not known"
exclude :test_addrinfo_new_inet, "<2> expected but was <0>."
exclude :test_addrinfo_new_unix, "NoMethodError: undefined method `bytesize' for nil:NilClass"
exclude :test_error_message, "NameError: uninitialized constant Socket::ResolutionError"
exclude :test_family_addrinfo, "NameError: uninitialized constant Socket::ResolutionError"
exclude :test_ipv6_address_predicates, "ai=Addrinfo.getaddrinfo(\"::0.0.0.2\", nil, :INET6, :DGRAM).fetch(0); ai.ipv4? || .ipv6_v4compat?"
exclude :test_socket_getnameinfo, "NoMethodError: undefined method `bytesize' for #<Addrinfo: 127.0.0.1:8888 UDP>"
