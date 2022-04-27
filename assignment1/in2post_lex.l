%{
    /*선언부 - manifest constants, declare variable*/
#include <iostream>
#include <stack>
#include <string>
#include <list>
using namespace std;

    /*
    OPERATOR, integer 순
    */
#define OPER (255) 
#define NUM (254)
#define ERRORS (99)


%}
 /*
    regular definition 
    num이 int를 구성하는 부분.
    부호가 없으면 양수로 취급.  
    음수는 -로 시작하는 것.(예시중에 -로 시작되는 것이 있어서 넣어줬다. 과제수정으로 사용x)
 */
%option yylineno
delim [ \t\n]
ws {delim}+
digit [0-9]
positive_num (0|[1-9]{digit}*)
negative_num ^[-]?[1-9]{digit}*
oper_duplicated [-+]{2,}
oper [+-]


%%
 /*transition rule
    yyleng: length of the lexeme
    yylval : token attribute를 담아서 넘긴다.
    yytext : pointer to lexemeBegin
 */
{ws} {}
{positive_num} { return NUM;}
{negative_num} { return NUM;}
{oper} {return OPER;}

{oper_duplicated} {return ERRORS;}
. {return ERRORS;}
%%

 /*aux function*/
int main(){
    /*
    알고리즘: 스택을 이용해 중위 표기법 -> 후위 표기법 
    - 피연산자는 그대로 출력한다.
    - 연산자가 들어오면, 스택안에 있는 연산자를 출력시키고 자신을 push 한다.
    - token을 모두 받아왔다면, 스택이 비어있는지 체크하고 남은 연산자 출력.
    - 한번에 출력하기위해 출력 리스트인 output_list를 생성.
    - 연속된 연산자가 입력되는 경우
    */
    
    int token;
    stack<string> operator_stack;
    list<string> output_list;
    list<string>::iterator list_iter;

    while((token = yylex())){
        cout<<token<<" ";
        switch(token){
            case OPER:
                if(operator_stack.empty()){
                    operator_stack.push(yytext);
                }
                else{
                    output_list.push_back(operator_stack.top());
                    operator_stack.pop();
                    operator_stack.push(yytext);
                }
                break;
            case NUM:
                //비연산자는 바로출력
                output_list.push_back(yytext);
                break;
            default:
                cout<<"ERROR : not recognized " << yytext <<"\n프로그램 종료.\n";
                goto out;
        }
        
    }
    //종료를 위해
    while(!operator_stack.empty()){
        output_list.push_back(operator_stack.top());
        operator_stack.pop();
    }

    //만약 사이즈가 100이 넘으면 error 출력.
    if(output_list.size()>100){
        cout<<"ERROR: Too much size\n"<<"프로그램 종료.\n";
    }

    
    for(list_iter=output_list.begin(); list_iter!=output_list.end(); list_iter++){
        cout<<*list_iter<<" ";
    }
    cout<<"\n";
    return 0;
    
out:
    return -1;
}

