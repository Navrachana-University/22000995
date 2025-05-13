%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
%}

%%
"dikhana"        { return DIKHANA; }
"yeh"            { return IF; }
"warna"          { return ELSE; }
"while"          { return WHILE; }
[0-9]+           { yylval.num = atoi(yytext); return NUMBER; }
[ \t]+           ;        // Ignore spaces and tabs
\n               { return '\n'; }  // Send newline to parser
"=="             { return EQ; }
"!="             { return NE; }
"<="             { return LE; }
">="             { return GE; }
"<"              { return LT; }
">"              { return GT; }
"="              { return ASSIGN; }
"+"              { return PLUS; }
"-"              { return MINUS; }
"*"              { return MUL; }
";"              { return SEMICOLON; }
"/"              { return DIV; }
"("              { return LPAREN; }
")"              { return RPAREN; }
.                { return yytext[0]; }
<<EOF>>         { return 0; } // Signal end of input
%%

int yywrap() {
    return 1;
}
