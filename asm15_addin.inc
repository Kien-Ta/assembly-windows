CreateWindowExA PROTO  
DefWindowProcA PROTO  
DispatchMessageA PROTO  
GetWindowTextW PROTO  
ExitProcess PROTO
GetMessageA PROTO  
GetModuleHandleA PROTO  
IsDialogMessageA PROTO  
LoadImageA PROTO  
PostQuitMessage PROTO  
RegisterClassExA PROTO  
ShowWindow PROTO  
SetWindowTextW PROTO  
TranslateMessage PROTO  
UpdateWindow PROTO  
GetCommandLineA PROTO 
LoadCursorA PROTO  
GetWindowTextLengthW PROTO  

MessageBoxA PROTO
IFNDEF __UNICODE__
  MessageBox equ <MessageBoxA>
ENDIF

MessageBoxW PROTO 
IFDEF __UNICODE__
  MessageBox equ <MessageBoxW>
ENDIF
MB_OK                                equ 0h

COLOR_WINDOW        EQU 5                       
CS_BYTEALIGNWINDOW  EQU 02000h
CS_HREDRAW          EQU 2
CS_VREDRAW          EQU 1
CW_USEDEFAULT       EQU 080000000h
ES_READONLY         EQU 0800h
IDC_ARROW           EQU 07F00h
IDI_APPLICATION     EQU 07F00h
IMAGE_CURSOR        EQU 2
IMAGE_ICON          EQU 1
LR_SHARED           EQU 08000h
NULL                EQU 0
SW_SHOWNORMAL       EQU 1
WM_DESTROY          EQU 2
WS_EX_COMPOSITED    EQU 02000000h
WS_OVERLAPPEDWINDOW EQU 0CF0000h
WS_VISIBLE          EQU 010000000h
WS_CHILD            EQU 040000000h
WS_BORDER           EQU 00800000h
WM_COMMAND          EQU 0111h
WM_CREATE           EQU 0001h
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