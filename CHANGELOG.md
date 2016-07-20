## 0.0.3 (Jul 9, 2016)

Features:
    - add WinAPI error codes translation (0-499)
    - add support file path in UNICODE

Bugfixes:
    - check file path encoding

## 0.0.2 (Jun 2, 2016)
Features:
- add WinAPI Consoles functions:
* GetStdHandle
* SetConsoleCursorPosition
* GetConsoleScreenBufferInfo
* SetConsoleScreenBufferSize
* SetConsoleWindowInfo
* SetConsoleTextAttribute
* GetConsoleOutputCP
* SetConsoleOutputCP
Bugfixes:
- check get_file_information_by_handle

## 0.0.1 (Jun 1, 2016)
Features:
- add WinAPI Files functions:
* CreateFile
* CloseHandle
* GetFileInformationByHandle
* FileTimeToSystemTime
* GetFileTime
- add module Fixture (fixture for test)
Bugfixes:
- initial release
