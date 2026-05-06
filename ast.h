#ifndef AST_H
#define AST_H

#include <string>
#include <vector>

enum NodeType {
    NODE_OBJECT,
    NODE_ARRAY,
    NODE_PAIR,
    NODE_STRING,
    NODE_NUMBER,
    NODE_BOOL,
    NODE_NULL
};

struct ASTNode {
    NodeType type;
    std::string value;              // key for PAIR; text content for STRING/NUMBER/BOOL
    std::vector<ASTNode*> children;

    ASTNode(NodeType t, const std::string& v = "");
    ~ASTNode();
    void addChild(ASTNode* child);
};

#endif