#ifndef XML_GENERATOR_H
#define XML_GENERATOR_H

#include "ast.h"
#include <string>

void generateXML(ASTNode* node, const std::string& tag = "");

#endif