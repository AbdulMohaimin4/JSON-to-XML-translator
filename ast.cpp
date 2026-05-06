#include "ast.h"

ASTNode::ASTNode(NodeType t, const std::string& v)
    : type(t), value(v) {}

ASTNode::~ASTNode() {
    for (ASTNode* child : children)
        delete child;
}

void ASTNode::addChild(ASTNode* child) {
    children.push_back(child);
}