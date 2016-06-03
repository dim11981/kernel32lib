# Kernel32Lib: kernel32lib

Win32 API wrapper for Ruby which uses Fiddle and Fiddle::Importer

## Installation and usage

install:
```
gem install kernel32lib
```
usage:
```ruby
  require 'kernel32lib/files'
  require 'kernel32lib/consoles'

  # call Kernel32Lib.function_name(function_params (optional)...)
  # e.g.
  Kernel32Lib.get_file_information_by_handle(__FILE__)
  # or
  Kernel32Lib.get_console_output_cp
```
see more detailed example in ./fixtures/fixture_kernel32lib.rb

## Troubleshooting

Visit to [kernel32lib homepage](https://github.com/dim11981/kernel32lib)
