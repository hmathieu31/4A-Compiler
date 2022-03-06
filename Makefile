GRM=src\comp.y
LEX=src\comp.l
BIN=comp.exe

CC=gcc
CFLAGS=-Wall -g

OBJ=y.tab.o lex.yy.o #main.o

all: $(BIN)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) bin\$< -o bin\$@

y.tab.c: $(GRM)
	win_bison -v -d -t $< -o bin\$@

lex.yy.c: $(LEX)
	win_flex --outfile=bin\$@ $<

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) bin\y.tab.o bin\lex.yy.o -o bin\$@

clean:
	ifeq($(OS), Windows_NT)
		powershell Set-Location .\bin ; Remove-Item * -Include *.tab.c, *.tab.h, *.yy.c, *.o, *.output
	else
		cd ./bin ; rm *.tab.c *.tab.h *.yy.c *.o *.output

build: all
	make clean

test: build
	pwsh .\test.ps1