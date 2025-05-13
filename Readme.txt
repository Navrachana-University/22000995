Title of the project:
Hindi Programming Language Compiler using Flex and Bison

Developer Info:
Name: Raj Mistry
Enrollment no: 22000995

Project Description:
This compiler is designed for a Hindi-based programming language, built using Flex (Lex) and Bison (Yacc). 
It demonstrates how native-language keywords can be used to create an intuitive programming environment for Hindi-speaking learners.
This language supports:
Conditional statements using yeh (if) and warna (else)
Loops using while
Output using dikhaana (print)
Arithmetic operations: +, -, *, /
Relational operators: ==, !=, <, <=, >, >=
Assignment using =
Grouping with parentheses ( and )
End of statement marked by ;

The compiler generates Three Address Code (TAC) for valid Hindi-style expressions and control flows.

Files included:
scanner.l – Lexical analyzer using Hindi keywords and common operators.
parser.y – Bison grammar for parsing tokens and generating TAC.
README.txt – Project information and execution instructions.

Required commands to execute it:
flex scanner.l
bison -d parser.y
gcc parser.tab.c lex.yy.c -o mycompiler.exe
mycompiler.exe