#include <cstdio>
#include <cstdlib>
#include "ast.h"
#include "xml_generator.h"

extern int  yyparse();
extern ASTNode* root;
extern FILE* yyin;

int main(int argc, char* argv[]) {
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Error: cannot open file '%s'\n", argv[1]);
            return 1;
        }
    }

    if (yyparse() != 0)
        return 1;

    printf("<root>");
    generateXML(root);
    printf("</root>\n");

    delete root;
    if (yyin && yyin != stdin) fclose(yyin);
    return 0;
}
