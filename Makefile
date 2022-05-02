GRM=src/comp.y
LEX=src/comp.l
TABL=src/symbolTable.c
BIN=comp.exe
TEST=testInstr.exe

CC=gcc

ifeq ($(OS), Windows_NT)
 PARS=win_bison
else
 PARS=bison
endif

ifeq ($(OS), Windows_NT)
 DICT=win_flex
else
 DICT=flex
endif

CFLAGS=-Wall -g -Isrc/ -Iexternal/ -DLOG_LEVEL=2

OBJ=bin/y.tab.o bin/lex.yy.o bin/symbolTable.o bin/instr.o bin/interpreter.o #main.o
T_OBJ=bin/instr.o bin/testInstr.o

all: $(BIN)

test_sym: $(TEST)

bin/%.o: bin/%.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

bin/%.o: src/%.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

bin/%.o: tests/%.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

bin/y.tab.c: $(GRM)
	$(PARS) -v -d -t $< -o $@

bin/lex.yy.c: $(LEX)
	$(DICT) --outfile=$@ $<

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) bin/y.tab.o bin/lex.yy.o bin/symbolTable.o bin/instr.o bin/interpreter.o -o bin/$@

$(TEST): $(T_OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) bin/instr.o bin/testInstr.o -o bin/$@

clean_obj:
ifeq ($(OS), Windows_NT)
	pwsh -Command Set-location ./bin ; Remove-Item * -Include *.tab.c, *.tab.h, *.yy.c, *.o, *.output
else
	cd ./bin ; rm *.tab.c *.tab.h *.yy.c *.o *.output
endif

clean:
ifeq ($(OS), Windows_NT)
	pwsh -Command Set-location ./bin ; Remove-Item *
else
	cd ./bin ; rm *
endif

build: all
	make clean_obj

test: build
	pwsh ./test.ps1