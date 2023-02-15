GetStdHandle proto
WriteFile proto
DestroyWindow proto
SendMessageA proto
CreateWindowExA proto
DefWindowProcA proto
DispatchMessageA proto
ExitProcess proto
GetWindowTextA proto
GetMessageA proto
GetModuleHandleA proto
IsDialogMessageA proto
InvalidateRect proto
KillTimer proto
PostQuitMessage proto
RegisterClassExA proto
ShowWindow proto
SetWindowTextA proto
TranslateMessage proto
UpdateWindow proto
SetTimer proto
EnumWindows proto
GetWindowThreadProcessId proto
IsWindowVisible proto
GetClassNameA proto
OpenProcess proto
TerminateProcess proto
CloseHandle proto
GetCommandLineA proto
LoadCursorA proto

COLOR_WINDOW        EQU 5                       
CS_BYTEALIGNWINDOW  EQU 2000h
CS_HREDRAW          EQU 2
CS_VREDRAW          EQU 1
CW_USEDEFAULT       EQU 80000000h
IDC_ARROW           EQU 7F00h
IDI_APPLICATION     EQU 7F00h
IMAGE_CURSOR        EQU 2
IMAGE_ICON          EQU 1
LR_SHARED           EQU 8000h
NULL                EQU 0
SW_SHOWNORMAL       EQU 1
WM_DESTROY          EQU 2
WM_PAINT            EQU 15
WS_EX_COMPOSITED    EQU 2000000h
WS_OVERLAPPEDWINDOW EQU 0CF0000h
WS_VISIBLE          EQU 010000000h
WS_CHILD            EQU 040000000h
WS_BORDER           EQU 00800000h
WM_COMMAND          EQU 0111h
WM_CREATE           EQU 0001h
WM_TIMER            EQU 0113h
EN_CHANGE           EQU 0300h
SS_LEFT             EQU 00000010h
WS_EX_CLIENTEDGE equ 00000200h

WNDCLASSEXA STRUCT
  cbSize            DWORD      ?
  style             DWORD      ?
  lpfnWndProc       QWORD      ?
  cbClsExtra        DWORD      ?
  cbWndExtra        DWORD      ?
  hInstance         QWORD      ?
  hIcon             QWORD      ?
  hCursor           QWORD      ?
  hbrBackground     QWORD      ?
  lpszMenuName      QWORD      ?
  lpszClassName		QWORD      ?
  hIconSm           QWORD      ?
WNDCLASSEXA ENDS

POINT STRUCT
  x  DWORD ?
  y  DWORD ?
POINT ENDS

MSG STRUCT
  hwnd      QWORD      ?
  message   QWORD      ?
  wParam    QWORD      ?
  lParam    QWORD      ?
  time      DWORD      ?
  pt        POINT      <>
  lPrivate	DWORD	   ?
MSG ENDS