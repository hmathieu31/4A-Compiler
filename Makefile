GRM=src/comp.y
LEX=src/comp.l
TABL=src/symbolTable.c
BIN=comp.exe
TEST=testSymbol.exe

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

CFLAGS=-Wall -g -Isrc/

OBJ=y.tab.o lex.yy.o symbolTable.o instr.o #main.o
T_OBJ=symbolTable.o

all: $(BIN)

test_sym: $(TEST)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) bin/$< -o bin/$@

symbolTable.o: $(TABL)
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o bin/$@

instr.o: $(TABL)
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o bin/$@

y.tab.c: $(GRM)
	$(PARS) -v -d -t $< -o bin/$@

lex.yy.c: $(LEX)
	$(DICT) --outfile=bin/$@ $<

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) bin/y.tab.o bin/lex.yy.o bin/symbolTable.o bin/instr.o -o bin/$@

$(TEST): $(T_OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) bin/symbolTable.o tests/testSymbolTable.c -o bin/$@

clean:
ifeq ($(OS), Windows_NT)
	pwsh -Command Set-location ./bin ; Remove-Item * -Include *.tab.c, *.tab.h, *.yy.c, *.o, *.output
else
	cd ./bin ; rm *.tab.c *.tab.h *.yy.c *.o *.output
endif

build: all
	make clean

test: build
	pwsh ./test.ps1