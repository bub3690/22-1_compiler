%{
#include <ctype.h>
#include <stdio.h>
#include <string.h>

int yyerror(const char *);
int yylex(void);// 없으면 오류
int lookup(const char *);

struct symbol_table_struct {
    char id_name[100];
    int type; // flag 값이 담기는 것. 1: int , 2: float
    // 심볼 테이블은 타입과 name으로 구성.
};

struct symbol_table_struct symbol_table[500];

int symbol_length=0;
int sym_index=0;

enum {
    INT_TYPE =1,
    FLOAT_TYPE
};
int type_flag = 0;

char temp_var[6];
int temp_cnt = 0;

%}
%union {
        /* yylval에는 int,부동소수점,lexeme들이 담길 수 있다. 변수 타입들은 int_lval으로 받는다.*/
        int int_lval;
        char string_lval[256];
    }
%token <string_lval> FLOAT
%token <string_lval> INT
%token <string_lval> IDENTIFIER
%token <string_lval> EQUAL
%token <int_lval> TYPE
%token OTHER
%left '+' '-'
%left '*' '/'
%right UMINUS

%type <string_lval> expr


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
        sym_index = lookup($1);
        if(sym_index == -1){

            fprintf(stderr,"ERROR !\n %s is unknown id. \n",$1); // input3 내용
            
            exit(0); // 바로 죵료.
        }

        // 3 address code. expr 에서 t0~ 로 수정된다.
        fprintf(stdout,"%s = %s\n",$1,$3);

        // 출력후 타입 미스매치 warn
        if(type_flag != symbol_table[sym_index].type){
            fprintf(stdout,"//warning : type mismatch\n");
        }

        type_flag = 0;
}
    ;

declaration : TYPE IDENTIFIER {
        // declaration에서는 출력은 없다.
        // ERROR : already declared
        if(lookup($2) != -1 ){
            
            fprintf(stderr,"ERROR !\n%s is already declared\n",$2);
            exit(0);
        }

        strcpy(symbol_table[symbol_length].id_name, $2);
        symbol_table[symbol_length].type = $1;
        symbol_length++;
        
    }
    ;

expr :  FLOAT    {
                    type_flag = FLOAT_TYPE;
                    strcpy($$,$1);
                    }
    |   INT     {
                
                type_flag = INT_TYPE;
                strcpy($$, $1);

                }
    |   IDENTIFIER  {
                // expr에서 identifier는 심볼테이블에 존재하는 것.
                sym_index = lookup($1);
                if(sym_index == -1){
                    fprintf(stderr,"ERROR !\n %s is unknown id. \n",$1);
                    exit(0);
                }
                
                type_flag = symbol_table[sym_index].type;
                strcpy($$,$1);
                }
    |   expr '+' expr   {
                            // expr 연산 exp. 새로운 임시변수 할당. 3 add code 출력하기.
                            sprintf(temp_var,"t%d",temp_cnt);
                            temp_cnt++;
                            strcpy($$,temp_var);
                            fprintf(stdout,"%s = %s + %s\n",temp_var,$1,$3);
                        }
    |   expr '-' expr   {
                            // expr 연산 exp. 새로운 임시변수 할당. 3 add code 출력하기.
                            sprintf(temp_var,"t%d",temp_cnt);
                            temp_cnt++;
                            strcpy($$,temp_var);
                            fprintf(stdout,"%s = %s - %s\n",temp_var,$1,$3);
                        }
    |   expr '*' expr   {
                            // expr 연산 exp. 새로운 임시변수 할당. 3 add code 출력하기.
                            sprintf(temp_var,"t%d",temp_cnt);
                            temp_cnt++;
                            strcpy($$,temp_var);
                            fprintf(stdout,"%s = %s * %s\n",temp_var,$1,$3);
                        }
    |   expr '/' expr   {
                            // expr 연산 exp. 새로운 임시변수 할당. 3 add code 출력하기.
                            sprintf(temp_var,"t%d",temp_cnt);
                            temp_cnt++;
                            strcpy($$,temp_var);
                            fprintf(stdout,"%s = %s / %s\n",temp_var,$1,$3);
                        }
    |   '-' expr %prec UMINUS   {
                                // - 계수도 TEMP로
                                sprintf(temp_var,"t%d",temp_cnt);
                                temp_cnt++;
                                strcpy($$,temp_var);
                                fprintf(stdout, "%s = -%s\n", $$, $2);
                                }
    ;


%%
int lookup(const char *lexeme){
    int symbol_index = -1; // -1이면 아직 선언 안된 것.
    //  symbol_length : real length of symbol table
    for(int i=0; i<symbol_length ; i++){
        if(strcmp( symbol_table[i].id_name, lexeme ) == 0){
            
            symbol_index = i;
            break;

        }

    }
    return symbol_index;

}


int yyerror(const char *s)
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
