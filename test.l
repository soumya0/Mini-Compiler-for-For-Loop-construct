%{
	#include <stdlib.h>
	#include "y.tab.h"
	#include "sym_table.h"
	#define TYPE_COMMENT 0
	#define TYPE_STRING_CONST 1
	#define TYPE_KEYWORD 2
	#define TYPE_IDENTIFIER 3
	#define TYPE_OPERATOR 4
	#define TYPE_DIGIT 5
	
	
	int installID (int type, char* tmp_yytext);
	    void yyerror(char *);
	    int inDouble = 0;
	    int inComment = 0,inDoublecom=0;
	    int line_number = 1;
	    int sym_table_length = 0;
	    sym_table table[100];
	
%}

und [_]
letter [a-zA-Z]
digitt [0-9]
id {letter}*|({letter}{digitt})+|({letter}{digitt})+|({digitt}{letter})+|({letter}{und}{digitt})+
%%

"#include" { return HINCLUDE;}
stdio.h|stdlib.h return LIBNAME;


; return SEMI;
\{ return CBO;
\} return CBC;
\( return SBO;
\) return SBC;
\&  return AMP;

"int"		{installID(TYPE_KEYWORD, yytext); return INT;}
"float"		{installID(TYPE_KEYWORD, yytext); return FLOAT;}
"double"	{installID(TYPE_KEYWORD, yytext); return DOUBLE;}
"char"		{installID(TYPE_KEYWORD, yytext);return CHAR;}
"for"		{installID(TYPE_KEYWORD, yytext);return FOR;}
"main"		{return MAIN;}
"printf"	{return PRINTF;}
"scanf"		{return SCANF;}
, return COMMA;

[+-]?[0-9]+\.?[0-9]*  {installID(TYPE_DIGIT, yytext);return NUM; }
"++" 			{return INCOP; }
"+"	{return PLUS;}
"--"	{return DECOP;}
"-"	{return MINUS;}
{id}	{ yylval.index = installID(TYPE_IDENTIFIER,yytext); return ID;}
"<"	{ return LE;}
"<="	{ return LEQ; }
">"	{return GE; }
">="	{return GEQ; }
"=="	{return DEQ; }
"="	{return EQ; }

\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/|\/\/.*		{fprintf(yyout,"%s","");}
\t														{fprintf(yyout,"%s",yytext);}
\n														{fprintf(yyout,"%s",yytext);++line_number;}
.														{fprintf(yyout,"%s",yytext);}



\".*\" {yylval.index = installID(TYPE_STRING_CONST, yytext); return STRING; }


%%

char *type_table[] = {"", "STRING_CONSTANT", "KEYWORD", "IDENTIFIER", "OPERATOR", "DIGIT"};

int installID (int type, char* tmp_yytext)
{
	int i=0;
	for(; i < sym_table_length; i++)
		if((strcmp(table[i].name, type_table[type]) == 0) && (strcmp(table[i].value,tmp_yytext)==0))
			return i;
			
	switch (type) {
		case 1:
			strcpy (table[sym_table_length].name, "STRING CONSTANT");		
			strcpy (table[sym_table_length].value, tmp_yytext);
			table[sym_table_length].line_number =line_number;
			break;
		case 2:
			strcpy (table[sym_table_length].name, "KEYWORD");		
			strcpy (table[sym_table_length].value, tmp_yytext);
			table[sym_table_length].line_number = line_number;
			break;
		case 3:
			strcpy (table[sym_table_length].name, "IDENTIFIER");		
			strcpy (table[sym_table_length].value, tmp_yytext);
			table[sym_table_length].line_number = line_number;
			break;
		case 4:
			strcpy (table[sym_table_length].name, "OPERATOR");		
			strcpy (table[sym_table_length].value, tmp_yytext);
			table[sym_table_length].line_number = line_number;
			break;
		case 5:
			strcpy (table[sym_table_length].name, "DIGIT");		
			strcpy (table[sym_table_length].value, tmp_yytext);
			table[sym_table_length].line_number = line_number;
			break;
	}
	int tmp = sym_table_length;
	sym_table_length++;
	return tmp;
}

void printSymTable(void) 
{
    int i =0;
    for (; i < sym_table_length; i++) 
    {	
    	printf("name: %s, value: %s, line_number: %d\n", table[i].name,table[i].value,table[i].line_number);
    }
}
int yywrap(void) {
    return 1;
}


