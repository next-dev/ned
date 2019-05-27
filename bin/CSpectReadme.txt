﻿#CSpect V2.8.0 ZXSpectrum emulator by Mike Dailly
(c)1998-2019 All rights reserved

Be aware...emulator is far from well tested, and might crash for any reason - sometimes just out of pure spite!

NOTE: DISTRIBUTION WITH COMMERCIAL TITLES IS NOT PERMITTED WITHOUT WRITTEN CONSENT.

Installing
----------
Windows - You will need the latest .NET, and openAL ( https://www.openal.org/downloads/ )
Linux   - You will need the full MONO  (on ubuntu do "apt-get install mono-devel" )
OSX     - You will need the latest mono from https://www.mono-project.com/


NXtel release
-------------
NXtel is written by SevenFFF / Robin Verhagen-Guest and is 
(c) Copyright 2018,2019, all rights reserved, and released under the GPL3 License.
( see license here: https://github.com/Threetwosevensixseven/NXtel/blob/master/LICENSE)
Latest versions can be found here: https://github.com/Threetwosevensixseven/NXtel/releases



Command Line Options
======================================================================================
-zxnext            =  enable Next hardware registers
-nextrom           =  enable the Next ROM ("enNextZX.rom" and "enNxtmmc.rom" required)
-zx128             =  enable ZX Spectrum 128 mode
-s7                =  enable 7Mhz mode
-s14               =  enable 14Mhz mode
-s28               =  enable 28Mhz mode\
-exit              =  to enable "EXIT" opcode of "DD 00"
-brk               =  to enable "BREAK" opcode of "DD 01"
-esc               =  to disable ESCAPE exit key (use exit opcode, close button or ALT+F4 to exit)
-cur               =  to map cursor keys to 6789 (l/r/d/u)
-8_3               =  set filenames back to 8.3 detection
-mmc=<dir>\        =  enable RST $08 usage, must provide path to "root" dir of emulated SD card (eg  "-mmc=.\" or "-mmc=c:\test\")
-map=<path\file>   =  SNASM format map file for use in the debugger. format is: "<16bit address> <physical address> <type> <primary_label>[@<local>]"
-sound             =  disable sound
-joy               =  disable joysticks
-w<size>           =  set window size (1 to 4)
-r                 =  Remember window settings (in "cspect.dat" file, just delete the file to reset)
-16bit             =  Use the logical (16bit) addresses in the debugger only
-60                =  60Hz mode
-fullscreen        =  Startup in fullscreen mode
-vsync             =  Sync to display (for smoother scrolling when using "-60 -sound", but a little faster)
-com="COM?:BAUD"   =  Setup com port for UART. i.e. -com="COM5:115200". if not set, coms will be disabled.
-stop              =  Start in the debugger.
-log_cpu           =  Log the CPU status out

Whats new
======================================================================================
v2.8.0
------
Fixed -esc command line, hadn't been ported from 1.x version
Swapped Right Shift for SYMSHIFT to Right Control. Both shifts map to CAPS SHIFT.  "," still works as SYMSHIFT
Fixed PUSH XXXX opcode in debugger. Was displaying low/high. Now fixed to display high/low.
Added "-log_cpu" for tracing the CPU instruction stream
Added back in Label "switch" to debugger
Missing "LDWS" opcode added to disassembler
Fixed bug in ULA off mode where the border was still being drawn
Fixed bug in 512 tile mode, where it was always above the ULA screen
Added +3 ROM emulation (without RAM only mode)
Added divMMC ROM/RAM hardware support via port $E3
Added divMMC SD card support via ports $E7 and $EB
SD Card SPI commands supported:CMD0,CMD1,CMD8,CMD9,CMD12,CMD13,CMD16,CMD17,CMD24,CMD55,CMD58,ACMD41
(see SDCARD setup below to get up and running)


V2.7.0
------
Removed debug text output
Initial WiFi/UART support added.
NXtel.nex added to archive - see weblink above for the latest versions.

V2.6.4
------
Fixed Timex Hires mode when using ULANext
Fixed Timex Hires border colour

V2.6.3
------
Fixed sprites crashing when using default transparency
Fixed fallback colour in screen area (I think)

V2.6.2
------
Fixed darkening mode - removed debug code
Fixed sprites being offset by a 1/2 pixel to the left

V2.6.1
------
Fixed new sprite rendering
Fixed Lighten and Darkening modes

V2.6.0
------
Rendering rewrite to properly fix transparancy.

V2.5.1
------
Trying to fix ULA transparancy.

V2.5.0
------
Fixed PUSH $1234 to have the right order.
Fixed LDWS so that flags are set based on the INC D
Fixed BSLA so that it takes bits 4..0 not just bits 3..0
Fixed a global colour transparancy issue

V2.4.6
------
Palette reading added - untested
Fixed a transparency issue with ULA colours

V2.4.5
------
HL now gets set properly after an F_READ (address of next byte)
9 bit Layer 2 colour now compares to Global transparency 8 bits correctly.

V2.4.4
------
Attempt 3 at 9bit colour (3 bit blue)

V2.4.3
------
Fixed a type-o in 9 bit blues

V2.4.2
------
Fixed "HALT" instruction so that it waits for the next IRQ or Reset, and doesn't carry on at VBlank.
9 bit colours (and so 3 bit blues), now use the same colour mapping as Red and Green. 8 Bit colour is as before.

V2.4.1
------
Inital UART spport added via standard windows serial COM ports. Must use "-com" to setup
Fixed the Real Time Clock (RTC) APi... was returing in the wrong order.
Added "fine" seconds control to RTC API. "H" now holds full seconds.

V2.4.0
------
Copper will now trap uninitialised memory when trying to execute a program, and enter the debugger.
Gamepads will now only use the "first" mapped analogue controller. Sorry. Dpad should work fine.
Fixed a bug where creating a new file, then trying to open it would fail.

V2.3.3
------
Fixed 512 tile mode. ULA Disabled bit has moved to Reg 0x68, bit 7.
Border can now be transparent and will use the fallback colour.
NEX format file expanded. Default 16k RAM bank at  $C000 now set.
NEX format file can now set the file handle on request.
Added more window scaling options (-w1 to -w10 now available).
Updated 512 tile mode to use NextReg $6B (bits 0 and 1) properly.
core version now set to 28 (2.0.28)

V2.3.2
------
Screen size changed to 320x256 to allow for full tilemap+sprites display (640x512 actual)
Fixed Tiles under ULA screen when in border area (now also under border). Same as H/W
Added 2 player Joysticks (first pass)
Added MegaDrive joysticks (first pass)


V2.3.1
------
Sprite over border clipping fixed
Sprite over border *2 on coords fixed
Fixed a rasterline reading issue when read at the bottom of the screen.


V2.3.0
------
F_FSTAT($A1) and F_STAT($AC) now implemented again
-fullscreen added to start in fullscreen mode
Fixed loading of NEX files that have pre-set tiles


V2.2.3
------
Minor update for tilemap indexing


V2.2.3
------
Added ULA scrolling using LowRes scroll registers. Note: X currently byte scrolling only.
Added Tilemap screen mode
Added X and Y scrolling to tilemaps
Fixed a couple of bugs in the streaming API.
Fixed USL rendering order - was just buggered. (Layer2 demo was broken)
Added a "-vsync" mode for when using "-60 -sound"

V2.2.2
------
Fixed regs $75-$79 auto inc then top bit of $35 NOT set
Upped sprites to 128 as per new hardware (yum!)

V2.2.1
------
Fixed reg 0x43 bit 7- disable palette auto increment.
Fixed NextReg access for sprites. Was using the wrong index.
Added Auto-increment/port binding for NextReg $35 (sprite number)
Added Auto-increment sprite Next registers $75-$79 (mirrors)
Fixed MMC path setting from the command line


V2.1.4
------
Added logging debug command (see below)
Added Layer 2 pixel priority mode - top bit of second colour palette byte (the single bit of blue) specifies over the top of everything.
Added Next OS streaming API ( see below  )
Added DMA reverse mode (R0 BASE, bit 2)
Added BSLA DE,B  (ED 28)  shift DE left by B places - uses bits 4..0 of B only
Added BSRA DE,B  (ED 28)  arithmetic shift right DE by B places - uses bits 4..0 of B only - bit 15 is replicated to keep sign
Added BSRL DE,B  (ED 2A)  logical shift right DE by B places - uses bits 4..0 of B only
Added BSRF DE,B  (ED 2B)  shift right DE by B places, filling from left with 1s - uses bits 4..0 of B only
Added BRLC DE,B  (ED 2C)  rotate DE left by B places - uses bits 3..0 of B only (to rotate right, use B=16-places)
Added JP (C)     (ED 98)  JP  ( IN(C)*64 + PC&$c000 )
Added new sprite control byte
Added sprite expand on X (16,32,64 or 128)
Added sprite expand on Y (16,32,64 or 128)
Added 16 colour shape mode
Removed 12 sprite limit, limitations still apply when expanding on X (100 16x16s per line max)
Sprite pixel wrapping on X and Y (out one side, back in the other)
Added "lighten" mode.  L2+ULA colours clamped. (selected using SLU layer order of 110)
Added "darken" mode.  L2+ULA-555 colours clamped. (selected using SLU layer order of 111)


V2.1.1
------
Fixed a crash in sprite palettes.

V2.1.0
------
Fixed Create/Truncate on esxDOS emulation
Mouse support added
Gamepads added - not sure about OSX and Linux, but appear fine on Windows.

V2.0.2
------
Ported to C#, OpenTL, OpenGL and OpenAL, now fully cross platform!
Things NOT yet finished/ported.
   Gamepads
   Some esxDOS functions  (F_FSTAT, F_STAT, M_GETDATE)
   128K SNA files are not currently loading
   File dialog (F2) will not work on OSX due to windows Forms not working in x64 mode in mono
   Mouse is not currently implemented
   Due to the way openAL appears to work, things aren't as smooth as i'd like. Disabling audio (-sound) will smooth out movement for now...
   Probably a few more things....



V1.18
-----
added "-16bit" to use only the logical address of the MAP file
Execution Breakpoints are now set in physical address space. A HEX number or SHIFT+F9 will set a logical address breakpoint. This means you can now set breakpoints on code that is not banked in yet.
Next mode enabled when loading a .NEX file


V1.17
-----
ULA colours updated to match new core colours. Bright Magenta no longer transparent by default. Now matches with $E7 (not $E3)
Fixed debugger bug where "0" is just left blank
New MAP format allowing overlays mapped in. Labels in the debugger are now based on physical addresses depending on the MMU
You can now specify a bank+offset in the debuggers memory view (M $00:$0000) to display physical addresses. 
Numeric Keypad added for debugger use.
EQUates are no longer displayed in the debugger, only addresses. This makes the view much cleaner


V1.16
-----
Fixed sprite transparency to use the index before the palette and colour conversion is done
-r on the command line will now allow CSpect to remember the window location, is if you move it somewhere, it'll start up there again next time.
Moved command line options to the top of the file, as no one seems to find them. Keys etc are still below.



V1.15
-----
Fixed sprite transparency index. now reads transparancy colour from sprite palette.
Timex Hi-Colour mode fixed

M_GETDATE added to esxDOS emulation (MSDOS format)
BC = DATE
DE = TIME

Bits	Description
0-4     Day of the month (1–31)
5-8     Month (1 = January, 2 = February, and so on)
9-15    Year offset from 1980 (add 1980 to get actual year)

Bits    Description
0-4     Second divided by 2
5-10    Minute (0–59)
11-15   Hour (0–23 on a 24-hour clock)




V1.14
-----
-joy to disable DirectInput gamepads
Re-added OUTINB instruction (16Ts)
Fixed a but with MMU1 mapping when reading, it was reading using MMU0 instead.
In ZXNext mode, if you have RAM paged in MMU0, then RST8 will be called, and esxDOS not simulated
Palette control registers are now readable (Hires Pawn demo now works)
Reg 0 now returns 10 as Machine ID
Reg 1 now returns 0x1A as core version (1.10)
Layer2 transparancy now checks the final colour, not the index
Fixed sprites in the right border area (the 320x192 picture demo)
Timex Hires colours now correct (Pawn demo)


V1.13.2
-------
Fixed CPU on WRITE and on READ breakpoints
-port1f command line removed
.NEX format now leaves IRQs enabled
Removed some of the old opcodes from the debugger
Kempston joystick emulation added using direct input. All controllers map to a single port, port $001F = %000FUDLR
Fixed memory contention disable (so now tested!)


V1.12.1
-------
Added .NEX format loading. (see format below)
Added nextreg 8, bit 6 - set to disable memory contention. (untested)
Added Specdrum Nextreg mirror ($2D)
Removed OUTINB
Removed MIRROR DE
Added sprite global transparancy register ($4B) - $e3 by default, same as global transparancy ($14).
NextReg reg,val timing changed to 20T
NextReg reg,a timing changed to 17T
Added LDWS instruction (might change)


V1.11
-----
Fixed Lowres window (right edge)
You can now use long filenames in  RST $08 commands (as per NextOS), can be set back to 8.3 via command line
Layer 2 now defaults to banks 9 and 12 as per NextOS
Added command line option to retrun $FF from port $1f
Fixed a possible issue in loading 128K SNA files. Last entry in stack (SP) was being wiped - this may have been pointing to ROM....
Fixed mouse buttons return value (bit 0 for button 1, bit 1 for button 2)


V1.10
-----
-cur to map cursor keys to 6789 (l/r/d/u)
Fixed copper instruction order
Copper fixed - and confirmed working. (changes are only visible on next line)
Copper increased to 2K - 1024 instructions
Fixed a bug in the AY emulation (updated source included)
Fixed Lowres colour palette selection
Added new "Beast" demo+source to the package to show off the copper


V1.09
-----
Layer 2 is now disabled if "shadow" screen is active  (bit 3 of port $7FFD)
Timex mode second ULA screen added (via port $FF bit 0 = 0 or 1). Second screen at $6000.
Fixed bit ?,(ix+*) type instructions in the disassembler. All $DD,$CB and $FD,$CB prefix instructions.


V1.08
-----
$123b is now readable
Fixed cursor disappearing


V1.07
-----
"Trace" text was still being drawn when window is too small.
"POKE"  debugger command added
New timings added to enhanced instructions - see below.


V1.06
-----
Border colour should now work again.... (palette paper offsets shifted)


V1.05
-----
Minor update to fix port $303b. If value is >63, it now writes 0 instead (as per the hardware)


V1.04
-----
Palettes now tested and working


V1.03
-----
Missing ay.dll from archive


V1.02
-----
Quick fix for ULA clip window


V1.01
----
Fixed a bug in delete key in debugger not working
Fixed Raster line IRQ so they now match the hardware
Fixed a bug in 128K SNA file loading
Fixed a bug in moving the memory window around using SHIFT key(s)
Removed SID support  :(
Added auto speed throttling.  While rendering the screen, if the speed is over 7Mhz, it will drop to 7Mhz. (*approximated)
Removed extra CPU instructions which are now defuct. (final list below)
MUL is now D*E=DE (8x8 bit = 16bit)
Current Next reg (via port $243b is now shown) in debugger
Current 8K MMU banks are now shown in debugger
CPU TRACE added to debugger view (see keys below) ( only when in 4x screen size mode)
Copper support added. Note: unlike hardware, changes will happen NEXT scanline.
Sprite Clip Window support added (Reg 25)
Layer 2 Clip Window support added (Reg 24)
ULA Clip Window support added (Reg 24)
LOWRES Clip Window support added (Reg 24)
Layer 2 2x palettes added
Sprite 2x palettes added
ULA 2x palettes added
Regiuster $243b is now readable

NOTE: SNASM now requires "opt ZXNEXTREG" to enable the "NextReg" opcode




V1.00
----
Startup and shut down crash should be fixed
You can now use register names in the debugger evaluation  ("M HL" instead of "M $1234", "BC HL" etc.)
G <val/reg/sym> to disassemble from address
-sound to disable audio
Timing fixed when no sound active.
-resid to enable loading and using of the reSID DLL. Note: not working yet - feel free to try and fix it! :)
-exit  to enable "EXIT" opcode of "DD 00"
-brk   to enable "BREAK" opcode of "DD 01"
-esc   to disable ESCAPE exit key (use exit opcode, close button or ALT+F4 to exit)
Fixed the Kempston Mouse interface, now works like the hardware.
Next registers are now readable (as per hardware)
local labels beginning with ! or . will now be stripped properly
Pressing CONTROL will release the mouse
Right shift is now also "Symbol shift"
3xAY audio added - many thanks to Matt Westcott (gasman)  https://github.com/gasman/libayemu
Timex Hicolour added
Timex Hires added
Lowest bit og BLUE can now be set
SHIFT+ENTER will set the PC to the current "user bar" address
Raster interrupts via Next registers $22 and $23
MMU memory mapping via NextReg $50 to $57
Added 3xAY demo by Purple Motion.
Source for ay.dll and resid.dll included (feel free to fix reSID.DLL!)
You can now specify the window size with -w1, -w2, -w3 and -w4(default). If winow is less than 3x then the debugger is not available
Cursor keys are now mapped to 5678 (ZX spectrum cursor)
Backspace now maps to LeftShift+0 (delete)
DMA now available! Simple block transfer (memory to memory, memory to port, port to memory)
SpecDrum sample interface included. Port $ffdf takes an 8 bit signed value and is output to audio. (not really tested)
Added the lowres demo (press 1+2 to switch demo)
Updated Mouse demo and added Raster Interrupts
Added DMA demo
Added 3xAY music demo


V0.9
----
register 20 ($14) Global transparancy colour added (defaults to $e3)
regisrer 7 Turbo mode selection implemented. 
Fixed 28Mhz to 14,7,3.5 transition. 
ULANext mode updated to new spec  (see https://www.specnext.com/tbblue-io-port-system/)
LDIRSCALE added
LDPIRX added


V0.8
----
New Lowres layer support added (details below)
ULANext palette support added (details below)
TEST $XX opcode fixed



V0.7
----
port $0057 and  $005b are now $xx57 and $xx5b, as per the hardware
Fixed some sprite rotation and flipping
Can now save via RST $08  (see layer 2 demo)
Some additions to SNasm (savebin, savesna, can now use : to seperate asm lines etc)


V0.6
----
Swapped HLDE to DEHL to aid C compilers
ACC32 changed to A32
TEST $00 added


V0.5
----
Added in lots more new Z80 opcodes (see below)
128 SNA snapshots can now be loaded properly
Shadow screen (held in bank 7) can now be used


V0.4
----
New debugger!!!  F1 will enter/exit the debugger
Sprite shape port has changed (as per spec) from  $55 to $5B
Loading files from RST $08 require the drive to be set (or gotten) properly - as per actual machines. 
  RST $08/$89 will return the drive needed. 
  Please see the example filesystem.asm for this.
  You can also pass in '*' or '$' to set the current drive to be system or default
Basic Audio now added (beeper)
New sprite priorities using register 21. Bits 4,3,2
New Layer 2 double buffering via Reg 18,Reg 19 and bit 3 of port $123b



Final new Z80 opcodes on the NEXT (V1.10.06 core)
======================================================================================
   swapnib           ED 23           8Ts      A bits 7-4 swap with A bits 3-0
   mul               ED 30           8Ts      Multiply D*E = DE (no flags set)
   add  hl,a         ED 31           8Ts      Add A to HL (no flags set)
   add  de,a         ED 32           8Ts      Add A to DE (no flags set)
   add  bc,a         ED 33           8Ts      Add A to BC (no flags set)
   add  hl,$0000     ED 34 LO HI     16Ts     Add $0000 to HL (no flags set)
   add  de,$0000     ED 35 LO HI     16Ts     Add $0000 to DE (no flags set)
   add  bc,$0000     ED 36 LO HI     16Ts     Add $0000 to BC (no flags set)
   ldix              ED A4           16Ts     As LDI,  but if byte==A does not copy
   ldirx             ED B4           21Ts     As LDIR, but if byte==A does not copy
   lddx              ED AC           16Ts     As LDD,  but if byte==A does not copy, and DE is incremented
   lddrx             ED BC           21Ts     As LDDR,  but if byte==A does not copy
   ldpirx            ED B7           16/21Ts  (de) = ( (hl&$fff8)+(E&7) ) when != A
   ldirscale         ED B6           21Ts     As LDIRX,  if(hl)!=A then (de)=(hl); HL_E'+=BC'; DE+=DE'; dec BC; Loop.
   ldws				 ED A5			 14Ts	  LD (DE),(HL): INC D: INC L
   mirror a          ED 24           8Ts      Mirror the bits in A     
   push $0000        ED 8A LO HI     19Ts     Push 16bit immidiate value
   nextreg reg,val   ED 91 reg,val   20Ts     Set a NEXT register (like doing out($243b),reg then out($253b),val )
   nextreg reg,a     ED 92 reg       17Ts     Set a NEXT register using A (like doing out($243b),reg then out($253b),A )
   pixeldn           ED 93           8Ts      Move down a line on the ULA screen
   pixelad           ED 94           8Ts      Using D,E (as Y,X) calculate the ULA screen address and store in HL
   setae             ED 95           8Ts      Using the lower 3 bits of E (X coordinate), set the correct bit value in A
   test $00          ED 27           11Ts     And A with $XX and set all flags. A is not affected.
   outinb            ED 90           16Ts     OUT (C),(HL), HL++



General Emulator Keys
======================================================================================
Escape - quit
F1 - Enter/Exit debugger
F2 - load SNA
F3 - reset
F5 - 3.5Mhz mode  	(when not in debugger)
F6 - 7Mhz mode		(when not in debugger)
F7 - 14Mhz mode		(when not in debugger)
F8 - 28Mhz mode		(when not in debugger)





Debugger Keys
======================================================================================
F1                  - Exit debugger
F2                  - load SNA
F3                  - reset
F7                  - single step
F8                  - Step over (for loops calls etc)
F9                  - toggle breakpoint on current line
Up                  - move user bar up
Down                - move user bar down
PageUp              - Page disassembly window up
PageDown            - Page disassembly window down
SHIFT+Up            - move memory window up 16 bytes
SHIFT+Down          - move memory window down 16 bytes
SHIFT+PageUp        - Page memory window up
SHIFT+PageDown      - Page memory window down
CTRL+SHIFT+Up       - move trace window up 16 bytes
CTRL+SHIFT+Down     - move trace window down 16 bytes
CTRL+SHIFT+PageUp   - Page trace window up
CTRL+SHIFT+PageDown - Page trace window down

Mouse is used to toggle "switches"
HEX/DEC mode can be toggled via "switches"




Debugger Commands
======================================================================================
M <address>         Set memory window base address (in normal 64k window)
M <bank>:<offset>   Set memory window into physical memory using bank/offset
G <address>         Goto address in disassembly window
BR <address>        Toggle Breakpoint
WRITE <address>     Toggle a WRITE access break point
READ  <address>     Toggle a READ access break point (also when EXECUTED)
PUSH <value>        push a 16 bit value onto the stack
POP				    pop the top of the stack
POKE <add>,<val>    Poke a value into memory
Registers:
   A  <value>       Set the A register
   A' <value>       Set alternate A register
   F  <value>       Set the Flags register
   F' <value>       Set alternate Flags register
   AF <value>       Set 16bit register pair value
   AF'<value>       Set 16bit register pair value
   |
   | same for all others
   |
   SP <value>       Set the stack register
   PC <value>       Set alternate program counter register
LOG OUT [port]      LOG all port writes to [port]. If port is not specified, ALL port writes are logged.
                    (Logging only occurs when values to the port change)
LOG IN  [port]      LOG all port reads from [port]. If port is not specified, ALL port reads are logged.
                    (Logging only occurs when values port changes)


Some Registers
======================================================================================

Layer 2 access
==============
port $123b
bit 0 = WRITE paging on. $0000-$3fff write access goes to selected Layer 2 page 
bit 1 = Layer 2 ON (visible)
bit 3 = Page in back buffer (reg 19)
bit 6/7= VRAM Banking selection (layer 2 uses 3 banks) (0,$40 and $c0 only)

Tilemap format
==============
bits 15-12 : palette offset
bit 11 : x mirror
bit 10 : y mirror
bit 9 : rotate
bit 8 : ula over tilemap
bits 7-0 : tile id





Kempston mouse 
==============
Buttons  $fadf
Wheel    $fadf	  ( top 4 bits )
Mouse X  $fddf    (0 to 255 continuous clocking)
Mouse Y  $ffdf    (0 to 255 continuous clocking) 


Kempston Joystick
=================
Port $1f(first) and port $37(second)
Right = 1
Left  = 2 
Down  = 4
Up    = 8
Fire/B= 16
C     = 32		; Sega pad
A     = 64		; Sega pad
Start = 128		; Sega pad


esxDOS simulation
===================
M_GETSETDRV	-	simulated
F_OPEN		-	simulated
F_READ		-	simulated
F_WRITE		-	simulated
F_CLOSE		-	simulated
F_SEEK      -   simulated
F_FSTAT     -   simulated
F_STAT      -   simulated


.NEX file format (V1.0)
=======================
unsigned char Next[4];			//"Next"
unsigned char VersionNumber[4];	//"V1.0"
unsigned char RAM_Required;		//0=768K, 1=1792K
unsigned char NumBanksToLoad;	//0-112 x 16K banks
unsigned char LoadingScreen;	//1=YES load palette also and layer2 at 16K page 9.
unsigned char BorderColour;		//0-7 ld a,BorderColour:out(254),a
unsigned short SP;				//Stack Pointer
unsigned short PC;				//Code Entry Point : $0000 = Don't run just load.
unsigned short NumExtraFiles;	//NumExtraFiles
unsigned char Banks[64+48];		//Which 16K Banks load.
unsigned char RestOf512Bytes[512-(4+4 +1+1+1+1 +2+2+2 +64+48 )];
if LoadingScreen!=0 {
	unsigned short	palette[256];
	unsigned char	Layer2LoadingScreen[49152];
}
Banks[...]						// Bank 5 is first (loaded to $4000), then bank 2 (to $8000) then bank 0(to $C000)  - IF these banks are in the file via Banks[] array


Next OS streaming API
---------------------
; *************************************************************************** 
; * DISK_FILEMAP ($85)                                                      * 
; *************************************************************************** 
; Obtain a map of card addresses describing the space occupied by the file. 
; Can be called multiple times if buffer is filled, continuing from previous. 
; Entry: 
;       A=file handle (just opened, or following previous DISK_FILEMAP calls) 
;       IX=buffer 
;       DE=max entries (each 6 bytes: 4 byte address, 2 byte sector count) 
; Exit (success): 
;       Fc=0 
;       DE=max entries-number of entries returned 
;       HL=address in buffer after last entry 
;       A=card flags: bit 0=card id (0 or 1) 
;                     bit 1=0 for byte addressing, 1 for block addressing 
; Exit (failure): 
;       Fc=1 
;       A=error 
; 
; NOTES: 
; Each entry may describe an area of the file between 2K and just under 32MB 
; in size, depending upon the fragmentation and disk format. 
; Please see example application code, stream.asm, for full usage information 
; (available separately or at the end of this document).

; *************************************************************************** 
; * DISK_STRMSTART ($86)                                                    * 
; *************************************************************************** 
; Start reading from the card in streaming mode. 
; Entry: IXDE=card address 
;        BC=number of 512-byte blocks to stream 
;        A=card flags. $80 = don't wait for card being ready.
; Exit (success): Fc=0 
;                 B=0 for SD/MMC protocol, 1 for IDE protocol 
;                 C=8-bit data port 
; Exit (failure): Fc=1, A=esx_edevicebusy 
; ; NOTES: 
; On the Next, this call always returns with B=0 (SD/MMC protocol) and C=$EB 
; When streaming using the SD/MMC protocol, after every 512 bytes you must read 
; a 2-byte CRC value (which can be discarded) and then wait for a $FE value 
; indicating that the next block is ready to be read. 
; Please see example application code, stream.asm, for full usage information 
; (available separately or at the end of this document).

; *************************************************************************** 
; * DISK_STRMEND ($87)                                                      * 
; *************************************************************************** 
; Stop current streaming operation. 
; Entry: A=card flags 
; Exit (success): Fc=0 
; Exit (failure): Fc=1, A=esx_edevicebusy 
; 
; NOTES: 
; This call must be made to terminate a streaming operation. 
; Please see example application code, stream.asm, for full usage information 
; (available separately or at the end of this document).



SDCARD setup 
------------
Download the latest SD card from https://www.specnext.com/category/downloads/
Copy onto an SD card (preferably 2GB and less than 16GB as it's your Next HD for all your work)
Copy the files "enNextZX.rom" and "enNxtmmc.rom" from this SD Card into the root of the CSpect folder
Download Win32DiskImager ( https://sourceforge.net/projects/win32diskimager/ )
make an image of the SD card
start CSpect with the command line... 

"CSpect.exe -w3 -zxnext -nextrom -mmc=<SD_CARD_PATH>\sdcard.img"

I'd also recommend downloading HDFMonkey, which lets you copy files to/from the SD image. 
This tool can be used while CSpect is running, meaning you can just reset and remount the image
if you put new files on it - just like the real machine.
This tool also lets you rescue files saved onto the image by CSpect - like a BASIC program
you may have written, or a hiscore file from a game etc.
I found a copy of this tool here: http://uto.speccy.org/downloads/hdfmonkey_windows.zip







