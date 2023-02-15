.386
.model flat, stdcall
option casemap: none

include asm13_addin.inc

WriteFile PROTO stdcall, \
        handle:dword,           \
        buffer:ptr byte,        \
        bytes:dword,            \
        written: ptr dword,     \
        overlapped: ptr byte 

GetStdHandle PROTO stdcall, device:dword

ExitProcess PROTO stdcall, exitcode:dword

ReadFile PROTO stdcall, \
        handle:dword,           \
        buffer:ptr byte,        \
        bytes:dword,            \
        written: ptr dword,     \
        overlapped: ptr byte 

SetConsoleMode  PROTO stdcall, handle:dword, dwMode:dword

StdOut PROTO stdcall, buffer:dword

StdIn  PROTO stdcall, buffer:dword

CreateFileA PROTO stdcall, :dword, :dword, :dword, :dword, :dword, :dword, :dword

CloseHandle PROTO stdcall, :dword

SetFilePointerEx PROTO stdcall, :dword, :dword, :dword, :dword, :dword

Display_byte PROTO stdcall, num:byte

Display_word PROTO stdcall, num:word

Display_dword PROTO stdcall, num:dword

Display_qword PROTO stdcall, numhigh:dword, numlow:dword

.data
    file_err    db      "Can't open file", 0
    PE_sig      DWORD   17744
    PE_deny     db      "This is not a PE file", 13, 10, 0
    dive        DWORD   16
    linenew     db      13, 10, 0
    initial     db      "File Path: ", 0
    hexa        db      "0123456789ABCDEF", 0
    temp2       DWORD    0
    handle      DWORD   0
    count       WORD    0
    section     WORD    0
    check       WORD    0
    looper      DWORD   0
    export_directory_va     DWORD   0
    import_directory_va     DWORD   0
    dos_header_addr     DWORD   0
    pe_header_addr      DWORD   0
    optional_header_addr    DWORD   0
    section_header_addr     DWORD   0
    import_sec      DWORD   0
    export_sec      DWORD   0
    section_raw_in      DWORD   0
    section_raw_ex      DWORD   0
    num_low     DWORD   0
    num_high    DWORD   0
    x86_or_x64  BYTE    0

    dos_header_w  db  "***DOS HEADER***", 13, 10, 0
    dos1    db  "e_magic:       0x", 0
    dos2    db  "e_cblp:        0x", 0
    dos3    db  "e_cp:          0x", 0
    dos4    db  "e_crlc:        0x", 0
    dos5    db  "e_cparhdr:     0x", 0
    dos6    db  "e_minalloc:    0x", 0
    dos7    db  "e_maxalloc:    0x", 0
    dos8    db  "e_ss:          0x", 0
    dos9    db  "e_sp:          0x", 0
    dos10   db  "e_csum:        0x", 0
    dos11   db  "e_ip:          0x", 0
    dos12   db  "e_cs:          0x", 0
    dos13   db  "e_lfarlc:      0x", 0
    dos14   db  "e_ovno:        0x", 0
    dos15   db  "e_res[0]:      0x", 0
    dos16   db  "e_res[1]:      0x", 0
    dos17   db  "e_res[2]:      0x", 0
    dos18   db  "e_res[3]:      0x", 0
    dos19   db  "e_oemid:       0x", 0
    dos20   db  "e_oeminfo:     0x", 0
    dos21   db  "e_res2[0]:     0x", 0
    dos22   db  "e_res2[1]:     0x", 0
    dos23   db  "e_res2[2]:     0x", 0
    dos24   db  "e_res2[3]:     0x", 0
    dos25   db  "e_res2[4]:     0x", 0
    dos26   db  "e_res2[5]:     0x", 0
    dos27   db  "e_res2[6]:     0x", 0
    dos28   db  "e_res2[7]:     0x", 0
    dos29   db  "e_res2[8]:     0x", 0
    dos30   db  "e_res2[9]:     0x", 0
    dos31   db  "e_lfanew:      0x", 0
    
    pe_header_w   db  "***PE HEADER***", 13, 10, 0
    pe1     db  "Signature:             0x", 0
    pe2     db  "Machine:               0x", 0
    pe3     db  "Num_of_sections:       0x", 0
    pe4     db  "TimeDateStamp:         0x", 0
    pe5     db  "PointerToSymbolTable:  0x", 0
    pe6     db  "NumberOfSymbols:       0x", 0
    pe7     db  "SizeOfOptionalHeader:  0x", 0
    pe8     db  "Characteristics:       0x", 0


    optional_header_w db  "***OPTIONAL HEADER***", 13, 10, 0
    optional1   db  "Magic:                             0x", 0
    optional2   db  "MajorLinkerVersion:                0x", 0
    optional3   db  "MinorLinkerVersion:                0x", 0
    optional4   db  "SizeOfCode:                        0x", 0
    optional5   db  "SizeOfInitializedData:             0x", 0
    optional6   db  "SizeOfUnitializedData:             0x", 0
    optional7   db  "AddressOfEntryPoint:               0x", 0
    optional8   db  "BaseOfCode:                        0x", 0 
    optional9   db  "BaseOfData:                        0x", 0
    optional10  db  "ImageBase:                         0x", 0
    optional11  db  "SectionAlignment:                  0x", 0
    optional12  db  "FileAlignment:                     0x", 0
    optional13  db  "MajorOperatingSystemVersion:       0x", 0
    optional14  db  "MinorOperatingSystemVersion:       0x", 0
    optional15  db  "MajorImageVersion:                 0x", 0
    optional16  db  "MinorImageVersion:                 0x", 0
    optional17  db  "MajorSubsystemVersion:             0x", 0
    optional18  db  "MinorSubsystemVersion:             0x", 0
    optional19  db  "Reserved1:                         0x", 0
    optional20  db  "SizeOfImage:                       0x", 0
    optional21  db  "SizeOfHeaders:                     0x", 0
    optional22  db  "Checksum:                          0x", 0
    optional23  db  "Subsystem:                         0x", 0
    optional24  db  "DllCharacteristics:                0x", 0
    optional25  db  "SizeOfStackReserve:                0x", 0
    optional26  db  "SizeOfStackCommit:                 0x", 0
    optional27  db  "SizeOfHeapReserve:                 0x", 0
    optional28  db  "SizeOfHeapCommit:                  0x", 0
    optional29  db  "LoaderFlags:                       0x", 0
    optional30  db  "NumberOfRvaAndSize:                0x", 0 
    optional31  db  "ExportDirectoryVA:                 0x", 0
    optional32  db  "ExportDirectorySize:               0x", 0
    optional33  db  "ImportDirectoryVA:                 0x", 0
    optional34  db  "ImportDirectorySize:               0x", 0
    optional35  db  "ResourceDirectoryVA:               0x", 0
    optional36  db  "ResourceDirectorySize:             0x", 0
    optional37  db  "ExceptionDirectoryVA:              0x", 0
    optional38  db  "ExceptionDirectorySize:            0x", 0
    optional39  db  "SecurityDirectoryVA:               0x", 0
    optional40  db  "SecurityDirectorySize:             0x", 0
    optional41  db  "BaseRelocationTableVA:             0x", 0
    optional42  db  "BaseRelocationTableSize:           0x", 0
    optional43  db  "DebugDirectoryVA:                  0x", 0
    optional44  db  "DebugDirectorySize:                0x", 0
    optional45  db  "ArchitectureSpecificationVA:       0x", 0
    optional46  db  "ArchitectureSpecificationSize:     0x", 0
    optional47  db  "RVAofGPVA:                         0x", 0
    optional48  db  "RVAofGPSize:                       0x", 0
    optional49  db  "TLSDirectoryVA:                    0x", 0
    optional50  db  "TLSDirectorySize:                  0x", 0
    optional51  db  "LoadConfigurationDirectoryVA:      0x", 0
    optional52  db  "LoadConfigurationDirectorySize:    0x", 0
    optional53  db  "BoundImportDirectoryinheadersVA:   0x", 0
    optional54  db  "BoundImportDirectoryinheadersSize: 0x", 0
    optional55  db  "ImportAddressTableVA:              0x", 0
    optional56  db  "ImportAddressTableSize:            0x", 0
    optional57  db  "DelayLoadImportDescriptorsVA:      0x", 0
    optional58  db  "DelayLoadImportDescriptorsSize:    0x", 0
    optional59  db  "COMRuntimedescriptorVA:            0x", 0
    optional60  db  "COMRuntimedescriptorSize:          0x", 0
    optional61  db  "Reserved:                          0x", 0
    optional62  db  "Reserved:                          0x", 0

    section_header_w      db  "***SECTION HEADER***", 13, 10, 0
    section1    db  "Name: ", 0
    section2    db  "VirtualSize:           0x", 0
    section3    db  "VirtualAddress:        0x", 0
    section4    db  "SizeOfRawData:         0x", 0
    section5    db  "PointerToRawData:      0x", 0
    section6    db  "PointerToRelocations:  0x", 0
    section7    db  "PointerToLineNumbers:  0x", 0
    section8    db  "NumberOfRelocations:   0x", 0
    section9    db  "NumberOfLineNumbers:   0x", 0
    section10   db  "Characteristics:       0x", 0
    
    export_dir  db  "***EXPORT DIRECTORY***", 13, 10, 0
    export1     db  "Characteristics:           0x", 0
    export2     db  "TimeDateStamp:             0x", 0
    export3     db  "MajorVersion:              0x", 0
    export4     db  "MinorVersion:              0x", 0
    export5     db  "Name:                      0x", 0
    export6     db  "Base:                      0x", 0
    export7     db  "NumberOfFunctions:         0x", 0
    export8     db  "NumberOfNames:             0x", 0
    export9     db  "AddressOfFunctions:        0x", 0
    export10    db  "AddressOfNames:            0x", 0
    export11    db  "AddressOfNameOrdinals:     0x", 0

    import_dir  db  "***IMPORT DIRECTORY***", 13, 10, 0
    import1     db  "OriginalFirstThunk:    0x", 0
    import2     db  "TimeDateStamp:         0x", 0
    import3     db  "ForwarderChain:        0x", 0
    import4     db  "Name:                  0x", 0
    import5     db  "FirstThunk:            0x", 0

