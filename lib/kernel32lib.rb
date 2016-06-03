# encoding: utf-8

require 'fiddle'
require 'fiddle/import'

# Kernel32Lib module
# supports kernel32 WinAPI functions
module Kernel32Lib
  extend Fiddle::Importer
  dlload 'kernel32.dll'
  extern 'unsigned long GetLastError(void)'

  # GetLastError
  def self.get_last_error
    Kernel32Lib.GetLastError(0)
  end
end
