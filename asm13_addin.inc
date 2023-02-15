DOS_MZ_HEADER STRUCT
	e_magic		WORD	?
	e_cblp		WORD	?
	e_cp		WORD	?
	e_crlc		WORD	?
	e_cparhdr	WORD	?
	e_minalloc	WORD	?
	e_maxalloc	WORD	?
	e_ss		WORD	?
	e_sp		WORD	?
	e_csum		WORD	?
	e_ip		WORD	?
	e_cs		WORD	?
	e_lfarlc	WORD	?
	e_ovno		WORD	?
	e_res		dw		4	dup	(?)
	e_oemid		WORD	?
	e_oeminfo	WORD	?
	e_res2		dw		10	dup	(?)
	e_lfanew	DWORD	?
DOS_MZ_HEADER ENDS

PE_HEADER	STRUCT
	Signature				DWORD	?
	Machine					WORD	?
	Num_of_sections			WORD	?
	TimeDateStamp			DWORD	?
	PointerToSymbolTable	DWORD	?
	NumberOfSymbols			DWORD	?
	SizeOfOptionalHeader	WORD	?
	Characteristics			WORD	?
PE_HEADER	ENDS

OPTIONAL_HEADER_x86	STRUCT
	Magic					WORD	?
	MajorLinkerVersion		BYTE	?
	MinorLinkerVersion		BYTE	?
	SizeOfCode				DWORD	?
	SizeOfInitializedData	DWORD	?
	SizeOfUnitializedData	DWORD	?
	AddressOfEntryPoint		DWORD	?
	BaseOfCode				DWORD	?
	BaseOfData				DWORD	?
	ImageBase				DWORD	?
	SectionAlignment		DWORD	?
	FileAlignment			DWORD	?
	MajorOperatingSystemVersion1	WORD	?
	MinorOperatingSystemVersion1	WORD	?
	MajorImageVersion		WORD	?
	MinorImageVersion		WORD	?
	MajorSubsystemVersion	WORD	?
	MinorSubsystemVersion	WORD	?
	Reserved1				DWORD	?
	SizeOfImage				DWORD	?
	SizeOfHeaders			DWORD	?
	CheckSum				DWORD	?
	Subsystem				WORD	?
	DllCharacteristics		WORD	?
	SizeOfStackReserve		DWORD	?
	SizeOfStackCommit		DWORD	?
	SizeOfHeapReserve		DWORD	?
	SizeOfHeapCommit		DWORD	?
	LoaderFlags				DWORD	?
	NumberOfRvaAndSize		DWORD	?
	ExportDirectoryVA		DWORD	?
	ExportDirectorySize		DWORD	?
	ImportDirectoryVA		DWORD	?
	ImportDirectorySize		DWORD	?
	ResourceDirectoryVA		DWORD	?
	ResourceDirectorySize	DWORD	?
	ExceptionDirectoryVA	DWORD	?
	ExceptionDirectorySize	DWORD	?
	SecurityDirectoryVA		DWORD	?
	SecurityDirectorySize	DWORD	?
	BaseRelocationTableVA	DWORD	?
	BaseRelocationTableSize	DWORD	?
	DebugDirectoryVA		DWORD	?
	DebugDirectorySize		DWORD	?
	ArchitectureSpecificDataVA		DWORD	?
	ArchitectureSpecificDataSize	DWORD	?
	RVAofGPVA				DWORD	?
	RVAofGPSize				DWORD	?
	TLSDirectoryVA			DWORD	?
	TLSDirectorySize		DWORD	?
	LoadConfigurationDirectoryVA	DWORD	?
	LoadConfigurationDirectorySize	DWORD	?
	BoundImportDirectoryinheadersVA	DWORD	?
	BoundImportDirectoryinheadersSize	DWORD	?
	ImportAddressTableVA	DWORD	?
	ImportAddressTableSize	DWORD	?
	DelayLoadImportDescriptorsVA	DWORD	?
	DelayLoadImportDescriptorsSize	DWORD	?
	COMRuntimedescriptorVA	DWORD	?
	COMRuntimedescriptorSize		DWORD	?
	Reserved_01				DWORD	?
	Reserved_02				DWORD	?
OPTIONAL_HEADER_x86	ENDS

