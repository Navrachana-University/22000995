# 📘 Hindi Language Compiler using Flex and Bison

## 👨‍💻 Developer Info
**Name:** Raj Mistry  
**Enrollment No:** 22000995

---

## 📄 Project Description

This compiler is designed for a **Hindi-based programming language**, built using **Flex (Lex)** and **Bison (Yacc)**.  
It demonstrates how native-language keywords can be used to create an intuitive programming environment for Hindi-speaking learners.

### 🌟 Language Features:
- **Conditional Statements**  
  - `yeh` → `if`  
  - `warna` → `else`
- **Loops**  
  - `while`
- **Output**  
  - `dikhaana` → `print`
- **Arithmetic Operators**  
  - `+`, `-`, `*`, `/`
- **Relational Operators**  
  - `==`, `!=`, `<`, `<=`, `>`, `>=`
- **Assignment**  
  - `=`
- **Grouping**  
  - Parentheses `(` and `)`
- **Statement Terminator**  
  - `;` (semicolon)

This compiler translates valid Hindi-style expressions and control flows into **Three Address Code (TAC)** and then to simple **assembly code**.

---

## 📁 Files Included
`scanner.l`- Lexical analyzer using Hindi keywords (Flex source)

`parser.y` - Syntax parser and TAC generator (Bison source)

`lex.yy.c` - Generated C file from `scanner.l` using Flex

`parser.tab.c` - Generated C file from `parser.y` using Bison
                               
`tac_to_assembly.c` - Converts generated TAC (Three Address Code) to simple assembly

 `tac.txt` - Intermediate file storing Three Address Code (TAC)

`assembly.asm` - Final assembly code generated from TAC 

---

## ⚙️ How to Compile and Run

### 🧾 Step-by-step

```bash
# Step 1: Generate the lexer
flex scanner.l

# Step 2: Generate the parser
bison -d parser.y

# Step 3: Compile everything together
gcc parser.tab.c lex.yy.c -o output.exe

# Step 4: Run the Hindi language compiler
output.exe
