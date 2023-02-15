CreateWindowExA PROTO  
DefWindowProcA PROTO  
DispatchMessageA PROTO  
ExitProcess PROTO  
GetWindowTextA PROTO  
GetMessageA PROTO  
GetModuleHandleA PROTO  
GetWindowRect PROTO  
IsDialogMessageA PROTO  
InvalidateRect PROTO  
KillTimer PROTO  
LoadImageA PROTO  
PostQuitMessage PROTO  
RegisterClassExA PROTO  
ShowWindow PROTO  
SetWindowTextA PROTO  
TranslateMessage PROTO  
UpdateWindow PROTO  
BeginPaint PROTO  
EndPaint PROTO  
SetTimer PROTO  
SetDCBrushColor PROTO  
GetStockObject PROTO  
SelectObject PROTO  
SetDCPenColor PROTO  
SelectObject PROTO  
GetCommandLineA PROTO 
LoadCursorA PROTO  
Ellipse PROTO  
CreatePen PROTO    
CreateBrushIndirect PROTO  

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
WM_DESTROY                           equ 2h
WM_PAINT                             equ 0Fh
WS_EX_COMPOSITED    EQU 2000000h
WS_OVERLAPPEDWINDOW EQU 0CF0000h
WS_VISIBLE          EQU 10000000h
WS_CHILD            EQU 40000000h
WS_BORDER           EQU 00800000h
WM_COMMAND          EQU 0111h
WM_CREATE           EQU 0001h
WM_TIMER            EQU 0113h
EN_CHANGE           EQU 0300h
SS_LEFT             EQU 00000010h
WS_EX_CLIENTEDGE	EQU 00000200h
BS_SOLID            equ 0
COLOR_RED			equ	0ffh
COLOR_BLACK			equ	0
COLOR_WHITE			EQU	0ffffffh
PS_SOLID                             equ 0

RECT STRUCT
  left    DWORD      ?
  top     DWORD      ?
  right   DWORD      ?
  bottom  DWORD      ?
RECT ENDS

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

PAINTSTRUCT STRUCT
  hdc           QWORD      ?
  fErase        DWORD      ?
  rcPaint		RECT       <>
  fRestore      DWORD      ?
  fIncUpdate    DWORD      ?
  rgbReserved   BYTE 32 dup(?)
PAINTSTRUCT ENDS

LOGBRUSH STRUCT
  lbStyle  DWORD      ?
  lbColor  DWORD      ?
  lbHatch  QWORD      ?
LOGBRUSH ENDS