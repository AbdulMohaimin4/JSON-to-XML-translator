%{
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include "ast.h"
#include "parser.tab.h"
%}

%option noyywrap

%%

"{"         { return LBRACE;    }
"}"         { return RBRACE;    }
"["         { return LBRACKET;  }
"]"         { return RBRACKET;  }
":"         { return COLON;     }
","         { return COMMA;     }
"true"      { return TRUE_TOK;  }
"false"     { return FALSE_TOK; }
"null"      { return NULL_TOK;  }

\"([^\"\\]|\\[\"\\nt])*\"  {
    /* Validate escape sequences and copy matched string token */
    yylval.str = strdup(yytext);
    return STRING;
}

-?[0-9]+(\.[0-9]+)?  {
    yylval.str = strdup(yytext);
    return NUMBER;
}

[ \t\r\n]+  { /* silently ignore whitespace */ }

\"[^\"]*    {
    fprintf(stderr, "Error: unterminated string\n");
    exit(1);
}

.           {
    fprintf(stderr, "Error: unexpected character '%s'\n", yytext);
    exit(1);
}

%%