.data?
    
    filepath    db  512 dup(?)
    
    dos_header          DOS_MZ_HEADER   <>
    pe_header           PE_HEADER       <>
    optional_header_x86 OPTIONAL_HEADER_x86 <>
    optional_header_x64 OPTIONAL_HEADER_x64 <>
    section_header      SECTION_HEADER  <>
    import_directory    IMPORT_DIRECTORY    <>
    export_directory    EXPORT_DIRECTORY    <>

.const
	getstdout   equ -11
    getstdin    equ -10
    NULL        equ 0
    TRUE        equ 1
    ENABLE_LINE_INPUT       equ 02h   
    ENABLE_ECHO_INPUT       equ 04h
    ENABLE_PROCESSED_INPUT  equ 01h
    GENERIC_READ            equ 080000000h
    FILE_BEGIN              equ 0
    FILE_CURRENT            equ 1
    INVALID_HANDLE_VALUE    equ -1
    OPEN_EXISTING           equ 3
    FILE_ATTRIBUTE_NORMAL   equ 128

.code
start:
    jmp     S0
X1:
    xor     eax, eax
    mov     eax, pe_header_addr
    add     eax, 18
    mov     section_header_addr, eax
    jmp     S34 

file_error:
    invoke  StdOut, offset file_err
    invoke  ExitProcess, 0

