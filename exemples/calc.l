%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

D [0-9]

%%

[ \t]+	{};
"main" {return tMAIN;}
"const" {return tCONST;}
"int" {return tINT;}
"printf" {return tPRINT;}
{D}+	{
	  yylval.nb = atoi(yytext);
	  return tNB;
	}
"="	{ return tEGAL; }
"-"	{ return tSOU; }
"+"	{ return tADD; }
"*"	{ return tMUL; }
"/"	{ return tDIV; }
"("	{ return tPO; }
")"	{ return tPF; }
[a-zA-Z]{[a-zA-Z]|[0-9]|"_"}*	{
	  yylval.var = yytext[0];
	  return tVAR;
	}
\n	{ return tFL; }

.	{ return tERROR; }
