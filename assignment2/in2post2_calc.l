%option noyywrap
%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>
void yyerror(char *);//정의 안하면 오류.

%}
%option yylineno

/* 정규 표현식들. */
delim [ \t]
ws {delim}+
digit [0-9]
letter [A-Za-z]
integer (0|([1-9]{digit}*))
number {integer}(\.{digit}+)?((E|e)[+\-]?{digit}+)?
operator [-+()=/*]
semicolon ;
newline \n

%%

{number} {yylval.real = atof(yytext); return NUMBER; }//scanf보다 편리하게 atof 이용
{operator} {return *yytext;}//기호 그대로 줘야해서
{semicolon} {return *yytext;}
{newline} {return *yytext;}
{ws} {}
. {return OTHER;}


%%