OPTIONAL_HEADER_x64	STRUCT
	Magic					WORD	?
	MajorLinkerVersion		BYTE	?
	MinorLinkerVersion		BYTE	?
	SizeOfCode				DWORD	?
	SizeOfInitializedData	DWORD	?
	SizeOfUnitializedData	DWORD	?
	AddressOfEntryPoint		DWORD	?
	BaseOfCode				DWORD	?
	ImageBase_low			DWORD	?
	ImageBase_high			DWORD	?
	SectionAlignment		DWORD	?
	FileAlignment			DWORD	?
	MajorOperatingSystemVersion1	WORD	?
	MinorOperatingSystemVersion1	WORD	?
	MajorImageVersion		WORD	?
	MinorImageVersion		WORD	?
	MajorSubsystemVersion	WORD	?
	MinorSubsystemVersion	WORD	?
	Reserved1				DWORD	?
	SizeOfImage				DWORD	?
	SizeOfHeaders			DWORD	?
	CheckSum				DWORD	?
	Subsystem				WORD	?
	DllCharacteristics		WORD	?
	SizeOfStackReserve_low	DWORD	?
	SizeOfStackReserve_high	DWORD	?
	SizeOfStackCommit_low	DWORD	?
	SizeOfStackCommit_high	DWORD	?
	SizeOfHeapReserve_low	DWORD	?
	SizeOfHeapReserve_high	DWORD	?
	SizeOfHeapCommit_low	DWORD	?
	SizeOfHeapCommit_high	DWORD	?
	LoaderFlags				DWORD	?
	NumberOfRvaAndSize		DWORD	?
	ExportDirectoryVA		DWORD	?
	ExportDirectorySize		DWORD	?
	ImportDirectoryVA		DWORD	?
	ImportDirectorySize		DWORD	?
	ResourceDirectoryVA		DWORD	?
	ResourceDirectorySize	DWORD	?
	ExceptionDirectoryVA	DWORD	?
	ExceptionDirectorySize	DWORD	?
	SecurityDirectoryVA		DWORD	?
	SecurityDirectorySize	DWORD	?
	BaseRelocationTableVA	DWORD	?
	BaseRelocationTableSize	DWORD	?
	DebugDirectoryVA		DWORD	?
	DebugDirectorySize		DWORD	?
	ArchitectureSpecificDataVA		DWORD	?
	ArchitectureSpecificDataSize	DWORD	?
	RVAofGPVA				DWORD	?
	RVAofGPSize				DWORD	?
	TLSDirectoryVA			DWORD	?
	TLSDirectorySize		DWORD	?
	LoadConfigurationDirectoryVA	DWORD	?
	LoadConfigurationDirectorySize	DWORD	?
	BoundImportDirectoryinheadersVA	DWORD	?
	BoundImportDirectoryinheadersSize	DWORD	?
	ImportAddressTableVA	DWORD	?
	ImportAddressTableSize	DWORD	?
	DelayLoadImportDescriptorsVA	DWORD	?
	DelayLoadImportDescriptorsSize	DWORD	?
	COMRuntimedescriptorVA	DWORD	?
	COMRuntimedescriptorSize		DWORD	?
	Reserved_01				DWORD	?
	Reserved_02				DWORD	?
OPTIONAL_HEADER_x64	ENDS

SECTION_HEADER	STRUCT
	Name1					db	8	dup	(?)
	VirtualSize				DWORD	?
	VirtualAddress			DWORD	?
	SizeOfRawData			DWORD	?
	PointerToRawData		DWORD	?
	PointerToRelocations	DWORD	?
	PointerToLineNumbers	DWORD	?
	NumberOfRelocations		WORD	?
	NumberOfLineNumbers		WORD	?
	Characteristics			DWORD	?
SECTION_HEADER	ENDS

EXPORT_DIRECTORY	STRUCT
	Characteristics			DWORD	?
	TimeDateStamp			DWORD	?
	MajorVersion			WORD	?
	MinorVersion			WORD	?
	Name1					DWORD	?
	Base					DWORD	?
	NumberOfFunctions		DWORD	?
	NumberOfNames			DWORD	?
	AddressOfFunctions		DWORD	?
	AddressOfNames			DWORD	?
	AddressOfNameOrdinals	DWORD	?
EXPORT_DIRECTORY	ENDS

IMPORT_DIRECTORY	STRUCT
	OriginalFirstThunk		DWORD	?
	TimeDateStamp			DWORD	?
	ForwarderChain			DWORD	?
	Name1					DWORD	?
	FirstThunk				DWORD	?
IMPORT_DIRECTORY	ENDS