

SECTION "Utilities 1", ROM0[$0061]

; Fills bc bytes from hl
; Zeroes bc, moves hl, preserves a
Fill::
	dec c
	inc c
	jr nz, .loop
	dec b
.loop
	rst fill
	ld c, a
	ld a, b
	and a
	ld a, c
	ld c, 0
	ret z
	dec b
	jr .loop
	
; Copies bc bytes from hl to de
; Zeroes bc, moves hl and de, zeroes a
Copy::
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, Copy
	ret
	
	
; Fill c bytes in VRAM
FillVRAMLite::
	ld d, a
.fillLoop
	rst isVRAMOpen
	jr nz, .fillLoop
	ld a, d
	ld [hli], a
	dec c
	jr nz, .fillLoop
	ret
	
; Copy c bytes from hl to de, assuming de is in VRAM
; Thus, you guess what it does and that I am tired of copy-pasting that line over and over
CopyToVRAMLite::
	rst isVRAMOpen
	jr nz, CopyToVRAMLite
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, CopyToVRAMLite
	ret
	
; Copies bc bytes from de to hl
; Assumes de points to VRAM, so doesn't copy unless VRAM can be accessed
CopyToVRAM::
	rst isVRAMOpen
	jr nz, CopyToVRAM
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, CopyToVRAM
	ret
	
; Copies the string pointed to by hl to de
; Assumes de points to VRAM, so doesn't copy unless VRAM can be accessed
CopyStrToVRAM::
	rst isVRAMOpen
	jr nz, CopyStrToVRAM
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, CopyStrToVRAM
	ret
	
FillVRAM::
	ld d, a
.fillLoop
	rst isVRAMOpen
	jr nz, .fillLoop
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .fillLoop
	ret
	
	
; Shamelessly stolen from SM64
; It's a very neat bijection, and I'm not good enough to produce such a nice function
; I didn't implement the weird re-looping they did, though X)
RandInt::
	ldh a, [hRandIntLow]
	ld c, a
	cp $0A
	ldh a, [hRandIntHigh]
	jr nz, .dontChangeCycles
	cp $56
	jr nz, .dontChangeCycles
	xor a
	ld c, a
.dontChangeCycles
	xor c
	ld h, a
	ld l, c
	ld b, l
	ld c, h
	add hl, hl
	ld a, l
	xor c
	ld l, a
	ld a, h
	and $01 ; Remove pre-shift upper byte
	xor b ; Resets carry
	rra
	cpl
	ld h, a
	ld a, l
	rra
	ld bc, $1F74
	jr nc, .useThatConstant
	ld bc, $8100
.useThatConstant
	xor c
	ld l, a
	ldh [hRandIntLow], a
	ld a, h
	xor b
	ld h, a
	ldh [hRandIntHigh], a
	ret
	
	
; Prints b as hex to de
; Advances de as well
PrintHex::
	ld a, b
	and $F0
	swap a
	add a, "0"
	cp ":"
	jr c, .isDigitHigh
	add a, "A" - ":"
.isDigitHigh
	ld [de], a
	inc de
	ld a, b
	and $0F
	add a, "0"
	cp ":"
	jr c, .isDigitLow
	add a, "A" - ":"
.isDigitLow
	ld [de], a
	inc de
	ret
