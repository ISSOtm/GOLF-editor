
INCLUDE "macros.asm"
INCLUDE "constants.asm"

SECTION "Text", ROM0

GOLFName::
	dstr "Gen One Save File               ", "      editor"
	
	
WaitHandshakeStr::
	dstr "Waiting for GB..."
	
SelectTradeStr::
	dstr "Select trade."
	
OKStr::
	dstr "  OK"