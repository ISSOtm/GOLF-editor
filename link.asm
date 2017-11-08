

INCLUDE "macros.asm"
INCLUDE "constants.asm"

SECTION "Link functions", ROM0

Serial_SyncAndExchangeNybble::
	xor a ; First, don't send any $6X data
	ldh [hSerialInput], a
.tryFirstNybble
	xor a
	ldh [hSerialRecieved], a
.waitFirstNybble
	ldh a, [hSerialRecieved]
	and a
	jr z, .waitFirstNybble
	ldh a, [hSerialOutput]
	and $F0
	cp $60
	jr nz, .tryFirstNybble
	; Once the $6X bytes has been transferred, acknowledge it by sending a $60 back.
	ld a, $60
	ldh [hSerialInput], a
	
	; Now, wait for the last $00 bytes
	ld b, 9
.trySyncBytes
	xor a
	ldh [hSerialRecieved], a
.waitSyncBytes
	ldh a, [hSerialRecieved]
	and a
	jr z, .waitSyncBytes
	ldh a, [hSerialOutput]
	and a
	jr nz, .trySyncBytes
	dec b
	jr nz, .trySyncBytes
	ret
	
	
Serial_IgnoreBCBytes::
	call Serial_WaitPreamble
.oneByte
	xor a
	ldh [hSerialRecieved], a
	ldh [hSerialInput], a
.waitByte
	ldh a, [hSerialRecieved]
	and a
	jr z, .waitByte
	dec bc
	ld a, b
	or c
	jr nz, .oneByte
	ret
	
Serial_SendBytes::
	call Serial_WaitPreamble
.oneByte
	xor a
	ldh [hSerialRecieved], a
	ld a, [hli]
	ldh [hSerialInput], a
.waitByte
	ldh a, [hSerialRecieved]
	and a
	jr z, .waitByte
	dec bc
	ld a, b
	or c
	jr nz, .oneByte
	ret

	
Serial_WaitPreamble::
	xor a
	ldh [hSerialInput], a
.tryPreamble
	xor a
	ldh [hSerialRecieved], a
.waitPreamble
	ldh a, [hSerialRecieved]
	and a
	jr z, .waitPreamble
	ldh a, [hSerialOutput]
	cp $FD
	jr nz, .tryPreamble
	ld a, $FD
	ldh [hSerialInput], a
	xor a
	ldh [hSerialRecieved], a
.waitPreambleTransmitted
	ldh a, [hSerialRecieved]
	and a
	jr z, .waitPreambleTransmitted
	ret
