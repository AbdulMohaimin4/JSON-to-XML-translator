%{
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include "ast.h"
#include "xml_generator.h"

extern int yylex();
void yyerror(const char* msg);

ASTNode* root = nullptr;
%}

%union {
    char*    str;
    ASTNode* node;
}

%token LBRACE RBRACE LBRACKET RBRACKET COLON COMMA
%token TRUE_TOK FALSE_TOK NULL_TOK
%token <str>  STRING NUMBER

%type <node> value object array pair pair_list item_list

%%

json
    : value { root = $1; }
    ;

value
    : object  { $$ = $1; }
    | array   { $$ = $1; }
    | STRING  {
        std::string s($1);
        free($1);
        // strip surrounding quotes
        std::string content = s.substr(1, s.size() - 2);
        $$ = new ASTNode(NODE_STRING, content);
    }
    | NUMBER  {
        std::string s($1);
        free($1);
        $$ = new ASTNode(NODE_NUMBER, s);
    }
    | TRUE_TOK  { $$ = new ASTNode(NODE_BOOL, "true");  }
    | FALSE_TOK { $$ = new ASTNode(NODE_BOOL, "false"); }
    | NULL_TOK  { $$ = new ASTNode(NODE_NULL);          }
    ;

object
    : LBRACE RBRACE           { $$ = new ASTNode(NODE_OBJECT); }
    | LBRACE pair_list RBRACE { $$ = $2; }
    ;

pair_list
    : pair {
        ASTNode* obj = new ASTNode(NODE_OBJECT);
        obj->addChild($1);
        $$ = obj;
    }
    | pair_list COMMA pair {
        $1->addChild($3);
        $$ = $1;
    }
    ;

pair
    : STRING COLON value {
        std::string s($1);
        free($1);
        // strip surrounding quotes
        std::string key = s.substr(1, s.size() - 2);
        ASTNode* p = new ASTNode(NODE_PAIR, key);
        p->addChild($3);
        $$ = p;
    }
    ;

array
    : LBRACKET RBRACKET            { $$ = new ASTNode(NODE_ARRAY); }
    | LBRACKET item_list RBRACKET  { $$ = $2; }
    ;

item_list
    : value {
        ASTNode* arr = new ASTNode(NODE_ARRAY);
        arr->addChild($1);
        $$ = arr;
    }
    | item_list COMMA value {
        $1->addChild($3);
        $$ = $1;
    }
    ;

%%

void yyerror(const char* msg) {
    fprintf(stderr, "Error: unexpected token\n");
    exit(1);
}
