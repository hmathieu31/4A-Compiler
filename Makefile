GRM=src/comp.y
LEX=src/comp.l
BIN=comp.exe

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

CFLAGS=-Wall -g

OBJ=y.tab.o lex.yy.o #main.o

all: $(BIN)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) bin/$< -o bin/$@

y.tab.c: $(GRM)
	$(PARS) -v -d -t $< -o bin/$@

lex.yy.c: $(LEX)
	$(DICT) --outfile=bin/$@ $<

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) bin/y.tab.o bin/lex.yy.o -o bin/$@

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