not_PE:
    invoke  StdOut, offset PE_deny
    invoke  CloseHandle, handle
    invoke  ExitProcess, 0

S0:
    invoke  StdOut, offset initial
  
    invoke  StdIn, offset filepath
    
    invoke  CreateFileA, addr filepath, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
    cmp     eax, INVALID_HANDLE_VALUE
    je      file_error


    mov     handle, eax

    call    Get_DOS_Header
    
    xor     eax, eax
    mov     eax, dos_header.e_lfanew
    mov     pe_header_addr, eax
    invoke  SetFilePointerEx, handle, dos_header.e_lfanew, 0, NULL, FILE_BEGIN

    call    Get_PE_Header

    mov     eax, PE_sig
    cmp     pe_header.Signature, eax
    jne     not_PE
    
    call    Display_DOS_Header
    call    Display_PE_Header
    mov     ax, pe_header.Num_of_sections
    mov     section, ax

    cmp     pe_header.SizeOfOptionalHeader, 0
    je      X1

    xor     eax, eax
    mov     eax, pe_header_addr
    add     eax, 18
    mov     optional_header_addr, eax

    invoke  ReadFile, handle, offset check, 2, 0, NULL
    mov     ax, check
    cmp     ax, 523
    je      S3
    xor     eax, eax
    mov     eax, optional_header_addr
    add     eax, 224
    mov     section_header_addr, eax
    call    Get_Optional_Header_x86
    call    Display_Optional_Header

    mov     eax, optional_header_x86.ExportDirectoryVA
    mov     export_directory_va, eax
    mov     eax, optional_header_x86.ImportDirectoryVA
    mov     import_directory_va, eax
    jmp     S4

S3:
    mov     x86_or_x64, 1
    xor     eax, eax
    mov     eax, optional_header_addr
    add     eax, 240
    mov     section_header_addr, eax
    call    Get_Optional_Header_x64
    call    Display_Optional_Header

    mov     eax, optional_header_x64.ExportDirectoryVA
    mov     export_directory_va, eax
    mov     eax, optional_header_x64.ImportDirectoryVA
    mov     import_directory_va, eax

S34:
    invoke  StdOut, offset section_header_w
S4:    
    cmp     section, 0
    je      S5

    call    Get_Section_Header
    call    Display_Section_Header

    mov     eax, section_header.VirtualAddress
    cmp     import_directory_va, eax
    jl      findExport

    mov     eax, section_header.VirtualAddress
    add     eax, section_header.VirtualSize 
    cmp     import_directory_va, eax
    jge     findExport
    mov     eax, section_header_addr
    mov     import_sec, eax
    mov     eax, import_directory_va
    sub     eax, section_header.VirtualAddress
    add     eax, section_header.PointerToRawData
    mov     section_raw_in, eax

findExport:
    mov     eax, section_header.VirtualAddress
    cmp     export_directory_va, eax
    jl      cont

    mov     eax, section_header.VirtualAddress
    add     eax, section_header.VirtualSize 
    cmp     export_directory_va, eax
    jge     cont
    mov     eax, section_header_addr
    mov     export_sec, eax
    mov     eax, export_directory_va
    sub     eax, section_header.VirtualAddress
    add     eax, section_header.PointerToRawData
    mov     section_raw_ex, eax

cont:
    inc     looper
    dec     section
    add     section_header_addr, 40
    jmp     S4

    
S5:
    invoke  StdOut, offset import_dir
    cmp     import_directory_va, 0
    je      S6
    invoke  SetFilePointerEx, handle, section_raw_in, 0, NULL, FILE_BEGIN

A2:
    call    Get_Import_Directory
    cmp     import_directory.OriginalFirstThunk, 0
    jne     A1
    cmp     import_directory.TimeDateStamp, 0
    jne     A1
    cmp     import_directory.ForwarderChain, 0
    jne     A1
    cmp     import_directory.Name1, 0
    jne     A1
    cmp     import_directory.FirstThunk, 0
    jne     A1
    jmp     S6

A1:
    call    Display_Import_Directory
    jmp     A2


S6:
    invoke  StdOut, offset export_dir
    cmp     export_directory_va, 0
    je      S7
    invoke  SetFilePointerEx, handle, section_raw_ex, 0, NULL, FILE_BEGIN

A4:
    call    Get_Export_Directory
    call    Display_Export_Directory

S7:
    invoke  CloseHandle, handle
    invoke  ExitProcess, 0

Display_DOS_Header proc
    invoke  StdOut, offset dos_header_w
    invoke  StdOut, offset dos1
    invoke  Display_word, dos_header.e_magic
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos2
    invoke  Display_word, dos_header.e_cblp
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos3
    invoke  Display_word, dos_header.e_cp
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos4
    invoke  Display_word, dos_header.e_crlc
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos5
    invoke  Display_word, dos_header.e_cparhdr
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos6
    invoke  Display_word, dos_header.e_minalloc
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos7
    invoke  Display_word, dos_header.e_maxalloc
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos8
    invoke  Display_word, dos_header.e_ss
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos9
    invoke  Display_word, dos_header.e_sp
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos10
    invoke  Display_word, dos_header.e_csum
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos11
    invoke  Display_word, dos_header.e_ip
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos12
    invoke  Display_word, dos_header.e_cs
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos13
    invoke  Display_word, dos_header.e_lfarlc
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos14
    invoke  Display_word, dos_header.e_ovno
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos15
    invoke  Display_word, dos_header.e_res[0]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos16
    invoke  Display_word, dos_header.e_res[1]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos17
    invoke  Display_word, dos_header.e_res[2]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos18
    invoke  Display_word, dos_header.e_res[3]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos19
    invoke  Display_word, dos_header.e_oemid
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos20
    invoke  Display_word, dos_header.e_oeminfo
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos21
    invoke  Display_word, dos_header.e_res2[0]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos22
    invoke  Display_word, dos_header.e_res2[1]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos23
    invoke  Display_word, dos_header.e_res2[2]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos24
    invoke  Display_word, dos_header.e_res2[3]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos25
    invoke  Display_word, dos_header.e_res2[4]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos26
    invoke  Display_word, dos_header.e_res2[5]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos27
    invoke  Display_word, dos_header.e_res2[6]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos28
    invoke  Display_word, dos_header.e_res2[7]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos29
    invoke  Display_word, dos_header.e_res2[8]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos30
    invoke  Display_word, dos_header.e_res2[9]
    invoke  StdOut, offset linenew
    invoke  StdOut, offset dos31
    invoke  Display_dword, dos_header.e_lfanew
    invoke  StdOut, offset linenew
    invoke  StdOut, offset linenew
    ret
