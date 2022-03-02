%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

D [0-9]

%%
[ \t\n]+	{};
"main()" {return tMAIN;}
"const" {return tCONST;}
"int" {return tINT;}
"printf" {return tPRINT;}
"if" {return tIF;}
"while" {return tWHILE;}
"return" {return tRETURN;}
{D}+	{
	  yylval.nb = atoi(yytext);
	  return tNB;
	}
{D}"e"("+"|-)?{D}+ {
    yylval.nb = (int)strtold(yytext,NULL);
    return tNB;}
"{"	{ return tOB; }
","	{ return tCOL;}
"}" { return tCB; }
"==" {return tEQUAL;}
"="	{ return tEQ; }
"-"	{ return tSUB; }
"+"	{ return tADD; }
"*"	{ return tMUL; }
"/"	{ return tDIV; }
"("	{ return tOP; }
")"	{ return tCP; }
";" { return tSCOL;}
"!=" {return tNEQUAL;}
"<=" {return tEQINF;}
">=" {return tEQSUP;}
">" {return tSUP;}
"<" {return tINF;}
"&&" {return tAND;}
"||" {return tOR;}
[a-zA-Z]([a-zA-Z]|[0-9]|_)*   {
	  yylval.var = yytext[0];
	  return tID;
	}
.	{ return tERROR; }

