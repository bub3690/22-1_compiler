%{
#include <iostream>
#include<cstdio>
using namespace std;

int yyerror(char *);
int yylex(void);
%}
%token DIGIT
%%
line    : expr '\n' {cout<<$1<<"\n";}
    ;
expr    : expr '+' term { $$ = $1 + $3;}
    | term  {$$ = $1;}
    ;
term    : term '*' factor   {$$ = $1 + $3;}
    | factor    {$$ = $1;}
    ;
factor  : '(' expr ')'  { $$ = $2;}
    |   DIGIT   { $$ = $1;}
    ;
%%
int yylex()
{
    int c = getchar();
    cout<<c;
    if(isdigit(c))
    {
        yylval = c-'0';
        return DIGIT;
    }
    return c;
}
int yyerror(char *s)
{
    fprintf(stderr,"ERROR : %s\n",s);

}
int main(){
    if(yyparse() !=0) fprintf(stderr,"Abonormal exit\n");
    return 0;

}