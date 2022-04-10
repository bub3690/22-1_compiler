%{
    /*선언부 - manifest constants, declare variable*/
#include <iostream>
using namespace std;
int ch=0, wd =0, nl=0;
%}
/*regular definition*/
%option yylineno
delim [ \t]+

%%
 /*transition rule
    yyleng: length of the lexeme
    yylval : token attribute를 담아서 넘긴다.
    yytext : pointer to lexemeBegin
 */
\n  { ch++;wd++;nl++; }
^{delim}   {ch+=yyleng;}
{delim} {ch+=yyleng; wd++;}
. {ch++;}
%%

 /*aux function*/
main(){
    yylex();
    cout.width(8);
    cout<< ch <<"\n";
    cout.width(8);
    cout<< wd<<"\n";
    cout.width(8);
    cout<< nl <<"\n";
    return 0;
}

