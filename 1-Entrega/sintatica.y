%{
#include <iostream>
#include <string>
#include <sstream>

#define YYSTYPE atributos

using namespace std;

int varCount=0;

string to_string(int i);
string addNewVar();

struct atributos
{
	string label;
	string traducao;
};

int yylex(void);
void yyerror(string);
%}

%token TK_NUM
%token TK_MAIN TK_ID TK_TIPO_INT TK_TIPO_FLOAT TK_TIPO_CHAR TK_TIPO_BOOL
%token TK_FIM TK_ERROR

%start S

%right '='
%left '+'


%%

S 			: TK_TIPO_INT TK_MAIN '(' ')' BLOCO
			{
				cout << "/*Compilador FOCA*/\n" << "#include <iostream>\n#include<string.h>\n#include<stdio.h>\nint main(void)\n{\n" << $5.traducao << "\treturn 0;\n}" << endl; 
			}
			;

BLOCO		: '{' COMANDOS '}'
			{
				$$.traducao = $2.traducao;
			}
			;

COMANDOS	: COMANDO COMANDOS
			{
			 $$.traducao = $1.traducao + $2.traducao;
			}
			|
			;

COMANDO 	: E ';'
			;

E 			: E '+' E
			{
				string var = addNewVar();

				$$.traducao = $1.traducao + $3.traducao + "\t" + var + " = " + $1.label + " + " + $3.label  +";\n";

				$$.label = var;

			}
			| E '-' E
			{
				string var = addNewVar();

				$$.traducao = $1.traducao + $3.traducao + "\t" + var + " = " + $1.label + " - " + $3.label  +";\n";

				$$.label = var;

			}
			| E '*' E
			{
				string var = addNewVar();

				$$.traducao = $1.traducao + $3.traducao + "\t" + var + " = " + $1.label + " * " + $3.label  +";\n";

				$$.label = var;

			}
			| E '/' E
			{
				string var = addNewVar();

				$$.traducao = $1.traducao + $3.traducao + "\t" + var + " = " + $1.label + " / " + $3.label  +";\n";

				$$.label = var;

			}
			| E '=' E
			{	
				string var = addNewVar();
				$$.traducao = $1.traducao + $3.traducao + "\t" + $1.label + " = " + $3.label + ";\n";

			}
			| TK_NUM
			{
				string var = addNewVar();

				$$.traducao = "\t"+ var + " = "+ $1.label + ";\n";

				$$.label = var;
			}
			| TK_ID
			{
				string var = addNewVar();

				$$.traducao = "\t"+ var + " = "+ $1.label + ";\n";

				$$.label = var;
			}
			;

%%

#include "lex.yy.c"

int yyparse();

int main( int argc, char* argv[] )
{
	yyparse();

	return 0;
}

void yyerror( string MSG )
{
	cout << MSG << endl;
	exit (0);
}	

std::string to_string(int i)
{
    std::stringstream ss;
    ss << i;
    return ss.str();
}

string addNewVar(){

	return ("var" + to_string(varCount++)); 
}