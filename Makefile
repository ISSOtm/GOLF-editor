
.SHELL: /bin/bash
.PHONY: all rebuild clean
.SUFFIXES:
.DEFAULT_GOAL: all


ROMVersion = 0
FillValue = 0xFF

GameID = GOLF
GameTitle = GEN1SAVEDIT
NewLicensee = 42
OldLicensee = 0x33
# ROM+RAM+BATTERY
MBCType = 0x09
# ROMSize = 0x00
SRAMSize = 0x02

bindir = ./bin
objdir = ./obj

objlist = $(objdir)/main.o $(objdir)/home.o $(objdir)/gfx.o $(objdir)/link.o $(objdir)/text.o

ASFLAGS  = -E -p $(FillValue)
LDFLAGS  = -dt
FIXFLAGS = -jv -i $(GameID) -k $(NewLicensee) -l $(OldLicensee) -m $(MBCType) -n $(ROMVersion) -p $(FillValue) -r $(SRAMSize) -t $(GameTitle)

RGBASM = ./rgbasm
RGBLINK = ./rgblink
RGBFIX = ./rgbfix


all: $(bindir)/GOLF_editor.gbc

rebuild: clean all

clean:
	rm -f $(objdir)/*.o
	rm -f $(bindir)/GOLF_editor.gbc $(bindir)/GOLF_editor.map $(bindir)/GOLF_editor.sym

$(bindir)/%.sym:
	@if [ ! -d bin ]; then mkdir $(bindir); fi
	rm $(@:.sym=.gbc)
	make $(@:.sym=.gbc)

$(bindir)/GOLF_editor.gbc: $(objlist)
	@if [ ! -d bin ]; then mkdir $(bindir); fi
	$(RGBLINK) $(LDFLAGS) -n $(bindir)/GOLF_editor.sym -m $(bindir)/GOLF_editor.map -o $@ $^
	$(RGBFIX) $(FIXFLAGS) $(@)
	
	
$(objdir)/%.o: %.asm constants.asm macros.asm
	@if [ ! -d obj ]; then mkdir $(objdir); fi
	$(RGBASM) $(ASFLAGS) -o $@ $<
	
	
# Define special dependencies here (see "$(objdir)/%.o" rule for default dependencies)
$(objdir)/home.o: home/*.asm

$(objdir)/gfx.o: gfx/*.asm
