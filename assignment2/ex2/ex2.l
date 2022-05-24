%option noyywrap
%{
#include "ex2.tab.h"
#include <stdlib.h>
void yyerror(char *);

extern double yylval;
%}
number [0-9]+\.?|[0-9]*\.[0-9]+
ws [ ]
%%
{ws} {/* blank */}
{number}    {sscanf(yytext, "%lf", &yylval);
                return NUMBER;}
\n | .  { return yytext[0];}

