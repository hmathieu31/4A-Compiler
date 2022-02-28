%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

%%

[ \t]+	{};
[0-9]+	{
	  yylval.nb = atoi(yytext);
	  return tNB;
	}
"{"	{ return OB; }
","	{ return tCOL}
"}" { return tCB; }
"="	{ return tEGAL; }
"-"	{ return tSOU; }
"+"	{ return tADD; }
"*"	{ return tMUL; }
"/"	{ return tDIV; }
"("	{ return tOP; }
")"	{ return tCP; }
";" { return tSCOL}
[a-z]	{
	  yylval.var = yytext[0];
	  return tID;
	}
\n	{ return tFL; }
.	{ return tERROR; }