Display_DOS_Header endp

Display_PE_Header proc
    invoke  StdOut, offset pe_header_w
    invoke  StdOut, offset pe1
    invoke  Display_dword, pe_header.Signature
    invoke  StdOut, offset linenew
    invoke  StdOut, offset pe2
    invoke  Display_word, pe_header.Machine
    invoke  StdOut, offset linenew
    invoke  StdOut, offset pe3
    invoke  Display_word, pe_header.Num_of_sections
    invoke  StdOut, offset linenew
    invoke  StdOut, offset pe4
    invoke  Display_dword, pe_header.TimeDateStamp
    invoke  StdOut, offset linenew
    invoke  StdOut, offset pe5
    invoke  Display_dword, pe_header.PointerToSymbolTable
    invoke  StdOut, offset linenew
    invoke  StdOut, offset pe6
    invoke  Display_dword, pe_header.NumberOfSymbols
    invoke  StdOut, offset linenew
    invoke  StdOut, offset pe7
    invoke  Display_word, pe_header.SizeOfOptionalHeader
    invoke  StdOut, offset linenew
    invoke  StdOut, offset pe8
    invoke  Display_word, pe_header.Characteristics
    invoke  StdOut, offset linenew
    invoke  StdOut, offset linenew
    ret
Display_PE_Header endp

Display_Optional_Header proc
    cmp     x86_or_x64, 0
    jne     x64
    invoke  StdOut, offset optional_header_w
    invoke  StdOut, offset optional1
    invoke  Display_word, optional_header_x86.Magic
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional2
    invoke  Display_byte, optional_header_x86.MajorLinkerVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional3
    invoke  Display_byte, optional_header_x86.MinorLinkerVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional4
    invoke  Display_dword, optional_header_x86.SizeOfCode
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional5
    invoke  Display_dword, optional_header_x86.SizeOfInitializedData
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional6
    invoke  Display_dword, optional_header_x86.SizeOfUnitializedData
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional7
    invoke  Display_dword, optional_header_x86.AddressOfEntryPoint
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional8
    invoke  Display_dword, optional_header_x86.BaseOfCode
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional9
    invoke  Display_dword, optional_header_x86.BaseOfData
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional10
    invoke  Display_dword, optional_header_x86.ImageBase
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional11
    invoke  Display_dword, optional_header_x86.SectionAlignment
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional12
    invoke  Display_dword, optional_header_x86.FileAlignment
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional13
    invoke  Display_word, optional_header_x86.MajorOperatingSystemVersion1
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional14
    invoke  Display_word, optional_header_x86.MinorOperatingSystemVersion1	
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional15
    invoke  Display_word, optional_header_x86.MajorImageVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional16
    invoke  Display_word, optional_header_x86.MinorImageVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional17
    invoke  Display_word, optional_header_x86.MajorSubsystemVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional18
    invoke  Display_word, optional_header_x86.MinorSubsystemVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional19
    invoke  Display_dword, optional_header_x86.Reserved1
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional20
    invoke  Display_dword, optional_header_x86.SizeOfImage
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional21
    invoke  Display_dword, optional_header_x86.SizeOfHeaders
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional22
    invoke  Display_dword, optional_header_x86.CheckSum
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional23
    invoke  Display_word, optional_header_x86.Subsystem
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional24
    invoke  Display_word, optional_header_x86.DllCharacteristics
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional25
    invoke  Display_dword, optional_header_x86.SizeOfStackReserve
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional26
    invoke  Display_dword, optional_header_x86.SizeOfStackCommit
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional27
    invoke  Display_dword, optional_header_x86.SizeOfHeapReserve
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional28
    invoke  Display_dword, optional_header_x86.SizeOfHeapCommit
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional29
    invoke  Display_dword, optional_header_x86.LoaderFlags
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional30
    invoke  Display_dword, optional_header_x86.NumberOfRvaAndSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional31
    invoke  Display_dword, optional_header_x86.ExportDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional32
    invoke  Display_dword, optional_header_x86.ExportDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional33
    invoke  Display_dword, optional_header_x86.ImportDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional34
    invoke  Display_dword, optional_header_x86.ImportDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional35
    invoke  Display_dword, optional_header_x86.ResourceDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional36
    invoke  Display_dword, optional_header_x86.ResourceDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional37
    invoke  Display_dword, optional_header_x86.ExceptionDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional38
    invoke  Display_dword, optional_header_x86.ExceptionDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional39
    invoke  Display_dword, optional_header_x86.SecurityDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional40
    invoke  Display_dword, optional_header_x86.SecurityDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional41
    invoke  Display_dword, optional_header_x86.BaseRelocationTableVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional42
    invoke  Display_dword, optional_header_x86.BaseRelocationTableSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional43
    invoke  Display_dword, optional_header_x86.DebugDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional44
    invoke  Display_dword, optional_header_x86.DebugDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional45
    invoke  Display_dword, optional_header_x86.ArchitectureSpecificDataVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional46
    invoke  Display_dword, optional_header_x86.ArchitectureSpecificDataSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional47
    invoke  Display_dword, optional_header_x86.RVAofGPVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional48
    invoke  Display_dword, optional_header_x86.RVAofGPSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional49
    invoke  Display_dword, optional_header_x86.TLSDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional50
    invoke  Display_dword, optional_header_x86.TLSDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional51
    invoke  Display_dword, optional_header_x86.LoadConfigurationDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional52
    invoke  Display_dword, optional_header_x86.LoadConfigurationDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional53
    invoke  Display_dword, optional_header_x86.BoundImportDirectoryinheadersVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional54
    invoke  Display_dword, optional_header_x86.BoundImportDirectoryinheadersSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional55
    invoke  Display_dword, optional_header_x86.ImportAddressTableVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional56
    invoke  Display_dword, optional_header_x86.ImportAddressTableSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional57
    invoke  Display_dword, optional_header_x86.DelayLoadImportDescriptorsVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional58
    invoke  Display_dword, optional_header_x86.DelayLoadImportDescriptorsSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional59
    invoke  Display_dword, optional_header_x86.COMRuntimedescriptorVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional60
    invoke  Display_dword, optional_header_x86.COMRuntimedescriptorSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional61
    invoke  Display_dword, optional_header_x86.Reserved_01
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional62
    invoke  Display_dword, optional_header_x86.Reserved_02
    invoke  StdOut, offset linenew
    invoke  StdOut, offset linenew
    jmp     finished

