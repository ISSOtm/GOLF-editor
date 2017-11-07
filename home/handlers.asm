

SECTION "Interrupt handlers", ROM0

VBlankHandler::
UpdateJoypadState:: ; Initially part of VBlank, but may be used independently
	; Poll joypad
	ldh a, [hHeldButtons]
	cpl
	ld c, a
	ld a, SELECT_DPAD
	call PollJoypad
	cp (((DPAD_DOWN | DPAD_UP) >> 4) ^ $0F) + 1 ; If both Up and Down are held, both bit 2 and 3 will be unset, so the number will be smaller than this constant ($04)
	; This less intuitive check is used because it doesn't modify a, saving some cycles and instructions
	jr nc, .notUpAndDown
	or (DPAD_DOWN | DPAD_UP) >> 4 ; Cancel Up+Down
.notUpAndDown
	ld b, a
	and (DPAD_LEFT | DPAD_RIGHT) >> 4
	jr nz, .notLeftAndRight
	ld a, b
	or (DPAD_LEFT | DPAD_RIGHT) >> 4
	ld b, a
.notLeftAndRight
	swap b
	ld a, SELECT_BUTTONS
	call PollJoypad
	or b
	cpl
	ldh [hHeldButtons], a
	and c
	ldh [hPressedButtons], a
	ret
	
PollJoypad::
	ld [rJOYP], a
REPT 3
	ld a, [rJOYP]
ENDR
	and $0F
	ret
	
	
SerialHandler::
	ld a, [rSB]
	ldh [hSerialOutput], a
	ldh a, [hSerialInput]
	ld [rSB], a
	ld a, 1
	ldh [hSerialRecieved], a
	
	ldh a, [hSerialMode]
	and a
	ret nz
	ld a, $80
	ld [rSC], a
	ret
