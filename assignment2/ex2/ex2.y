%{
#include <ctype.h>
#include <stdio.h>
//#define YYSTYPE double //Double type for attributes and yylval

int yyerror(char *);
int yylex(void);//없으면 오류
%}
%token NUMBER
%left '+' '-'
%left '*' '/'
%right UMINUS
%%
lines   :   lines expr '\n' { printf("%g\n",$2); }
        |   lines '\n'
        |  /* nothing */
        ;
expr    : expr '+' expr { $$ = $1 + $3; }
        | expr '-' expr { $$ = $1 - $3; }
        | expr '*' expr { $$ = $1 * $3; }
        | expr '/' expr { $$ = $1 / $3; }
        | '(' expr ')'  { $$ = $2;}
        | '-' expr %prec UMINUS { $$ = -$2; }
        | NUMBER
        ;
%%
int yyerror(char *s)
{
    fprintf(stderr,"ERROR: %s\n",s);
}
int main()
{
    yyparse();
    //if(yyparse() !=0)
    //    fprintf(stderr,"Abonormal exit\n");
    return 0;
}
