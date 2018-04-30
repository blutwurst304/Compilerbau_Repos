%{

/*In Bison File kommen Verweise auf Tokens bzw. Terminalsymbole und Regelsätze für Formeln*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

extern int yyerror(char* err);
extern int yylex(void);
extern FILE *yyin;
extern char* yytext;


char* indent;

void increaseIndent(){
	sprintf(indent, "%s%s", indent, "|  ");
}

void decreaseIndent(){
	if(strlen(indent)>2){
		indent[strlen(indent)-3] = 0;
	}
}

typedef struct formel formel;
typedef struct atom atom;
typedef struct term term;
typedef struct termfolge termfolge;

void printTerm(term*);
void printAtom(atom*);
void printFormel(formel*);
void printTermfolge(termfolge*);

atom* deepCopyAtom(atom*);
term* deepCopyTerm(term*);
formel* deepCopyFormel(formel*);
termfolge* deepCopyTermfolge(termfolge*);

formel* root; 	

struct formel{
	char* type;
	char* text;
	formel* subFormelA;
	formel* subFormelB;
	atom* atom;
};

struct atom {
	char* text;
	termfolge* parameter;
};

struct term{
	char* text;
	char* type;
	termfolge* parameter;
};

struct termfolge{
	term* term;
	termfolge* next;
};

term* createTerm(char* type, char* text, termfolge* params){
	printf("creating Term\n");
	term* tPtr = (term*)malloc(sizeof(term));
	if(text != (char*)0) tPtr->text = (char*)malloc(strlen(text));
	if(type != (char*)0) tPtr->type = (char*)malloc(strlen(type));
	tPtr->text = text;
	tPtr->type = type;
	tPtr->parameter = params;
	return tPtr;
}

term* deepCopyTerm(term* t){
	term* tPtr = (term*)malloc(sizeof(term));
	if(t->text != (char*)0){
		tPtr->text = (char*)malloc(strlen(t->text));
		strcpy(tPtr->text, t->text);
	}
	if(t->type != (char*)0){
		tPtr->type = (char*)malloc(strlen(t->type));
		strcpy(tPtr->type, t->type);
	}
	if(t->parameter != (termfolge*)0){
		tPtr->parameter = deepCopyTermfolge(t->parameter);
	}
	return tPtr;
}

void printTerm(term* t){
	//printf("%sTerm %s, type %s\n", indent, t->text, t->type);
	printf("%s%s\n", indent, t->text);
	if(t->parameter != (termfolge*)0) {
		increaseIndent();
		printTermfolge(t->parameter);
		decreaseIndent();
	}
	
}

atom* createAtom(char* text, termfolge* params){
	printf("creating Atom\n");
	atom* aPtr = (atom*)malloc(sizeof(atom));
	if(text != (char*)0) aPtr->text = (char*)malloc(strlen(text));
	aPtr->text = text;
	aPtr->parameter = params;
	return aPtr;
}

atom* deepCopyAtom(atom* a){
	atom* aPtr = (atom*)malloc(sizeof(atom));
	if(a->text != (char*)0){
		aPtr->text = (char*)malloc(strlen(a->text));
		strcpy(aPtr->text, a->text);
	}
	if(a->parameter != (termfolge*)0){
		aPtr->parameter = deepCopyTermfolge(a->parameter);
	}
	return aPtr;
}

void printAtom(atom* a){
	//printf("%sAtom %s\n", indent, a->text);
	printf("%s%s\n", indent, a->text);
	if(a->parameter != (termfolge*)0) 
	{
		increaseIndent();
		printTermfolge(a->parameter);
		decreaseIndent();
	}
}

termfolge* createTermfolge(term* term, termfolge* next){
	printf("creating Ternfolge\n");
	termfolge* tfPtr = (termfolge*)malloc(sizeof(termfolge));
	tfPtr->term = term;
	tfPtr->next = next;
	return tfPtr;
}

termfolge* deepCopyTermfolge(termfolge* tf){
	termfolge* tfPtr = (termfolge*)malloc(sizeof(termfolge));
	if(tf->term != (term*)0){
		tfPtr->term = deepCopyTerm(tf->term);
	}
	if(tf->next != (termfolge*)0){
		tfPtr->next = deepCopyTermfolge(tf->next);
	}
	return tfPtr;
}

void printTermfolge(termfolge* tf){
	if(tf->term != (term*)0) printTerm(tf->term);
	if(tf->next != (termfolge*)0) printTermfolge(tf->next);
}

formel* createFormel(char* type, char* text, formel* subA, formel* subB, atom* at){
	printf("creating Formel\n");
	formel* fPtr = (formel*)malloc(sizeof(formel));
	if(type != (char*)0) fPtr->type = (char*)malloc(strlen(type));
	if(text != (char*)0) fPtr->text = (char*)malloc(strlen(text));
	fPtr->type = type;
	fPtr->text = text;
	fPtr->subFormelA = subA;
	fPtr->subFormelB = subB;
	fPtr->atom = at;
	return fPtr;
}

formel* deepCopyFormel(formel* f){
	formel* fPtr = (formel*)malloc(sizeof(formel));
	if(f->type != (char*)0){
		fPtr->type = (char*)malloc(strlen(f->type));
		strcpy(fPtr->type, f->type);
	}
	if(f->text != (char*)0){
		fPtr->text = (char*)malloc(strlen(f->text));
		strcpy(fPtr->text, f->text);
	}
	if(f->atom != (atom*)0){
		fPtr->atom = deepCopyAtom(f->atom);
		return fPtr;
	}
	if(f->subFormelA != (formel*)0){
		fPtr->subFormelA = deepCopyFormel(f->subFormelA);
	}
	if(f->subFormelB != (formel*)0){
		fPtr->subFormelB = deepCopyFormel(f->subFormelB);
	}
	return fPtr;
}

void printFormel(formel* f){
	//printf("%sFormel %s, type %s\n", indent, f->text, f->type);
	if(f->atom != (atom*)0){
		printAtom(f->atom);
		return;
	}
	printf("%s%s", indent, f->type);
	if(strcmp(f->type, "EX") == 0 || strcmp(f->type, "ALL") == 0){
		printf(" %s\n", f->text);
	}
	else{
		printf("\n");
	}
	if(f->subFormelA != (formel*)0 && f->subFormelB != (formel*)0){
		increaseIndent();
		printFormel(f->subFormelA);
		printFormel(f->subFormelB);
		decreaseIndent();
		return;
	}
	if(f->subFormelA != (formel*)0){
		increaseIndent();
		printFormel(f->subFormelA);
		decreaseIndent();
	}
}


void replaceImp(formel* f){
	if(f->type[0] == 'I'){
		f->subFormelA = createFormel("NEG", (char*)0, f->subFormelA, (formel*)0, (atom*)0);
		//free(f->type);
		//f->type = (char*)malloc(5);
		f->type = "ODER";
	}
	if(f->subFormelA != (formel*)0){
		replaceImp(f->subFormelA);
	}
	if(f->subFormelB != (formel*)0){
		replaceImp(f->subFormelB);
	}
}

void replaceAeq(formel* f){
	if(strcmp(f->type, "AEQ") == 0){
		formel* subA = createFormel("NEG", (char*)0, deepCopyFormel(f->subFormelA), (formel*)0, (atom*)0);
		formel* subB = createFormel("NEG", (char*)0, deepCopyFormel(f->subFormelB), (formel*)0, (atom*)0);
		formel* left = createFormel("UND", (char*)0, f->subFormelA, f->subFormelB, (atom*)0);
		formel* right = createFormel("UND", (char*)0, subA, subB, (atom*)0);
		f->subFormelA = left;
		f->subFormelB = right;
		f->type = "ODER";
	}
	if(f->subFormelA != (formel*)0){
		replaceAeq(f->subFormelA);
	}
	if(f->subFormelB != (formel*)0){
		replaceAeq(f->subFormelB);
	}
}

int deMorgan(formel* f){
	//printf("traversing %s\n", f->type);
	//printFormel(f);
	int changed = 0;
	if(strcmp(f->type, "NEG") == 0){
		if(strcmp(f->subFormelA->type, "UND")==0){
			//DeMorgan 1
			printf("Applying deMorgan 1\n");
			printFormel(f);
			f->type = "ODER";
			f->subFormelB = createFormel("NEG", (char*)0, f->subFormelA->subFormelB, (formel*)0, (atom*)0);
			f->subFormelA = createFormel("NEG", (char*)0, f->subFormelA->subFormelA, (formel*)0, (atom*)0);
			printf("Result:\n");
			printFormel(f);
			changed = 1;
		}
		else if(strcmp(f->subFormelA->type, "ODER")==0){
			//DeMorgan 2
			printf("Applying deMorgan 2\n");
			printFormel(f);
			f->type = "UND";
			f->subFormelB = createFormel("NEG", (char*)0, f->subFormelA->subFormelB, (formel*)0, (atom*)0);
			f->subFormelA = createFormel("NEG", (char*)0, f->subFormelA->subFormelA, (formel*)0, (atom*)0);
			printf("Result:\n");
			printFormel(f);
			changed = 1;
		}
		else if(strcmp(f->subFormelA->type, "ALL") == 0){
			//DeMorgan 3
			printf("Applying deMorgan 3\n");
			printFormel(f);
			f->type = "EX";
			f->text = f->subFormelA->text;
			f->subFormelA->type = "NEG";
			printf("Result:\n");
			printFormel(f);
			changed = 1;
		}
		else if(strcmp(f->subFormelA->type, "EX") == 0){
			//DeMorgan 4
			printf("Applying deMorgan 4\n");
			printFormel(f);
			f->type = "ALL";
			f->text = f->subFormelA->text;
			f->subFormelA->type = "NEG";
			printf("Result:\n");
			printFormel(f);
			changed = 1;
		}
	}
	if(f->subFormelA != (formel*)0){
		if(deMorgan(f->subFormelA) == 1) changed = 1;
	}
	if(f->subFormelB != (formel*)0) {
		if(deMorgan(f->subFormelB) == 1) changed = 1;
	}
	//if(changed) printf("returned Successfully\n");
	return changed;
}

formel* removeDoubleNegation(formel* f){
	if(f->subFormelA != (formel*)0){
		f->subFormelA = removeDoubleNegation(f->subFormelA);
	}
	if(f->subFormelB != (formel*)0){
		f->subFormelB = removeDoubleNegation(f->subFormelB);
	}
	
	if(strcmp(f->type, "NEG")==0){
		if(strcmp(f->subFormelA->type, "NEG") == 0){
			return f->subFormelA->subFormelA;
		}
	}
	return f;
}

void invertTB(formel* f){
	if(strcmp(f->type, "NEG") == 0){
		if(strcmp(f->subFormelA->type, "TOP") == 0){
			f->type = "BOTTOM";
			f->subFormelA = (formel*)0;
		}
		else if(strcmp(f->subFormelA->type, "BOTTOM") == 0){
			f->type = "TOP";
			f->subFormelA = (formel*)0;
		}
	}
	if(f->subFormelA != (formel*)0){
		invertTB(f->subFormelA);
	}
	if(f->subFormelB != (formel*)0) {
		invertTB(f->subFormelB);
	}
}

%}


%union {
	struct formel* f;
	struct atom* a;
	struct term* t;
	struct termfolge* tf;
	char* str;
}

%start formel

%token BOTTOM
%token TOP
%token KOMMA

%left AEQ
%left IMP
%left ODER
%left UND
%right NEG
%right ALL
%right EX
%right AUF
%left ZU
%right PRAEDIKAT
%right FUNKTIONSSYMBOL
%right VARIABLE

%%
termfolge: 
	term KOMMA termfolge {printf("Reduziere zu Termfolge\n"); $<tf>$=createTermfolge($<t>1, $<tf>3);}
 	| term {printf("Reduziere zu Termfolge\n"); $<tf>$=createTermfolge($<t>1, (termfolge*)0);};

term:
	//VARIABLE
	VARIABLE {printf("Reduziere zu Term\n");$<t>$=createTerm("VARIABLE", $<str>1, (termfolge*)0);}
	//FUNKTION
	|FUNKTIONSSYMBOL {printf("Reduziere zu Term\n");$<t>$=createTerm("FUNKTION", $<str>1, (termfolge*)0);}
	|FUNKTIONSSYMBOL AUF termfolge ZU {printf("Reduziere zu Term\n");$<t>$=createTerm("FUNKTION", $<str>1, $<tf>3);};

atom: 
	PRAEDIKAT {printf("Reduziere zu Atom\n"); $<a>$=createAtom($<str>1, (termfolge*)0);}
	|PRAEDIKAT AUF termfolge ZU {printf("Reduziere zu Atom\n"); $<a>$=createAtom($<str>1, $<tf>3);};

formel: 
	//NEG
	NEG formel {printf("Reduziere zu Formel\n"); $<f>$=createFormel("NEG", (char*)0, $<f>2, (formel*)0, (atom*)0); root = $<f>$;}
	//EX
	| EX VARIABLE formel {printf("Reduziere zu Formel\n");$<f>$=createFormel("EX", $<str>2, $<f>3, (formel*)0, (atom*)0); root = $<f>$;}
	//ALL
	| ALL VARIABLE formel {printf("Reduziere zu Formel\n");$<f>$=createFormel("ALL", $<str>2, $<f>3, (formel*)0, (atom*)0); root = $<f>$;}
	//KLAMMER
	| AUF formel ZU {printf("Reduziere zu Formel\n");$<f>$=$<f>2; root = $<f>$;}
	//TOP
	| TOP {printf("Reduziere zu Formel\n");$<f>$=createFormel("TOP", (char*)0, (formel*)0, (formel*)0, (atom*)0); root = $<f>$;}
	//BOTTOM
	| BOTTOM {printf("Reduziere zu Formel\n");$<f>$=createFormel("BOTTOM", (char*)0, (formel*)0, (formel*)0, (atom*)0); root = $<f>$;}
	//UND
	| formel UND formel {printf("Reduziere zu Formel\n"); $<f>$=createFormel("UND", (char*)0, $<f>1, $<f>3, (atom*)0); root = $<f>$;}
	//ODER
	| formel ODER formel {printf("Reduziere zu Formel\n");$<f>$=createFormel("ODER", (char*)0, $<f>1, $<f>3, (atom*)0); root = $<f>$;}
	//AEQ
	| formel AEQ formel {printf("Reduziere zu Formel\n");$<f>$=createFormel("AEQ", (char*)0, $<f>1, $<f>3, (atom*)0); root = $<f>$;}
	//IMP
	| formel IMP formel {printf("Reduziere zu Formel\n");$<f>$=createFormel("IMP", (char*)0, $<f>1, $<f>3, (atom*)0); root = $<f>$;}
	//ATOM
	| atom{printf("Reduziere zu Formel\n");$<f>$=createFormel("ATOM", (char*)0, (formel*)0, (formel*)0, $<a>1); root = $<f>$;};
%%

int yyerror(char* err)
{
	printf("Error: %s\n", err);
	return 0;
}

int main(int argc,char** argv)
{
	indent = (char*)malloc(512);
	indent[0] = 0;
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
            yyin = fopen( argv[0], "r" );
    else
            yyin = stdin;
    
    //yylex();
    yyparse();
	puts("Printing Original: ");
	printFormel(root);
	replaceImp(root);
	replaceAeq(root);
	for(int i = 0; i<1; i++){
		if(deMorgan(root) == 0) break;
	}
	root = removeDoubleNegation(root);
	invertTB(root);
	puts("\nPrinting NNF: ");
	printFormel(root);
    return 0;
}













