
INCLUDE "macros.asm"
INCLUDE "constants.asm"


SECTION "NULL", ROM0[$0000]
NULL::
Null::
null:
	ds 0 ; lol


INCLUDE "home/restarts.asm"
INCLUDE "home/interrupts.asm"

INCLUDE "home/utilities.asm"
	
	
SECTION "Home", ROM0[$0100]

Start::
	di ; Make sure nothing gets in the way
	jr Init ; Skip over header
	nop
	
; Allocate header space for header.
; (Which will be generated by RGBFix)
; Must initialize to 0, otherwise slight conflicts arise
	dbfill ($0150 - $0104), 0
	
	
Init::
	ld sp, $E000 ; Put SP out of HRAM to WRAM (push will write to $DFFF then $DFFE ;)
	
.waitVBlank
	ld a, [rSTAT]
	and 3
	dec a
	jr nz, .waitVBlank
	ld [rLCDC], a ; Shut screen down for init
	ld [rNR52], a ; Kill sound during init
	
	; First step of initializing the game : make sure *all* memory is in a known state
	; Maybe I'm clearing too much, but heh, at least I won't get any unexpected errors
	
	ld hl, $C000
	ld bc, $2000 - 4 ; The last four bytes are stack bytes, and this is the highest point `Fill` will reach. Clearing them would cause it to return to $0000, oopsies!
	xor a
	call Fill ; Clear WRAM bank 0

	; Don't clear the first few bytes, they are either already initialized or will be later before any read
	ld c, hHeldButtons & $FF
.clearHRAM
	xor a
	ld [$ff00+c], a
	inc c
	dec a ; a = $FF
	cp c
	jr nz, .clearHRAM ; Don't clear $FFFF, we'll set it a bit later
	
	; Now, we clear VRAM
	ld hl, $8000
	ld bc, $2000
	xor a
	call Fill
	ld hl, BasicFont
	ld de, $8200
	ld bc, BasicFontEnd - BasicFont
	call Copy
	
	ld hl, $FE00
	ld c, $A0
	; a = 0
.clearOAM
	ld [hl], a
	inc l ; Can't use 16-bit inc/dec on DMG, thus no `rst fill`
	dec b
	jr nz, .clearOAM
	
	; a is zero, btw
	ld [rWX], a
	ld [rWY], a
	ld [rSCX], a
	ld [rSCY], a
	ld [rIF], a ; Clear all interrupts
	ei
	
	ld hl, GOLFName
	ld de, $9821
	rst copyStr
	
	ld a, $09
	ld [rIE], a
	ld a, $E4
	ld [rBGP], a
	ld a, $91
	ld [rLCDC], a
	rst waitVBlank
	
	
MainLoop::
	ld hl, WaitHandshakeStr
	ld de, $98A1
	call CopyStrToVRAM
	
.tryHandshake
	xor a
	ldh [hSerialInput], a
	ldh [hSerialMode], a
	ld a, 2
	ld [rSB], a
	ld a, $80
	ld [rSC], a
	
	
.waitHandshake
	ldh a, [hSerialRecieved]
	and a
	jr z, .waitHandshake
	xor a
	ldh [hSerialRecieved], a
	ldh a, [hSerialOutput]
	dec a
	jr nz, .tryHandshake ; The opposing Gameboy MUST send a $01
	
	ld hl, OKStr
	ld de, $98AF
	call CopyStrToVRAM
	
	ld a, $60
	ldh [hSerialInput], a
	
	ld hl, SelectTradeStr
	ld de, $98C1
	call CopyStrToVRAM
	
.tryMenuSelection
	xor a
	ldh [hSerialRecieved], a
.waitMenuSelection
	ldh a, [hSerialRecieved]
	and a
	jr z, .waitMenuSelection
	ldh a, [hSerialOutput]
	cp $D0
	jr nz, .tryMenuSelection
	ldh [hSerialInput], a
	
	ld hl, OKStr
	ld de, $98CF
	call CopyStrToVRAM
	
	; We're now in the Cable Club !
	jr @
	
	
INCLUDE "home/handlers.asm"
INCLUDE "home/utilities2.asm"

