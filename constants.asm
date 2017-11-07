
; ------------- JOYPAD --------------
SELECT_DPAD		EQU (1 << 5)
SELECT_BUTTONS 	EQU (1 << 4)
SELECT_NONE		EQU (SELECT_BUTTONS | SELECT_DPAD)

DPAD_DOWN		EQU (1 << 7)
DPAD_UP			EQU (1 << 6)
DPAD_LEFT		EQU (1 << 5)
DPAD_RIGHT		EQU (1 << 4)

BUTTON_START	EQU (1 << 3)
BUTTON_SELECT	EQU (1 << 2)
BUTTON_B		EQU (1 << 1)
BUTTON_A		EQU (1 << 0)

; -------------- GFX ----------------
LY_VBLANK		EQU $90
SCREEN_WIDTH	EQU 20
SCREEN_HEIGHT	EQU 18

TILE_SIZE		EQU 8 ; Size of a tile in pixels

VRAM_TILE_SIZE	EQU 16 ; Size of a tile in VRAM
VRAM_ROW_SIZE	EQU $20 ; Size of a row of tiles in VRAM

; -------------- MISC ---------------
SRAM_UNLOCK		EQU $0A



waitVBlank		equ $0000
isVBlanking		equ $0008
isVRAMOpen		equ $0010
fill			equ $0018
copy			equ $0020
bankswitch		equ $0028
copyStr			equ $0030
callHL			equ $0038

SRAMEnable		equ $0000
SRAMBank		equ $4000

rOAM			equ $FE00
OAMEnd			equ $FEA0

rJOYP			equ $FF00
rSB				equ $FF01
rSC				equ $FF02
rDIV			equ $FF04
rTIMA			equ $FF05
rTMA			equ $FF06
rTAC			equ $FF07
rIF				equ $FF0F
rNR10			equ $FF10
rNR11			equ $FF11
rNR12			equ $FF12
rNR13			equ $FF13
rNR14			equ $FF14
;rNR20			equ $FF15
rNR21			equ $FF16
rNR22			equ $FF17
rNR23			equ $FF18
rNR24			equ $FF19
rNR30			equ $FF1A
rNR31			equ $FF1B
rNR32			equ $FF1C
rNR33			equ $FF1D
rNR34			equ $FF1E
;rNR40			equ $FF1F
rNR41			equ $FF20
rNR42			equ $FF21
rNR43			equ $FF22
rNR44			equ $FF23
rNR50			equ $FF24
rNR51			equ $FF25
rNR52			equ $FF26
waveBuffer		equ $FF30
rLCDC			equ $FF40
rSTAT			equ $FF41
rSCY			equ $FF42
rSCX			equ $FF43
rLY				equ $FF44
rLYC			equ $FF45
rDMA			equ $FF46
rBGP			equ $FF47
rOBP0			equ $FF48
rOBP1			equ $FF49
rWY				equ $FF4A
rWX				equ $FF4B
rKEY1			equ $FF4D ; Speed switch
rVBK			equ $FF4F ; VRAM Bank
rHDMA1			equ $FF51 ; GBC ("New") DMA source ptr
rHDMA2			equ $FF52 ; WARNING : POINTERS ARE ***BIG-ENDIAN***!!!!!
rHDMA3			equ $FF53 ; GBC DMA destination ptr
rHDMA4			equ $FF54
rHDMA5			equ $FF55 ; GBC DMA length
rBGPI			equ $FF68 ;  BG Pal Index
rBGPD			equ $FF69 ;  BG Pal Data
rOBPI			equ $FF6A ; OBJ Pal Index
rOBPD			equ $FF6B ; OBJ Pal Data
rSVBK			equ $FF70 ; WRAM Bank
rIE				equ $FFFF


OAM_SIZE		equ (OAMEnd - rOAM)
OAM_SPRITE_SIZE	equ 4
NB_OF_SPRITES	equ (OAM_SIZE / OAM_SPRITE_SIZE)

