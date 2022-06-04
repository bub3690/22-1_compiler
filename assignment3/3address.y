%{
#include <ctype.h>
#include <stdio.h>

int yyerror(char *);
int yylex(void);//없으면 오류
int get_idx_symboltable(char *lexeme);
struct symbol_table_struct symbol_table[256];

%}
%union {
        /* yylval에는 float,int, lexeme들이 담길 수 있다. */
        float float_lval;
        int int_lval;
        char * string_lval[256];
    }
%token <real> NUMBER
%token <float_lval> FLOAT
%token <int_lval> INT
%token <string_lval> IDENTIFIER
%token <string_lval> EQUAL
%token OTHER
%left '+' '-'
%left '*' '/'
%right UMINUS

%type <real> expr


%%
lines   :   lines statements
        |   lines '\n'
        |  /* nothing */
        ;

statements   :   stmt ';'
            ;
/* 코드들이 ;로 구분 된다는 뜻.*/

stmt    :   assignment
        |   declaration
        ;
/* 해당 코드가 할당문인지 declaration문인지 구분을 해야함. 기능이 다르기 때문. 
 assignment :  기본연산 수행 및 symboltable을 참조하여 할당.
 declaration : 변수를 생성해서, symboltable에 record 생성.*/

assignment  :   IDENTIFIER EQUAL expr {
        /* symbol table에서 가져오기. */
        



}
    ;




%%
int get_idx_symboltable(char *lexeme){
    


}


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
