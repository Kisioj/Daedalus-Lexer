#include <stdio.h>
#include <string.h>
#include <errno.h>
#include "token_types.h"

extern int yylex();
extern int yylineno;
extern int yycolumnno; // my own
extern int yycharcount; // my own
extern char* yytext;
extern FILE* yyin;


int main(int argc, char * argv[]) 
{

    if (argc == 2) {
        yyin = fopen(argv[1], "rb");
        if (yyin == NULL) {
            fprintf(stderr, "Error: %s", strerror(errno));
            return 1;
        }
    } else {
        printf("%s: fatal error: no input files\n", argv[0]);
        printf("tokens generation terminated\n", argv[0]);
        return 1;
    }

    yycolumnno = 0;
    yycharcount = 0;
    
    int token_type;
    int index = 0;
    char token_name[100];
    int length;
    while (token_type = yylex()) {
        if (token_type == IDENTIFIER) {
            strcpy(token_name, "<IDENTIFIER>");
        } else if (token_type == INTEGER_LITERAL) {
            strcpy(token_name, "<INTEGER_LITERAL>");
        } else if (token_type == FLOAT_LITERAL) {
            strcpy(token_name, "<FLOAT_LITERAL>");
        } else if (token_type == STRING_LITERAL) {
            strcpy(token_name, "<STRING_LITERAL>");
        } else if (token_type == END_OF_FILE) {
            strcpy(token_name, "<EOF>");
        } else {
            strcpy(token_name, "<'");
            strcat(token_name, yytext);
            strcat(token_name, "'>");
        }
        length = strlen(yytext);
        printf("[@%d,%d:%d='%s',%s,%d:%d]\n", index, yycharcount, yycharcount + length-1, yytext, token_name, yylineno, yycolumnno);
        yycharcount += length;
        yycolumnno += length;
        index++;
        
        if (token_type == END_OF_FILE) {
            break;
        }
    }
    
    fclose(yyin);
    return 0;
}