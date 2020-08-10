ifeq ($(OS), Windows_NT)
	SYSTEM := win
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S), Linux)
		SYSTEM := linux
	endif
	ifeq ($(UNAME_S), Darwin)
		SYSTEM := mac
	endif
endif

VASM_DIR := $(PWD)
VASM_EXEC := $(VASM_DIR)/vasm/$(SYSTEM)/vasm6502_oldstyle
VASM_OPTIONS := -Fbin -dotdir
HEXDUMP_OPTIONS := -C
.DEFAULT_GOAL := help

.PHONY: help

help :
	@echo ''
	@echo '== Usage =='
	@echo '  make help     show this message'
	@echo '  make *.bin    assemle *.s into *.bin'

%.bin : %.asm
	@echo ''
	@echo '== Assembling =='
	@$(VASM_EXEC) $< $(VASM_OPTIONS) -o $@

	@echo ''
	@echo '== Hexdump =='
	@hexdump $(HEXDUMP_OPTIONS) $@
