
INCLUDE "macros.asm"
INCLUDE "constants.asm"

SECTION "Text", ROM0

GOLFName::
	dstr "Gen One Link File               ", "      editor"
	
	
WaitHandshakeStr::
	dstr "Waiting for GB..."
	
SelectTradeStr::
	dstr "Select trade."
	
SendingPayloadStr::
	dstr "Sending payload"
	
DoingMagicStr::
	dstr "Doing RCE magic..."
	
OKStr::
	dstr "  OK"
