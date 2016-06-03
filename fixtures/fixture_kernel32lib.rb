# encoding: utf-8

#require 'kernel32lib'
require(File.expand_path('../../win_api/files',__FILE__))
require(File.expand_path('../../win_api/consoles',__FILE__))

# Fixture module
# test fixture
module Fixture
  def self.show
    system 'cls'
    puts '# get_file_information_by_handle'
    puts "  - file information: #{Kernel32Lib.get_file_information_by_handle(__FILE__)}"
    puts
    puts '# get_file_time'
    puts "  - file time: #{Kernel32Lib.get_file_time(__FILE__)}"
    puts
    puts '# try console'
    console_output = Kernel32Lib.GetStdHandle(Kernel32Lib::STD_OUTPUT_HANDLE)
    init_console_screen_buffer_info = Kernel32Lib.get_console_screen_buffer_info(console_output)
    init_attributes = init_console_screen_buffer_info[:attributes]
    init_screen_buffer_size = init_console_screen_buffer_info[:size]
    init_window = init_console_screen_buffer_info[:window]
    puts "  - console screen buffer info (1): #{init_console_screen_buffer_info}"
    puts "  - console output code page: #{Kernel32Lib.get_console_output_cp}"
    Kernel32Lib.set_console_window_info(console_output,true,[0,0,1,1])
    Kernel32Lib.set_console_screen_buffer_size(console_output,[120,80])
    Kernel32Lib.set_console_window_info(console_output,true,[0,0,70,25])
    Kernel32Lib.set_console_text_attribute(console_output,Kernel32Lib::FOREGROUND_GREEN | Kernel32Lib::FOREGROUND_INTENSITY | Kernel32Lib::BACKGROUND_BLUE)
    puts "  - console screen buffer info (2): #{Kernel32Lib.get_console_screen_buffer_info(console_output)}"
    9.times { print '.'; sleep(0.5) }
    Kernel32Lib.set_console_text_attribute(console_output,init_attributes.to_i)
    Kernel32Lib.set_console_window_info(console_output,true,[0,0,1,1])
    Kernel32Lib.set_console_screen_buffer_size(console_output,init_screen_buffer_size)
    Kernel32Lib.set_console_window_info(console_output,true,init_window)
    puts
  end

end