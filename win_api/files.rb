# encoding: utf-8

require(File.expand_path('../../lib/kernel32lib.rb',__FILE__))

# Kernel32Lib module
# Files
module Kernel32Lib
  extern 'void* CreateFile(char*,unsigned long,unsigned long,void*,unsigned long,unsigned long,void*)'
  extern 'void* CreateFileW(char*,unsigned long,unsigned long,void*,unsigned long,unsigned long,void*)'
  extern 'int CloseHandle(void*)'
  extern 'int GetFileInformationByHandle(void*,void*)'
  extern 'int FileTimeToSystemTime(void*,void*)'
  extern 'int GetFileTime(void*,void*,void*,void*)'

  INVALID_HANDLE_VALUE = 4294967295

  # Access rights constants
  FILE_READ_DATA = 1
  FILE_WRITE_DATA = 2
  FILE_APPEND_DATA = 4
  GENERIC_READ = 0x80000000
  GENERIC_WRITE = 0x40000000
  GENERIC_EXECUTE = 0x20000000
  GENERIC_ALL = 0x10000000

  # Share mode constants
  FILE_SHARE_0 = 0x00000000 # Prevents other processes from opening a file or device if they request delete, read, or write access.
  FILE_SHARE_DELETE = 0x00000004 # Enables subsequent open operations on a file or device to request delete access.
  FILE_SHARE_READ = 0x00000001 # Enables subsequent open operations on a file or device to request read access.
  FILE_SHARE_WRITE = 0x00000002 # Enables subsequent open operations on a file or device to request write access.

  # Creation disposition constants
  CREATE_ALWAYS = 2 # Creates a new file, always.
  CREATE_NEW = 1 # Creates a new file, only if it does not already exist.
  OPEN_ALWAYS = 4 # Opens a file, always.
  OPEN_EXISTING = 3 # Opens a file or device, only if it exists.
  TRUNCATE_EXISTING = 5 # Opens a file and truncates it so that its size is zero bytes, only if it exists

  # CreateFile flags and attributes constants
  FILE_ATTRIBUTE_READONLY = 1 # The file is read only. Applications can read the file, but cannot write to or delete it.
  FILE_ATTRIBUTE_HIDDEN = 2 # The file is hidden. Do not include it in an ordinary directory listing.
  FILE_ATTRIBUTE_SYSTEM = 4 # The file is part of or used exclusively by an operating system.
  FILE_ATTRIBUTE_DIRECTORY = 16 # The handle that identifies a directory.
  FILE_ATTRIBUTE_ARCHIVE = 32 # The file should be archived. Applications use this attribute to mark files for backup or removal.
  FILE_ATTRIBUTE_NORMAL = 128 # The file does not have other attributes set. This attribute is valid only if used alone.
  FILE_ATTRIBUTE_TEMPORARY = 256 # The file is being used for temporary storage.
  FILE_ATTRIBUTE_OFFLINE = 4096 # The data of a file is not immediately available.
  FILE_ATTRIBUTE_ENCRYPTED = 16384 # The file or directory is encrypted.

  FILE_FLAG_BACKUP_SEMANTICS = 0x02000000 # The file is being opened or created for a backup or restore operation.
  FILE_FLAG_DELETE_ON_CLOSE = 0x04000000 # The file is to be deleted immediately after all of its handles are closed, which includes the specified handle and any other open or duplicated handles.
  FILE_FLAG_NO_BUFFERING = 0x20000000 # The file or device is being opened with no system caching for data reads and writes.
  FILE_FLAG_OPEN_NO_RECALL = 0x00100000 # The file data is requested, but it should continue to be located in remote storage.
  FILE_FLAG_OPEN_REPARSE_POINT = 0x00200000 # Normal reparse point processing will not occur; CreateFile will attempt to open the reparse point.
  FILE_FLAG_OVERLAPPED = 0x40000000 # The file or device is being opened or created for asynchronous I/O.
  FILE_FLAG_POSIX_SEMANTICS = 0x0100000 # Access will occur according to POSIX rules.
  FILE_FLAG_RANDOM_ACCESS = 0x10000000 # Access is intended to be random.
  FILE_FLAG_SESSION_AWARE = 0x00800000 # The file or device is being opened with session awareness.
  FILE_FLAG_SEQUENTIAL_SCAN = 0x08000000 # Access is intended to be sequential from beginning to end.
  FILE_FLAG_WRITE_THROUGH = 0x80000000 # Write operations will not go through any intermediate cache, they will go directly to disk.

  # CreateFile (retrieve metadata only)
  def self.create_file_metadata(file_path)
    begin
      Kernel32Lib.CreateFile(file_path.encode('ascii-8bit'),Kernel32Lib::GENERIC_READ,Kernel32Lib::FILE_SHARE_READ | Kernel32Lib::FILE_SHARE_WRITE,nil,Kernel32Lib::OPEN_EXISTING,0,nil)
    rescue Encoding::UndefinedConversionError
      Kernel32Lib.CreateFileW(file_path.encode('utf-16le'),Kernel32Lib::GENERIC_READ,Kernel32Lib::FILE_SHARE_READ | Kernel32Lib::FILE_SHARE_WRITE,nil,Kernel32Lib::OPEN_EXISTING,0,nil)
    end
  end

  # FileTimeToSystemTime
  def self.file_time_to_system_time(file_time)
    lp_system_time = '0'*16
    Kernel32Lib.FileTimeToSystemTime(file_time,lp_system_time)
    lp_system_time = lp_system_time.unpack('S8')
    Time.mktime(lp_system_time[0],lp_system_time[1],lp_system_time[3],lp_system_time[4],lp_system_time[5],lp_system_time[6]+lp_system_time[7]/1000)
  end

  # GetFileInformationByHandle
  def self.get_file_information_by_handle(file_path)
    lp_file_information = '0'*52

    handle = create_file_metadata(file_path)
    raise Kernel32Lib::Error, Kernel32Lib.get_last_error_message if handle.to_i == Kernel32Lib::INVALID_HANDLE_VALUE

    result = Kernel32Lib.GetFileInformationByHandle(handle,lp_file_information)
    raise Kernel32Lib::Error, Kernel32Lib.get_last_error_message if result == 0

    Kernel32Lib.CloseHandle(handle)

    lp_file_information = lp_file_information.unpack('I13')
    {
      file_path: file_path,
      file_attributes: lp_file_information[0],
      creation_time: Kernel32Lib.file_time_to_system_time(lp_file_information[1,2].pack('I2')),
      last_access_time: Kernel32Lib.file_time_to_system_time(lp_file_information[3,4].pack('I2')),
      last_write_time: Kernel32Lib.file_time_to_system_time(lp_file_information[5,6].pack('I2')),
      volume_serial_number: lp_file_information[7],
      file_size_high: lp_file_information[8],
      file_size_low: lp_file_information[9],
      number_of_links: lp_file_information[10],
      file_index_high: lp_file_information[11],
      file_index_low: lp_file_information[12]
    }
  end

  # GetFileTime
  def self.get_file_time(file_path)
    lp_creation_time = '0'*8
    lp_access_time = '0'*8
    lp_write_time = '0'*8


    #handle = Kernel32Lib.CreateFile(file_path,Kernel32Lib::GENERIC_READ,Kernel32Lib::FILE_SHARE_READ | Kernel32Lib::FILE_SHARE_WRITE,nil,Kernel32Lib::OPEN_EXISTING,0,nil)
    handle = create_file_metadata(file_path)
    raise Kernel32Lib::Error, Kernel32Lib.get_last_error_message if handle.to_i == Kernel32Lib::INVALID_HANDLE_VALUE

    result = Kernel32Lib.GetFileTime(handle,lp_creation_time,lp_access_time,lp_write_time)
    raise Kernel32Lib::Error, Kernel32Lib.get_last_error_message if result == 0

    Kernel32Lib.CloseHandle(handle)

    lp_creation_time = lp_creation_time.unpack('I2')
    lp_access_time = lp_access_time.unpack('I2')
    lp_write_time = lp_write_time.unpack('I2')

    {
        file_path: file_path,
        creation_time: Kernel32Lib.file_time_to_system_time(lp_creation_time.pack('I2')),
        last_access_time: Kernel32Lib.file_time_to_system_time(lp_access_time.pack('I2')),
        last_write_time: Kernel32Lib.file_time_to_system_time(lp_write_time.pack('I2')),
    }
  end
end
