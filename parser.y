%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tempCount = 0;
char tac[1000][100];
int tacIndex = 0;
int tempValues[1000];

int yylex(void);
void yyerror(const char *s);

char* newTemp() {
    static char temp[10];
    sprintf(temp, "t%d", tempCount++);
    return strdup(temp);
}
%}

%union {
    int num;
    char* str;
}

%token DIKHANA IF ELSE
%token WHILE
%token <num> NUMBER
%token <str> ID
%token EQ NE LE GE LT GT ASSIGN
%token PLUS MINUS MUL DIV
%token LPAREN RPAREN
%token SEMICOLON

%left PLUS MINUS
%left MUL DIV

%type <str> expr

%%  // Start of grammar rules

program:
    program statement '\n'
    | program statement
    | statement '\n'
    | statement
    ;

%nonassoc IFX;
%nonassoc ELSE;

statement:
    DIKHANA expr SEMICOLON  { 
        int finalValue = tempValues[tempCount - 1];
        printf("Output: %d\n", finalValue); 
    }
    | IF expr statement %prec IFX  { printf("IF condition true: %s\n", $2); }
    | IF expr statement ELSE statement  { printf("IF-ELSE executed with %s\n", $2); }
    | WHILE expr statement {
        char startLabel[10], endLabel[10];
        sprintf(startLabel, "L%d", tacIndex);
        sprintf(endLabel, "L%d", tacIndex + 1);

        sprintf(tac[tacIndex++], "%s:", startLabel);                     // Start label
        sprintf(tac[tacIndex++], "ifFalse %s goto %s", $2, endLabel);    // Check condition
        // $3 is the body, already parsed
        sprintf(tac[tacIndex++], "goto %s", startLabel);                 // Jump back to start
        sprintf(tac[tacIndex++], "%s:", endLabel);                       // End label

        printf("TAC: while loop generated\n");
    }
    ;

expr:
    NUMBER  {
        char* t = newTemp();
        sprintf(tac[tacIndex++], "%s = %d", t, $1);
        printf("TAC: %s\n", tac[tacIndex - 1]); // Debug print
        tempValues[tempCount - 1] = $1;
        $$ = t;
    }
    | expr PLUS expr  {
        char* t = newTemp();
        int idx1 = atoi($1 + 1);
        int idx2 = atoi($3 + 1);
        int result = tempValues[idx1] + tempValues[idx2];
        sprintf(tac[tacIndex++], "%s = %s + %s", t, $1, $3);
        printf("TAC: %s\n", tac[tacIndex - 1]); // Debug print
        tempValues[tempCount - 1] = result;
        $$ = t;
    }
    | expr MINUS expr  {
        char* t = newTemp();
        int idx1 = atoi($1 + 1);
        int idx2 = atoi($3 + 1);
        int result = tempValues[idx1] - tempValues[idx2];
        sprintf(tac[tacIndex++], "%s = %s - %s", t, $1, $3);
        printf("TAC: %s\n", tac[tacIndex - 1]); // Debug print
        tempValues[tempCount - 1] = result;
        $$ = t;
    }
    | expr MUL expr  {
        char* t = newTemp();
        int idx1 = atoi($1 + 1);
        int idx2 = atoi($3 + 1);
        int result = tempValues[idx1] * tempValues[idx2];
        sprintf(tac[tacIndex++], "%s = %s * %s", t, $1, $3);
        printf("TAC: %s\n", tac[tacIndex - 1]); // Debug print
        tempValues[tempCount - 1] = result;
        $$ = t;
    }
    | expr DIV expr  {
        char* t = newTemp();
        int idx1 = atoi($1 + 1);
        int idx2 = atoi($3 + 1);
        int result = tempValues[idx1] / tempValues[idx2];
        sprintf(tac[tacIndex++], "%s = %s / %s", t, $1, $3);
        printf("TAC: %s\n", tac[tacIndex - 1]); // Debug print
        tempValues[tempCount - 1] = result;
        $$ = t;
    }
    | LPAREN expr RPAREN  { $$ = $2; }
    ;

%%  // Start of user C code

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter your code (e.g., yeh 2-2 dikhana 0; warna dikhana 1;):\n");
    yyparse();

    printf("tacIndex after parsing: %d\n", tacIndex); // Debug print

    printf("\n--- Three Address Code (TAC) ---\n");
    FILE *tacFile = fopen("tac.txt", "w");
    for (int i = 0; i < tacIndex; i++) {
        printf("%s\n", tac[i]);
        fprintf(tacFile, "%s\n", tac[i]);
    }
    fclose(tacFile);
    printf("TAC written to tac.txt\n");

    // --- Assembly Code Generation ---
    FILE *asmFile = fopen("assembly.asm", "w");
    fprintf(asmFile, "------ Assembly Code ------\n\n");
    
    for (int i = 0; i < tacIndex; i++) {
        char dest[10], src1[10], op[3], src2[10];
        int matched = sscanf(tac[i], "%s = %s %s %s", dest, src1, op, src2);

        if (matched == 2) {
            // e.g., t0 = 2
            fprintf(asmFile, "; %s\n", tac[i]);
            fprintf(asmFile, "MOV [%s], %s\n\n", dest, src1);
        } else if (matched == 4) {
            fprintf(asmFile, "; %s\n", tac[i]);
            if (strcmp(op, "+") == 0) {
                fprintf(asmFile, "MOV AX, [%s]\n", src1);
                fprintf(asmFile, "ADD AX, [%s]\n", src2);
                fprintf(asmFile, "MOV [%s], AX\n\n", dest);
            } else if (strcmp(op, "-") == 0) {
                fprintf(asmFile, "MOV AX, [%s]\n", src1);
                fprintf(asmFile, "SUB AX, [%s]\n", src2);
                fprintf(asmFile, "MOV [%s], AX\n\n", dest);
            } else if (strcmp(op, "*") == 0) {
                fprintf(asmFile, "MOV AX, [%s]\n", src1);
                fprintf(asmFile, "MUL [%s]\n", src2);
                fprintf(asmFile, "MOV [%s], AX\n\n", dest);
            } else if (strcmp(op, "/") == 0) {
                fprintf(asmFile, "MOV AX, [%s]\n", src1);
                fprintf(asmFile, "MOV BX, [%s]\n", src2);
                fprintf(asmFile, "DIV BX\n");
                fprintf(asmFile, "MOV [%s], AX\n\n", dest);
            }
        }
    }

    fclose(asmFile);
    printf("Assembly written to assembly.asm\n");

    return 0;
}
