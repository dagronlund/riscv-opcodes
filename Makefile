SHELL := /bin/sh

SPIKE_H := ../spike/riscv/riscv-opc.h
BINUTILS_H := ../binutils/include/opcode/riscv-opc.h
FESVR_H := ../fesvr/fesvr/encoding.h

ALL_OPCODES := opcodes-pseudo opcodes opcodes-rvc opcodes-rvc-pseudo opcodes-custom opcodes-vec

install: $(SPIKE_H) $(BINUTILS_H) $(FESVR_H)

$(SPIKE_H) $(BINUTILS_H) $(FESVR_H): $(ALL_OPCODES) parse-opcodes encoding.h
	cp encoding.h $@
	cat opcodes-pseudo opcodes opcodes-rvc opcodes-rvc-pseudo opcodes-custom opcodes-vec | ./parse-opcodes -c > $@

inst.chisel: $(ALL_OPCODES) parse-opcodes
	cat opcodes opcodes-rvc opcodes-rvc-pseudo opcodes-custom opcodes-pseudo opcodes-vec | ./parse-opcodes -chisel > $@

inst.go: opcodes opcodes-pseudo parse-opcodes
	cat opcodes opcodes-pseudo | ./parse-opcodes -go > $@

instr-table.tex: $(ALL_OPCODES) parse-opcodes
	cat opcodes opcodes-pseudo | ./parse-opcodes -tex > $@

priv-instr-table.tex: $(ALL_OPCODES) parse-opcodes
	cat opcodes opcodes-pseudo | ./parse-opcodes -privtex > $@

.PHONY : install
