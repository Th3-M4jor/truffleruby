file = 'src/main/ruby/truffleruby/core/truffle/ffi/pointer_access.rb'

code = <<RUBY
# frozen_string_literal: true

# Copyright (c) 2018, 2023 Oracle and/or its affiliates. All rights reserved. This
# code is released under a tri EPL/GPL/LGPL license. You can use it,
# redistribute it and/or modify it under the terms of the:
#
# Eclipse Public License version 2.0, or
# GNU General Public License version 2, or
# GNU Lesser General Public License version 2.1.

# Copyright (c) 2007-2015, Evan Phoenix and contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of Rubinius nor the names of its contributors
#   may be used to endorse or promote products derived from this software
#   without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# GENERATED BY #{__FILE__}

class Truffle::FFI::Pointer
RUBY

SIZEOF = {
  char: 1,
  short: 2,
  int: 4,
  long: 8,
  float: 4,
  double: 8,
  pointer: 8
}

{
  char: ['int8'],
  short: ['int16'],
  int: ['int32'],
  long: ['int64', 'long_long'],
  float: ['float32'],
  double: ['float64'],
  pointer: [],
}.each_pair do |base_type, aliases|
  integer_type = aliases.any? { |as| as.start_with?('int') }
  [
      '',
      *('u' if integer_type)
  ].each do |prefix|
    type = "#{prefix}#{base_type}"
    aliases = aliases.map { |as| "#{prefix}#{as}" }

    add_aliases = -> meth {
      aliases.each do |as|
        code << "  alias_method :#{meth}_#{as}, :#{meth}_#{type}\n"
      end
      code << "\n"
    }

    code << "  # #{[type, *aliases].join(', ')}\n\n"

    transform = -> value { value }

    if base_type == :pointer
      transform = -> value { "get_pointer_value(#{value})" }
      code << <<-RUBY
  private def get_pointer_value(value)
    if Truffle::FFI::Pointer === value
      value.address
    elsif nil.equal?(value)
      0
    elsif Integer === value
      value
    elsif value.respond_to?(:to_ptr)
      value.to_ptr.address
    else
      raise ArgumentError, "\#{value} is not a pointer"
    end
  end

RUBY
    elsif integer_type
      transform = -> value { "Primitive.rb_to_int(#{value})" }
    else
      transform = -> value { "Truffle::Type.rb_to_f(#{value})" }
    end

    code << <<-RUBY
  def read_#{type}
    check_bounds(0, #{SIZEOF[base_type]})
    Primitive.pointer_read_#{type} address
  end
RUBY
    add_aliases.call(:read)

    code << <<-RUBY
  def write_#{type}(value)
    check_bounds(0, #{SIZEOF[base_type]})
    Primitive.pointer_write_#{type} address, #{transform.call('value')}
    self
  end
RUBY
    add_aliases.call(:write)

    code << <<-RUBY
  def get_#{type}(offset)
    check_bounds(offset, #{SIZEOF[base_type]})
    Primitive.pointer_read_#{type} address + offset
  end
RUBY
    add_aliases.call(:get)

    code << <<-RUBY
  def put_#{type}(offset, value)
    check_bounds(offset, #{SIZEOF[base_type]})
    Primitive.pointer_write_#{type} address + offset, #{transform.call('value')}
    self
  end
RUBY
    add_aliases.call(:put)

    # arrays

    code << <<-RUBY
  def read_array_of_#{type}(length)
    check_bounds(0, length * #{SIZEOF[base_type]})
    Array.new(length) do |i|
      Primitive.pointer_read_#{type} address + (i * #{SIZEOF[base_type]})
    end
  end
RUBY
    add_aliases.call(:read_array_of)

    code << <<-RUBY
  def write_array_of_#{type}(ary)
    Truffle::Type.rb_check_type(ary, ::Array)
    check_bounds(0, ary.size * #{SIZEOF[base_type]})
    ary.each_with_index do |value, i|
      Primitive.pointer_write_#{type} address + (i * #{SIZEOF[base_type]}), #{transform.call('value')}
    end
    self
  end
RUBY
    add_aliases.call(:write_array_of)

    code << <<-RUBY
  def get_array_of_#{type}(offset, length)
    (self + offset).read_array_of_#{type}(length)
  end
RUBY
    add_aliases.call(:get_array_of)

    code << <<-RUBY
  def put_array_of_#{type}(offset, ary)
    (self + offset).write_array_of_#{type}(ary)
    self
  end
RUBY
    add_aliases.call(:put_array_of)

  end
end

code << "end\n"

File.write(file, code)
