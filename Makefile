SYSTEM=linux
VASM=vasm/$(SYSTEM)/vasm6502_oldstyle
OPTIONS=-Fbin -dotdir

.PHONY : help
.DEFAULT_GOAL := help

help :
	@echo ''
	@echo '== Usage =='
	@echo '  make help     show this message'
	@echo '  make *.bin    assemle *.s into *.bin'

%.bin : %.s
	@echo ''
	@echo '== Assembling =='
	@$(VASM) $< $(OPTIONS) -o $@

	@echo ''
	@echo '== Hexdump =='
	@hexdump -C $@
