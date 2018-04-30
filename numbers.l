  /* Find and add all integers and floats... */
/*In Flex File werden nur Tokens bzw. Terminalsymbole aufgeführt */
%option noyywrap

%{
#include "numbers.tab.h"  

%}

VARIABLE [n-z][0-9]*

FUNKTIONSSYMBOL [a-m][0-9]*

PRAEDIKAT [A-Z][0-9]*

UND &

ODER \|

NEG ~

IMP \->

AEQ <\->

ALL all

EX ex

TOP top

BOTTOM bottom

AUF \(

ZU \)

KOMMA ,

%%


{FUNKTIONSSYMBOL} {
	printf("Funktionssymbol: %s\n", yytext);
	yylval.str = strdup(yytext);	
	return FUNKTIONSSYMBOL;
}
{VARIABLE} {
	printf("Variable: %s\n", yytext);
	yylval.str = strdup(yytext);
	return VARIABLE;
}
{PRAEDIKAT} {
	printf("Praedikat: %s\n", yytext);
	yylval.str = strdup(yytext);
	return PRAEDIKAT;
}
{UND} {
	printf("Und: %s\n", yytext);
	yylval.str = strdup(yytext);
	return UND;
}
{ODER} {
	printf("Oder: %s\n", yytext);
	yylval.str = strdup(yytext);	
	return ODER;
}
{NEG} {
	printf("Negation: %s\n", yytext);
	yylval.str = strdup(yytext);
	return NEG;
}
{IMP} {
	printf("Implikation: %s\n", yytext);
	yylval.str = strdup(yytext);
	return IMP;
}
{AEQ} {
	printf("Aequivalenz: %s\n", yytext);
	yylval.str = strdup(yytext);	
	return AEQ;
}
{ALL} {
	printf("All-Quantor: %s\n", yytext);
	yylval.str = strdup(yytext);
	return ALL;
}
{EX} {
	printf("Existenz-Quantor: %s\n", yytext);
	yylval.str = strdup(yytext);	
	return EX;
}
{TOP} {
	printf("Top: %s\n", yytext);
	yylval.str = strdup(yytext);	
	return TOP;
}
{BOTTOM} {
	printf("Bottom: %s\n", yytext);
	yylval.str = strdup(yytext);
	return BOTTOM;
}
{AUF} {
	printf("Klammer auf: %s\n", yytext);
	yylval.str = strdup(yytext);
	return AUF;
}
{ZU} {
	printf("Klammer zu: %s\n", yytext);
	yylval.str = strdup(yytext);
	return ZU;
}
{KOMMA} {
	printf("Komma: %s\n", yytext);
	yylval.str = strdup(yytext);
	return KOMMA;
}

\n|. { 
        /* Skip */
      }
%%



