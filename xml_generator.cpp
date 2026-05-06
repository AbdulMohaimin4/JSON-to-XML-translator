#include "xml_generator.h"
#include <iostream>
#include <string>

static std::string escapeXML(const std::string& s) {
    std::string out;
    out.reserve(s.size());
    for (char c : s) {
        switch (c) {
            case '&': out += "&amp;";  break;
            case '<': out += "&lt;";   break;
            case '>': out += "&gt;";   break;
            default:  out += c;        break;
        }
    }
    return out;
}

// Forward declaration for recursion
static void emitValue(ASTNode* node, const std::string& tag);

// Emit a scalar/object/array wrapped in <tag>...</tag>
static void emitValue(ASTNode* node, const std::string& tag) {
    switch (node->type) {

        case NODE_OBJECT:
            // Object: open tag (if any), emit each pair as a child, close tag
            if (!tag.empty()) printf("<%s>", tag.c_str());
            for (ASTNode* pair : node->children)
                emitValue(pair, "");
            if (!tag.empty()) printf("</%s>", tag.c_str());
            break;

        case NODE_PAIR: {
            // Pair: the key becomes the XML tag, the single child is the value
            const std::string& key = node->value;
            ASTNode* val = node->children[0];
            emitValue(val, key);
            break;
        }

        case NODE_ARRAY:
            // Array: wrap in tag, each element becomes <item>
            if (!tag.empty()) printf("<%s>", tag.c_str());
            for (ASTNode* item : node->children)
                emitValue(item, "item");
            if (!tag.empty()) printf("</%s>", tag.c_str());
            break;

        case NODE_STRING:
        case NODE_NUMBER:
        case NODE_BOOL:
            printf("<%s>%s</%s>",
                tag.c_str(),
                escapeXML(node->value).c_str(),
                tag.c_str());
            break;

        case NODE_NULL:
            // Self-closing element
            printf("<%s/>", tag.c_str());
            break;
    }
}

void generateXML(ASTNode* node, const std::string& tag) {
    if (!node) return;

    if (node->type == NODE_OBJECT) {
        // Top-level object: emit its pairs directly inside <root> (no extra wrapping)
        for (ASTNode* pair : node->children)
            emitValue(pair, "");
    } else {
        // Top-level value that isn't an object (rare but valid JSON)
        emitValue(node, tag.empty() ? "value" : tag);
    }
}
