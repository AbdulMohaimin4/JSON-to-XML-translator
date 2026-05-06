#include <cstdio>
#include "ast.h"
#include "xml_generator.h"

// Defined in parser.y
extern int  yyparse();
extern ASTNode* root;

int main() {
    if (yyparse() != 0)
        return 1;

    printf("<root>");
    generateXML(root);
    printf("</root>\n");

    delete root;
    return 0;
}