x64:
    invoke  StdOut, offset optional_header_w
    invoke  StdOut, offset optional1
    invoke  Display_word, optional_header_x64.Magic
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional2
    invoke  Display_byte, optional_header_x64.MajorLinkerVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional3
    invoke  Display_byte, optional_header_x64.MinorLinkerVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional4
    invoke  Display_dword, optional_header_x64.SizeOfCode
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional5
    invoke  Display_dword, optional_header_x64.SizeOfInitializedData
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional6
    invoke  Display_dword, optional_header_x64.SizeOfUnitializedData
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional7
    invoke  Display_dword, optional_header_x64.AddressOfEntryPoint
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional8
    invoke  Display_dword, optional_header_x64.BaseOfCode
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional10
    invoke  Display_qword, optional_header_x64.ImageBase_high, optional_header_x64.ImageBase_low 
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional11
    invoke  Display_dword, optional_header_x64.SectionAlignment
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional12
    invoke  Display_dword, optional_header_x64.FileAlignment
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional13
    invoke  Display_word, optional_header_x64.MajorOperatingSystemVersion1
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional14
    invoke  Display_word, optional_header_x64.MinorOperatingSystemVersion1	
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional15
    invoke  Display_word, optional_header_x64.MajorImageVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional16
    invoke  Display_word, optional_header_x64.MinorImageVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional17
    invoke  Display_word, optional_header_x64.MajorSubsystemVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional18
    invoke  Display_word, optional_header_x64.MinorSubsystemVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional19
    invoke  Display_dword, optional_header_x64.Reserved1
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional20
    invoke  Display_dword, optional_header_x64.SizeOfImage
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional21
    invoke  Display_dword, optional_header_x64.SizeOfHeaders
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional22
    invoke  Display_dword, optional_header_x64.CheckSum
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional23
    invoke  Display_word, optional_header_x64.Subsystem
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional24
    invoke  Display_word, optional_header_x64.DllCharacteristics
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional25
    invoke  Display_qword, optional_header_x64.SizeOfStackReserve_high, optional_header_x64.SizeOfStackReserve_low
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional26
    invoke  Display_qword, optional_header_x64.SizeOfStackCommit_high, optional_header_x64.SizeOfStackCommit_low
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional27
    invoke  Display_qword, optional_header_x64.SizeOfHeapReserve_high, optional_header_x64.SizeOfHeapReserve_low
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional28
    invoke  Display_qword, optional_header_x64.SizeOfHeapCommit_high, optional_header_x64.SizeOfHeapCommit_low
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional29
    invoke  Display_dword, optional_header_x64.LoaderFlags
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional30
    invoke  Display_dword, optional_header_x64.NumberOfRvaAndSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional31
    invoke  Display_dword, optional_header_x64.ExportDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional32
    invoke  Display_dword, optional_header_x64.ExportDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional33
    invoke  Display_dword, optional_header_x64.ImportDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional34
    invoke  Display_dword, optional_header_x64.ImportDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional35
    invoke  Display_dword, optional_header_x64.ResourceDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional36
    invoke  Display_dword, optional_header_x64.ResourceDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional37
    invoke  Display_dword, optional_header_x64.ExceptionDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional38
    invoke  Display_dword, optional_header_x64.ExceptionDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional39
    invoke  Display_dword, optional_header_x64.SecurityDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional40
    invoke  Display_dword, optional_header_x64.SecurityDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional41
    invoke  Display_dword, optional_header_x64.BaseRelocationTableVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional42
    invoke  Display_dword, optional_header_x64.BaseRelocationTableSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional43
    invoke  Display_dword, optional_header_x64.DebugDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional44
    invoke  Display_dword, optional_header_x64.DebugDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional45
    invoke  Display_dword, optional_header_x64.ArchitectureSpecificDataVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional46
    invoke  Display_dword, optional_header_x64.ArchitectureSpecificDataSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional47
    invoke  Display_dword, optional_header_x64.RVAofGPVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional48
    invoke  Display_dword, optional_header_x64.RVAofGPSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional49
    invoke  Display_dword, optional_header_x64.TLSDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional50
    invoke  Display_dword, optional_header_x64.TLSDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional51
    invoke  Display_dword, optional_header_x64.LoadConfigurationDirectoryVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional52
    invoke  Display_dword, optional_header_x64.LoadConfigurationDirectorySize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional53
    invoke  Display_dword, optional_header_x64.BoundImportDirectoryinheadersVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional54
    invoke  Display_dword, optional_header_x64.BoundImportDirectoryinheadersSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional55
    invoke  Display_dword, optional_header_x64.ImportAddressTableVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional56
    invoke  Display_dword, optional_header_x64.ImportAddressTableSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional57
    invoke  Display_dword, optional_header_x64.DelayLoadImportDescriptorsVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional58
    invoke  Display_dword, optional_header_x64.DelayLoadImportDescriptorsSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional59
    invoke  Display_dword, optional_header_x64.COMRuntimedescriptorVA
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional60
    invoke  Display_dword, optional_header_x64.COMRuntimedescriptorSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional61
    invoke  Display_dword, optional_header_x64.Reserved_01
    invoke  StdOut, offset linenew
    invoke  StdOut, offset optional62
    invoke  Display_dword, optional_header_x64.Reserved_02
    invoke  StdOut, offset linenew
    invoke  StdOut, offset linenew

