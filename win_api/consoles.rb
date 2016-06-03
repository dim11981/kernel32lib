# encoding: utf-8

require(File.expand_path('../../lib/kernel32lib.rb',__FILE__))

# Kernel32Lib module
# Consoles
module Kernel32Lib
  extern 'void* GetStdHandle(unsigned long)'
  extern 'int SetConsoleCursorPosition(void*,void*)'
  extern 'int GetConsoleScreenBufferInfo(void*,void*)'
  extern 'int SetConsoleScreenBufferSize(void*,void*)'
  extern 'int SetConsoleWindowInfo(void*,void,void*)'
  extern 'int SetConsoleTextAttribute(void*,unsigned long)'
  extern 'unsigned int GetConsoleOutputCP(void)'
  extern 'int SetConsoleOutputCP(unsigned int)'

  STD_INPUT_HANDLE = -10
  STD_OUTPUT_HANDLE = -11
  STD_ERROR_HANDLE = -12

  # Attributes flags:
  FOREGROUND_BLUE = 0x0001 # text color contains blue.
  FOREGROUND_GREEN = 0x0002 # text color contains green.
  FOREGROUND_RED = 0x0004 # text color contains red.
  FOREGROUND_WHITE = 0x0007 # text color contains white on black background.
  FOREGROUND_INTENSITY = 0x0008 # text color is intensified.
  BACKGROUND_BLUE = 0x0010 # background color contains blue.
  BACKGROUND_GREEN = 0x0020 # background color contains green.
  BACKGROUND_RED = 0x0040 # background color contains red.
  BACKGROUND_WHITE = 0x0070 # background color contains white with black foreground.
  BACKGROUND_INTENSITY = 0x0080 # background color is intensified.
  COMMON_LVB_LEADING_BYTE = 0x0100 # Leading Byte of DBCS
  COMMON_LVB_TRAILING_BYTE = 0x0200 # Trailing Byte of DBCS
  COMMON_LVB_GRID_HORIZONTAL = 0x0400 # DBCS: Grid attribute: top horizontal.
  COMMON_LVB_GRID_LVERTICAL = 0x0800 # DBCS: Grid attribute: left vertical.
  COMMON_LVB_GRID_RVERTICAL = 0x1000 # DBCS: Grid attribute: right vertical.
  COMMON_LVB_REVERSE_VIDEO = 0x4000 # DBCS: Reverse fore/back ground attribute.
  COMMON_LVB_UNDERSCORE = 0x8000 # DBCS: Underscore.
  COMMON_LVB_SBCSDBCS = 0x0300 # SBCS or DBCS flag.

  # SetConsoleCursorPosition
  def self.set_console_cursor_position(console_output,cursor_position)
    lp_cursor_position = cursor_position.pack('s2')
    Kernel32Lib.SetConsoleCursorPosition(console_output,lp_cursor_position.unpack('i')[0].to_i)
  end

  # GetConsoleScreenBufferInfo
  def self.get_console_screen_buffer_info(console_output)
    lp_console_screen_buffer_info = '0'*22
    Kernel32Lib.GetConsoleScreenBufferInfo(console_output,lp_console_screen_buffer_info)
    lp_console_screen_buffer_info = lp_console_screen_buffer_info.unpack('s4Ss4s2')
    console_screen_buffer_info = {
        size: [ lp_console_screen_buffer_info[0].to_i, lp_console_screen_buffer_info[1].to_i ],
        cursor_position: [ lp_console_screen_buffer_info[2], lp_console_screen_buffer_info[3].to_i ],
        attributes: lp_console_screen_buffer_info[4].to_i,
        window: [ lp_console_screen_buffer_info[5].to_i, lp_console_screen_buffer_info[6].to_i, lp_console_screen_buffer_info[7].to_i, lp_console_screen_buffer_info[8].to_i ],
        maximum_window_size: [ lp_console_screen_buffer_info[9].to_i, lp_console_screen_buffer_info[10].to_i ]
    }
    console_screen_buffer_info
  end

  # SetConsoleTextAttribute
  def self.set_console_text_attribute(console_output,attributes)
    Kernel32Lib.SetConsoleTextAttribute(console_output,attributes)
  end

  # GetStdHandle
  def self.get_std_handle(std_handle)
    Kernel32Lib.GetStdHandle(std_handle)
  end

  # GetConsoleOutputCP
  def self.get_console_output_cp
    Kernel32Lib.GetConsoleOutputCP(0)
  end

  # SetConsoleOutputCP
  def self.set_console_output_cp(code_page_id)
    Kernel32Lib.SetConsoleOutputCP(code_page_id)
  end

  # SetConsoleScreenBufferSize
  def self.set_console_screen_buffer_size(console_output,size)
    lp_size = size.pack('s2')
    Kernel32Lib.SetConsoleScreenBufferSize(console_output,lp_size.unpack('i')[0].to_i)
  end

  # SetConsoleWindowInfo
  def self.set_console_window_info(console_output,absolute,console_window)
    lp_console_window = console_window.pack('s4')
    Kernel32Lib.SetConsoleWindowInfo(console_output,absolute,lp_console_window)
  end

end