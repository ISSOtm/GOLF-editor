
; Copyright 2017 Aevilia Dev Team
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
; http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.


INCLUDE "macros.asm"
INCLUDE "constants.asm"


SECTION "WRAM", WRAM0


SECTION "HRAM", HRAM

hHeldButtons::
	ds 1
	
hPressedButtons::
	ds 1
	
	
hRandIntHigh::
	ds 1
hRandIntLow::
	ds 1
	
	
hSerialInput::
	ds 1
hSerialOutput::
	ds 1
hSerialRecieved::
	ds 1
hSerialMode:: ; 0 if slave, $80 if master
	ds 1