finished:
    ret
Display_Optional_Header endp

Display_Section_Header proc
    invoke  StdOut, offset section1
    invoke  StdOut, offset section_header.Name1
    invoke  StdOut, offset linenew
    invoke  StdOut, offset section2
    invoke  Display_dword, section_header.VirtualSize
    invoke  StdOut, offset linenew
    invoke  StdOut, offset section3
    invoke  Display_dword, section_header.VirtualAddress
    invoke  StdOut, offset linenew
    invoke  StdOut, offset section4
    invoke  Display_dword, section_header.SizeOfRawData
    invoke  StdOut, offset linenew
    invoke  StdOut, offset section5
    invoke  Display_dword, section_header.PointerToRawData
    invoke  StdOut, offset linenew
    invoke  StdOut, offset section6
    invoke  Display_dword, section_header.PointerToRelocations
    invoke  StdOut, offset linenew
    invoke  StdOut, offset section7
    invoke  Display_dword, section_header.PointerToLineNumbers
    invoke  StdOut, offset linenew
    invoke  StdOut, offset section8
    invoke  Display_word, section_header.NumberOfRelocations
    invoke  StdOut, offset linenew
    invoke  StdOut, offset section9
    invoke  Display_word, section_header.NumberOfLineNumbers
    invoke  StdOut, offset linenew
    invoke  StdOut, offset section10
    invoke  Display_dword, section_header.Characteristics
    invoke  StdOut, offset linenew
    invoke  StdOut, offset linenew
    ret
Display_Section_Header endp

Display_Import_Directory proc
    invoke  StdOut, offset import1
    invoke  Display_dword, import_directory.OriginalFirstThunk
    invoke  StdOut, offset linenew
    invoke  StdOut, offset import2
    invoke  Display_dword, import_directory.TimeDateStamp
    invoke  StdOut, offset linenew
    invoke  StdOut, offset import3
    invoke  Display_dword, import_directory.ForwarderChain
    invoke  StdOut, offset linenew
    invoke  StdOut, offset import4
    invoke  Display_dword, import_directory.Name1
    invoke  StdOut, offset linenew
    invoke  StdOut, offset import5
    invoke  Display_dword, import_directory.FirstThunk
    invoke  StdOut, offset linenew
    invoke  StdOut, offset linenew

    ret
Display_Import_Directory endp

Display_Export_Directory proc
    invoke  StdOut, offset export1
    invoke  Display_dword, export_directory.Characteristics
    invoke  StdOut, offset linenew
    invoke  StdOut, offset export2
    invoke  Display_dword, export_directory.TimeDateStamp
    invoke  StdOut, offset linenew
    invoke  StdOut, offset export3
    invoke  Display_word, export_directory.MajorVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset export4
    invoke  Display_word, export_directory.MinorVersion
    invoke  StdOut, offset linenew
    invoke  StdOut, offset export5
    invoke  Display_dword, export_directory.Name1
    invoke  StdOut, offset linenew
    invoke  StdOut, offset export6
    invoke  Display_dword, export_directory.Base
    invoke  StdOut, offset linenew
    invoke  StdOut, offset export7
    invoke  Display_dword, export_directory.NumberOfFunctions
    invoke  StdOut, offset linenew
    invoke  StdOut, offset export8
    invoke  Display_dword, export_directory.NumberOfNames
    invoke  StdOut, offset linenew
    invoke  StdOut, offset export9
    invoke  Display_dword, export_directory.AddressOfFunctions
    invoke  StdOut, offset linenew
    invoke  StdOut, offset export10
    invoke  Display_dword, export_directory.AddressOfNames
    invoke  StdOut, offset linenew
    invoke  StdOut, offset export11
    invoke  Display_dword, export_directory.AddressOfNameOrdinals
    invoke  StdOut, offset linenew
    invoke  StdOut, offset linenew
    ret
Display_Export_Directory endp

Display_byte proc num:byte
    xor     eax, eax
    xor     edx, edx
    mov     al, num

    div     dive
    mov     num, al

    push    dx

    cmp     ax, 0
    jne     D1
    jmp     D2

