

SECTION "Restarts", ROM0[$0000]

; rst $00 : Wait until VBlank
; Returns on VBlank rising edge
; a equals current scanline minus $90
_WaitVBlank::
	halt
	rst isVBlanking
	jr nc, _WaitVBlank
	ret
	ds 2

; rst $08 : Returns the current scanline minus $90 in a
; Sets C only if VBlanking (but not if on end of VBlank)
_IsVBlanking::
	ld a, [rLY]
	sub $90
	cp 9
	ret
	ds 1
	
; rst $10 : Sets Z if and only if VRAM can be accessed
_IsVRAMOpen::
	ld a, [rSTAT]
	and 2
	ret
	ds 3
	
; rst $18 : Fill c bytes starting at hl
; Fill value is a
; "Moves" hl, zeroes c
_Fill::
	ld [hli], a
	dec c
	jr nz, _Fill
	ret
	ds 3
	
; rst $20 : Copy c bytes from hl to de
; "Moves" hl and de, zeroes c
; a equals last transferred byte
_Copy::
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, _Copy
	ret
	ds 1
	
; rst $28 : Unused
_rst28::
	ret
	ds 7

	
; rst $30 : Copy the string at hl to de
; Also copies the NULL terminator
_CopyStr::
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, _CopyStr
	ret
	ds 1
	
; rst $38 : Use as a "call [hl]"
; Goes to the fatal error script if the target is not in ROM
_AtHL::
	jp hl ; I was sad this can't have flags :(
	; And then the "jr @+1" tricks came to life :O
	ds 7
