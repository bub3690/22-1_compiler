%{
#include <ctype.h>
#include <stdio.h>

int yyerror(char *);
int yylex(void);//없으면 오류
%}
%union {
        double real; /*YYLVAL이 DOUBLE  변환 안되서 이용. YACC 컴파일러에 따라 다른 것으로 생각.*/
        int symbol;
    }
%token <real> NUMBER
%token OTHER
%left '+' '-'
%left '*' '/'
%right UMINUS

%type <real> expr


%%
lines   :   lines statement
        |   lines '\n'
        |  /* nothing */
        ;

statement   :   expr ';'    {printf("%g\n",$1);}

expr    : expr '+' expr { $$ = $1 + $3; }
        | expr '-' expr { $$ = $1 - $3;}
        | expr '*' expr { $$ = $1 * $3; }
        | expr '/' expr { $$ = $1 / $3;}
        | '(' expr ')'  { $$ = $2;}
        | '-' expr %prec UMINUS { $$ = - $2; }
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
    // if(yyparse() !=0)
    //    fprintf(stderr,"Abonormal exit\n");
    return 0;
}