D1:
    invoke  Display_byte, num

D2:
    xor     eax, eax
    xor     edx, edx
    pop     dx
    mov     al, [hexa + dx]
    mov     temp2, 0
    mov     temp2, eax
    invoke  StdOut, offset temp2
    ret
Display_byte   endp

Display_word proc num:word
    xor     eax, eax
    xor     edx, edx
    mov     ax, num

    div     dive
    mov     num, ax

    push    dx

    cmp     ax, 0
    jne     D3
    jmp     D4

D3:
    invoke  Display_word, num

D4:
    xor     eax, eax
    xor     edx, edx
    pop     dx
    mov     al, [hexa + dx]
    mov     temp2, 0
    mov     temp2, eax
    invoke  StdOut, offset temp2
    ret
Display_word    endp

Display_dword proc num:dword
    xor     eax, eax
    xor     edx, edx
    mov     eax, num

    div     dive
    mov     num, eax

    push    edx

    cmp     eax, 0
    jne     D5
    jmp     D6

D5:
    invoke  Display_dword, num

D6:
    xor     eax, eax
    xor     edx, edx
    pop     edx
    mov     al, [hexa + edx]
    mov     temp2, 0
    mov     temp2, eax
    invoke  StdOut, offset temp2
    ret
Display_dword    endp

Display_qword proc numhigh:dword, numlow:dword
    xor     eax, eax
    xor     edx, edx

    mov	eax, numhigh
	div	dive
	mov	numhigh, eax

	mov	eax, numlow
	div	dive
	mov	numlow, eax

    push    edx

    cmp	numhigh, 0
	jne	D7
	cmp	numlow, 0
	jne	D7
	jmp	D8

D7:
	invoke Display_qword, numhigh, numlow

D8:
    xor     eax, eax
    xor     edx, edx
    pop     edx
    mov     al, [hexa + edx]
    mov     temp2, 0
    mov     temp2, eax
    invoke  StdOut, offset temp2

    ret
Display_qword endp

Get_DOS_Header proc
    invoke  ReadFile, handle, offset dos_header.e_magic, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_cblp, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_cp, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_crlc, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_cparhdr, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_minalloc, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_maxalloc, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_ss, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_sp, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_csum, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_ip, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_cs, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_lfarlc, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_ovno, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res[0], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res[1], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res[2], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res[3], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_oemid, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_oeminfo, 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res2[0], 2, 0, NULL    
    invoke  ReadFile, handle, offset dos_header.e_res2[1], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res2[2], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res2[3], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res2[4], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res2[5], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res2[6], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res2[7], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res2[8], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_res2[9], 2, 0, NULL
    invoke  ReadFile, handle, offset dos_header.e_lfanew, 4, 0, NULL

    ret
Get_DOS_Header endp

Get_PE_Header proc
    invoke  ReadFile, handle, offset pe_header.Signature, 4, 0, NULL
    invoke  ReadFile, handle, offset pe_header.Machine, 2, 0, NULL
    invoke  ReadFile, handle, offset pe_header.Num_of_sections, 2, 0, NULL
    invoke  ReadFile, handle, offset pe_header.TimeDateStamp, 4, 0, NULL
    invoke  ReadFile, handle, offset pe_header.PointerToSymbolTable, 4, 0, NULL
    invoke  ReadFile, handle, offset pe_header.NumberOfSymbols, 4, 0, NULL
    invoke  ReadFile, handle, offset pe_header.SizeOfOptionalHeader, 2, 0, NULL
    invoke  ReadFile, handle, offset pe_header.Characteristics, 2, 0, NULL

    ret
Get_PE_Header endp

Get_Optional_Header_x86 proc
    mov     ax, check
    mov     optional_header_x86.Magic, ax
    invoke  ReadFile, handle, offset optional_header_x86.MajorLinkerVersion, 1, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.MinorLinkerVersion, 1, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SizeOfCode, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SizeOfInitializedData, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SizeOfUnitializedData, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.AddressOfEntryPoint, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.BaseOfCode, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.BaseOfData, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ImageBase, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SectionAlignment, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.FileAlignment, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.MajorOperatingSystemVersion1, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.MinorOperatingSystemVersion1, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.MajorImageVersion, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.MinorImageVersion, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.MajorSubsystemVersion, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.MinorSubsystemVersion, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.Reserved1, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SizeOfImage, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SizeOfHeaders, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.CheckSum, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.Subsystem, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.DllCharacteristics, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SizeOfStackReserve, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SizeOfStackCommit, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SizeOfHeapReserve, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SizeOfHeapCommit, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.LoaderFlags, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.NumberOfRvaAndSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ExportDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ExportDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ImportDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ImportDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ResourceDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ResourceDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ExceptionDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ExceptionDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SecurityDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.SecurityDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.BaseRelocationTableVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.BaseRelocationTableSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.DebugDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.DebugDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ArchitectureSpecificDataVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ArchitectureSpecificDataSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.RVAofGPVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.RVAofGPSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.TLSDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.TLSDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.LoadConfigurationDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.LoadConfigurationDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.BoundImportDirectoryinheadersVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.BoundImportDirectoryinheadersSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ImportAddressTableVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.ImportAddressTableSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.DelayLoadImportDescriptorsVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.DelayLoadImportDescriptorsSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.COMRuntimedescriptorVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.COMRuntimedescriptorSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.Reserved_01, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x86.Reserved_02, 4, 0, NULL
    ret
Get_Optional_Header_x86 endp
    
