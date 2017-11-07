

SECTION "Interrupt vectors", ROM0[$0040]

; VBlank
VBlank_int::
	push af
	push bc
	call VBlankHandler
	pop bc
	pop af
	reti
	
; STAT
STAT_int::
	reti
	ds 7
	
; Timer
Timer_int::
	reti
	
; Delay bc frames
DelayBCFrames::
	rst waitVBlank
	dec bc
	ld a, b
	or c
	jr nz, DelayBCFrames
	ret
	
; Serial
Serial_int::
	push af
	push hl
	call SerialHandler
	pop hl
	pop af
	reti
	
; Joypad
Joypad_int::
	reti ; Will never be used, I think
	; Thus, no extra space behind it, so we can fit 7 more function bytes :)
