exclude :test_io_buffer_pread_pwrite, "NameError: uninitialized constant TestFiberIOBuffer::Tempfile"
exclude :test_io_buffer_read_write, "NameError: uninitialized constant IO::Buffer"
exclude :test_read_nonblock, "NoMethodError: undefined method `set_scheduler' for Fiber:Class"
exclude :test_read_write_blocking, "NoMethodError: undefined method `set_scheduler' for Fiber:Class"
exclude :test_timeout_after, "NoMethodError: undefined method `set_scheduler' for Fiber:Class"
exclude :test_write_nonblock, "NoMethodError: undefined method `set_scheduler' for Fiber:Class"