Get_Optional_Header_x64 proc
    mov     ax, check
    mov     optional_header_x64.Magic, ax
    invoke  ReadFile, handle, offset optional_header_x64.MajorLinkerVersion, 1, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.MinorLinkerVersion, 1, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfCode, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfInitializedData, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfUnitializedData, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.AddressOfEntryPoint, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.BaseOfCode, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ImageBase_low, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ImageBase_high, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SectionAlignment, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.FileAlignment, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.MajorOperatingSystemVersion1, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.MinorOperatingSystemVersion1, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.MajorImageVersion, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.MinorImageVersion, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.MajorSubsystemVersion, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.MinorSubsystemVersion, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.Reserved1, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfImage, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfHeaders, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.CheckSum, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.Subsystem, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.DllCharacteristics, 2, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfStackReserve_low, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfStackReserve_high, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfStackCommit_low, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfStackCommit_high, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfHeapReserve_low, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfHeapReserve_high, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfHeapCommit_low, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SizeOfHeapCommit_high, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.LoaderFlags, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.NumberOfRvaAndSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ExportDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ExportDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ImportDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ImportDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ResourceDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ResourceDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ExceptionDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ExceptionDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SecurityDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.SecurityDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.BaseRelocationTableVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.BaseRelocationTableSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.DebugDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.DebugDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ArchitectureSpecificDataVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ArchitectureSpecificDataSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.RVAofGPVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.RVAofGPSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.TLSDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.TLSDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.LoadConfigurationDirectoryVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.LoadConfigurationDirectorySize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.BoundImportDirectoryinheadersVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.BoundImportDirectoryinheadersSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ImportAddressTableVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.ImportAddressTableSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.DelayLoadImportDescriptorsVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.DelayLoadImportDescriptorsSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.COMRuntimedescriptorVA, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.COMRuntimedescriptorSize, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.Reserved_01, 4, 0, NULL
    invoke  ReadFile, handle, offset optional_header_x64.Reserved_02, 4, 0, NULL
    ret
Get_Optional_Header_x64 endp

Get_Section_Header  proc
    invoke  ReadFile, handle, offset section_header.Name1, 8, 0, NULL
    invoke  ReadFile, handle, offset section_header.VirtualSize, 4, 0, NULL
    invoke  ReadFile, handle, offset section_header.VirtualAddress, 4, 0, NULL
    invoke  ReadFile, handle, offset section_header.SizeOfRawData, 4, 0, NULL
    invoke  ReadFile, handle, offset section_header.PointerToRawData, 4, 0, NULL
    invoke  ReadFile, handle, offset section_header.PointerToRelocations, 4, 0, NULL
    invoke  ReadFile, handle, offset section_header.PointerToLineNumbers, 4, 0, NULL
    invoke  ReadFile, handle, offset section_header.NumberOfRelocations, 2, 0, NULL
    invoke  ReadFile, handle, offset section_header.NumberOfLineNumbers, 2, 0, NULL
    invoke  ReadFile, handle, offset section_header.Characteristics, 4, 0, NULL

    ret
Get_Section_Header  endp

Get_Import_Directory proc
    invoke  ReadFile, handle, offset import_directory.OriginalFirstThunk, 4, 0, NULL
    invoke  ReadFile, handle, offset import_directory.TimeDateStamp, 4, 0, NULL
    invoke  ReadFile, handle, offset import_directory.ForwarderChain, 4, 0, NULL
    invoke  ReadFile, handle, offset import_directory.Name1, 4, 0, NULL
    invoke  ReadFile, handle, offset import_directory.FirstThunk, 4, 0, NULL

    ret
Get_Import_Directory endp

Get_Export_Directory proc
    invoke  ReadFile, handle, offset export_directory.Characteristics, 4, 0, NULL
    invoke  ReadFile, handle, offset export_directory.TimeDateStamp, 4, 0, NULL
    invoke  ReadFile, handle, offset export_directory.MajorVersion, 2, 0, NULL
    invoke  ReadFile, handle, offset export_directory.MinorVersion, 2, 0, NULL
    invoke  ReadFile, handle, offset export_directory.Name1, 4, 0, NULL
    invoke  ReadFile, handle, offset export_directory.Base, 4, 0, NULL
    invoke  ReadFile, handle, offset export_directory.NumberOfFunctions, 4, 0, NULL
    invoke  ReadFile, handle, offset export_directory.NumberOfNames, 4, 0, NULL
    invoke  ReadFile, handle, offset export_directory.AddressOfFunctions, 4, 0, NULL
    invoke  ReadFile, handle, offset export_directory.AddressOfNames, 4, 0, NULL
    invoke  ReadFile, handle, offset export_directory.AddressOfNameOrdinals, 4, 0, NULL

    ret
Get_Export_Directory endp

StdIn proc buffer:DWORD

    LOCAL   hInput  :DWORD
    LOCAL   btoRead :DWORD
    
    invoke GetStdHandle, getstdin
    mov     hInput, eax

    invoke SetConsoleMode, hInput, ENABLE_LINE_INPUT or \
                                   ENABLE_ECHO_INPUT or \
                                   ENABLE_PROCESSED_INPUT

    invoke ReadFile, hInput, buffer, 512, addr btoRead, 0

    mov     esi, buffer
    dec     esi
L1:
	inc	esi

	cmp	BYTE PTR [esi], 13
	jne	L1
    
	mov	BYTE PTR [esi], 0

	mov	eax, btoRead
	sub	eax, 2
	ret

StdIn endp


StdOut proc buffer:DWORD

    LOCAL   hOutPut :DWORD
    LOCAL   sl      :DWORD

    invoke  GetStdHandle, getstdout
    mov     hOutPut, eax

    mov     esi, buffer
    dec     esi
    mov     ecx, 0
L2:
    inc     esi
    inc     ecx
    cmp     BYTE PTR [esi], 0
    jne     L2
    
    mov     sl, ecx

    invoke  WriteFile, hOutPut, buffer, sl, NULL, 0
    ret

StdOut endp

end start