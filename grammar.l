/* %option noyywrap */
%option yylineno

%{
#include "token_types.h"

int yycolumnno;
int yycharcount;

%}

%%
"const"                 return CONST;
"var"                   return VAR;
"if"                    return IF;
"int"                   return INT;
"else"                  return ELSE;
"func"                  return FUNC;
"string"                return STRING;
"class"                 return CLASS;
"void"                  return VOID;
"return"                return RETURN;
"float"                 return FLOAT;
"prototype"             return PROTOTYPE;
"instance"              return INSTANCE;
"null"                  return TOKEN_NULL;


[a-zA-Z_][a-zA-Z0-9_]*  return IDENTIFIER;
[0-9]+                  return INTEGER_LITERAL;


[0-9]+\. |
[0-9]*\.[0-9]+ |
[0-9]+[eE][+-]?[0-9]+ |
[0-9]*\.[0-9]+[eE][+-]?[0-9]+ |
[0-9]+\.[eE][+-]?[0-9]+         return FLOAT_LITERAL; 

\"[^"\r\n]*\"                   return STRING_LITERAL;

[ \t]                           {
                                    yycharcount += yyleng;
                                    yycolumnno += yyleng;
                                    // return WHITESPACE;
                                };
\r\n?|\n                        {
                                    yycharcount += yyleng;
                                    yycolumnno = 0;
                                    // return NEWLINE;
                                };
\/\*([^*]+|\*[^/])+\*\/         {
                                    yycharcount += yyleng;
                                    int last_newline_index = -1;
                                    for(int i=0; i<yyleng; i++) {
                                        if(yytext[i] == '\n' || yytext[i] == '\r') {
                                            last_newline_index = i;
                                        }
                                    }
                                    if (last_newline_index == -1) {
                                        yycolumnno += yyleng;
                                    } else {
                                        yycolumnno = yyleng - (last_newline_index + 1);
                                    }
                                    // return BLOCK_COMMENT;
                                }
\/\/[^\r\n]*                    {
                                    yycharcount += yyleng;
                                    // yycolumnno += yyleng; // no need
                                    // return LINE_COMMENT;
                                }

"."                             return DOT;
","                             return COMMA;
";"                             return SEMI_COLON;
"{"                             return OPEN_BRACE;
"}"                             return CLOSE_BRACE;
"("                             return OPEN_PAREN;
")"                             return CLOSE_PAREN;
"["                             return OPEN_BRACK;
"]"                             return CLOSE_BRACK;

"="                             return ASSIGN;
"+="                            return ADD_ASSIGN;
"-="                            return SUB_ASSIGN;
"*="                            return MULT_ASSIGN;
"/="                            return DIV_ASSIGN;

"+"                             return PLUS;
"-"                             return MINUS;

"<<"                            return LEFT_SHIFT;
">>"                            return RIGHT_SHIFT;

"<"                             return LESS_THAN;
">"                             return GREATER_THAN;
"<="                            return LT_EQ;
">="                            return GT_EQ;

"=="                            return EQ;
"!="                            return NOT_EQ;

"!"                             return NEG;
"~"                             return BIN_NEG;

"*"                             return MULT;
"/"                             return DIV;
"%"                             return MOD;

"&"                             return BIN_AND;
"|"                             return BIN_OR;
"&&"                            return LOG_AND;
"||"                            return LOG_OR;

<<EOF>>                         return END_OF_FILE;

.                       printf("Unexpected character: %s\n", yytext);
%%

/*
C:\Users\kisio\Desktop\Yacc Project\output
λ flex.exe ..\grammar.l & gcc lex.yy.c & a.exe

flex.exe ..\grammar.l & gcc daedalus_scanner.c lex.yy.c & a.exe
*/
/*
int main(void) {
    yylex();
    return 0;
}
*/

int yywrap(void)
{
    return 1;
}

