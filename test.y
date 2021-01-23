%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#include "sym_table.h"

	void printSymTable(void) ;
	void set_type(int);
	void add_id(int);
	void check_type(int s_id, int i_id);
	
	
%}
//CAB- close angle bracket
//OAB - open angle brscket
//CBO-curly bracket open
//CBC-curly bracket close
//SBC-simple bracket open
//SBO-simple bracket close
//RP-relational operator
//HINCLUDE-hash include
//LIBNAME-library name
//INCOP-increment operator
//DICOP-dicrement operator
//NEQ-Not equalto
//error-verbose function is used to enable debugging for yacc

%token HINCLUDE LIBNAME SEMI CBO CBC SBO SBC COMMA INT MAIN EQ  NUM AMP FOR INCOP PLUS DECOP LE LEQ  GE GEQ NEQ DEQ MINUS CHAR DOUBLE FLOAT PRINTF SCANF

%union
{
	int index;
	int typeval;
}


%token<index> STRING
%token<index> ID
%type<typeval> type

%error-verbose
%{
    void yyerror(const char *);
    int yylex(void);
    int sym[26];
    extern FILE *yyin;
    extern FILE *yyout;
    
%}

%%
start: header  main ;
 	
header: HINCLUDE LE LIBNAME GE ;

main: INT MAIN SBO SBC CBO body CBC;

body: stmt  body 
     | ;
   
stmt: decl SEMI | assgn SEMI |ctrlstmt | pstmt SEMI |sstmt SEMI ;

pstmt: PRINTF SBO STRING COMMA ID SBC {check_type($3, $5);};

sstmt: SCANF SBO STRING COMMA  AMP ID SBC {check_type($3,$6);};

decl : type names {set_type($1);};

type : INT {$$=0;} | FLOAT {$$=1;} | DOUBLE {$$=2;} | CHAR {$$=3;};

names : name COMMA names | name  ;

name : ID  {add_id($1);} | ID EQ NUM {add_id($1);};

assgn : ID EQ NUM | ID EQ ID | ID INCOP |ID DECOP;

ctrlstmt : FOR SBO SEMI SEMI SBC next
		|FOR SBO assgn SEMI relstmt SEMI ID INCOP SBC next
		| FOR SBO assgn SEMI relstmt SEMI ID DECOP SBC next;
		
next:	CBO body CBC
		|body
		;
	
relstmt: ID relop ID| ID relop NUM  ;

relop : LE |LEQ | GE |GEQ |NEQ |EQ |DEQ ;
	
%%



void yyerror(const char *s) 
{
    printf("error:%s\n", s);
    exit(-1);
}

int iDs[1024];
int iDIndex=0;

void add_id(int id)
{
	iDs[iDIndex] = id;
	iDIndex++;
}

extern sym_table table[];

void set_type(int type)
{
	//printf("setting type:%d\n", type);
	int i;
	
	for (i=0; i < iDIndex; i++) {
		table[iDs[i]].type = type;
	}
	iDIndex=0;
}

void check_type(int s_id, int i_id)
{
	//printf("%d %d\n", s_id, i_id);
	if ((table[i_id].type == 0) &&
		(strcmp("\"%d\"", table[s_id].value) != 0)) {
		printf("expecting %%d but got %s at line %d\n", table[s_id].value, table[s_id].line_number);
		exit(-1);
	}
	if ((table[i_id].type == 1) &&
		(strcmp("\"%f\"", table[s_id].value) != 0)) {
		printf("expecting %%f but got %s at line %d\n", table[s_id].value, table[s_id].line_number);
		exit(-1);
	}
	if ((table[i_id].type == 2) &&
		(strcmp("\"%e\"", table[s_id].value) != 0)) {
		printf("expecting %%e but got %s at line %d\n", table[s_id].value, table[s_id].line_number);
		exit(-1);
	}
	if ((table[i_id].type == 3) &&
		(strcmp("\"%s\"", table[s_id].value) != 0)) {
		printf("expecting %%s but got %s at line %d\n", table[s_id].value, table[s_id].line_number);
		exit(-1);
	}
}



int main(void)
 {
 	
	yyin=fopen("input1.c","r");
	yyout=fopen("outcomment.c","w");
	yyparse();
	fclose(yyin);
	fclose(yyout);
	printSymTable();
   //printf("Successfully parsed the given program\n");
    return 0;
}
