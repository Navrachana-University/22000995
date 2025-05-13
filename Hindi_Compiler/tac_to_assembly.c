#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char tac[1000][100];
int tacCount = 0;

void loadTAC(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Failed to open TAC file");
        exit(1);
    }
    while (fgets(tac[tacCount], sizeof(tac[tacCount]), file)) {
        tac[tacCount][strcspn(tac[tacCount], "\n")] = '\0';  // remove newline
        tacCount++;
    }
    fclose(file);
}

void generateAssembly(char tac[][100], int count) {
    printf("\n------ Assembly Code ------\n\n");
    for (int i = 0; i < count; i++) {
        char left[10], op1[10], op[3], op2[10];
        int matched = sscanf(tac[i], "%s = %s %s %s", left, op1, op, op2);
        if (matched == 4) {
            printf("; %s\n", tac[i]);
            printf("MOV AX, [%s]\n", op1);
            if (strcmp(op, "+") == 0)
                printf("ADD AX, [%s]\n", op2);
            else if (strcmp(op, "-") == 0)
                printf("SUB AX, [%s]\n", op2);
            else if (strcmp(op, "*") == 0)
                printf("MUL [%s]\n", op2);
            else if (strcmp(op, "/") == 0)
                printf("DIV [%s]\n", op2);
            printf("MOV [%s], AX\n\n", left);
        } else {
            int value;
            matched = sscanf(tac[i], "%s = %d", left, &value);
            if (matched == 2) {
                printf("; %s\n", tac[i]);
                printf("MOV [%s], %d\n\n", left, value);
            }
        }
    }
}

int main() {
    loadTAC("tac.txt");
    generateAssembly(tac, tacCount);
    return 0;
}
