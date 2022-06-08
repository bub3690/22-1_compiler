%option noyywrap
%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>
void yyerror(char *);//정의 안하면 오류.

enum {
    INT_TYPE =1,
    FLOAT_TYPE
};

%}
%option yylineno

/* 정규 표현식들. */
delim [ \t]
ws {delim}+
digit [0-9]
letter [A-Za-z]
id {letter}({letter}|{digit})*
integer (0|([1-9]{digit}*))
number {integer}\.{digit}+((E|e)[+\-]?{digit}+)?
operator [-+()/*]
semicolon ;
newline \n

%%

{number} { strcpy(yylval.string_lval,yytext); return FLOAT; }// 이 과제는 부동소수점만.
{integer} {strcpy(yylval.string_lval,yytext); return INT;}
"int" { yylval.int_lval = INT_TYPE; return TYPE; }
"float" { yylval.int_lval = FLOAT_TYPE; return TYPE;}
"=" {strcpy(yylval.string_lval,yytext); return EQUAL;}
{id} { strcpy(yylval.string_lval, yytext); return IDENTIFIER; }
{operator} {return *yytext;}//기호 그대로 줘야해서
{semicolon} {return *yytext;}
{newline} {return *yytext;}
{ws} {}
. {return OTHER;}


%%