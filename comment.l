%{
		#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>

	
%}
%%

\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/|\/\/.*		{fprintf(yyout,"%s","");}
\t														{fprintf(yyout,"%s",yytext);}
\n														{fprintf(yyout,"%s",yytext);}
.														{fprintf(yyout,"%s",yytext);}

%%

int yywrap(void) {
    return 1;
}

int main(void)
 {
 	
	yyin=fopen("input1.c","r");
	yyout=fopen("outcomment.c","w");
	yylex();
	fclose(yyin);
	fclose(yyout);

     return 0;
}
