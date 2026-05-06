# JSON-to-XML Translator

A JSON-to-XML translator built in C++ using Flex (lexer) and Bison (parser).  
Reads valid JSON from standard input, constructs an AST, and emits well-formed XML to standard output.

---

## Build Instructions

Requires: `flex`, `bison`, `g++`, `make` (Ubuntu/WSL2)

```bash
sudo apt update && sudo apt install -y build-essential flex bison g++
make
```

This produces the `json2xml` binary. To clean all generated files:

```bash
make clean
```

---

## Run Instructions

Pass a JSON file via stdin:

```bash
./json2xml < input.json
```

Example using a test file:

```bash
./json2xml < tests/test1.json
```

Expected output:

```
<root><id>1</id><name>Ali</name><age>19</age></root>
```

To verify against expected output:

```bash
./json2xml < tests/test1.json | diff - tests/test1_expected.xml
```

---

## AST Structure

The parser builds a compact Abstract Syntax Tree (no nodes for punctuation).

### Node Types

| Type | `value` field | Children |
|---|---|---|
| `NODE_OBJECT` | — | `NODE_PAIR` nodes, one per key |
| `NODE_ARRAY` | — | value nodes, one per element |
| `NODE_PAIR` | key string (quotes stripped) | exactly one value node |
| `NODE_STRING` | string content (quotes stripped) | none |
| `NODE_NUMBER` | number as text | none |
| `NODE_BOOL` | `"true"` or `"false"` | none |
| `NODE_NULL` | — | none |

### Example

Input:
```json
{ "name": "Ali", "scores": [9, 10] }
```

AST:
```
NODE_OBJECT
├── NODE_PAIR  (value="name")
│   └── NODE_STRING  (value="Ali")
└── NODE_PAIR  (value="scores")
    └── NODE_ARRAY
        ├── NODE_NUMBER  (value="9")
        └── NODE_NUMBER  (value="10")
```

---

## Test Cases

| File | Covers |
|---|---|
| `tests/test1.json` | Simple flat object with scalar values |
| `tests/test2.json` | Object with an array of strings |
| `tests/test3.json` | Nested object (object inside object) |
| `tests/test4.json` | Null value (self-closing XML tag) |
| `tests/test5.json` | Complex: nesting, arrays, null, bool, number together |

---

## Assumptions and Limitations

- Input must be valid JSON; the program exits on the first lexical or syntax error.
- JSON keys are assumed to be valid XML tag names — no sanitization is applied.
- Only the escape sequences `\"`, `\\`, `\n`, `\t` are supported inside strings; `\uXXXX` Unicode escapes are not handled.
- Numbers follow the pattern `-?[0-9]+(\.[0-9]+)?`; scientific notation (e.g. `1.5e10`) is not supported.
- The top-level JSON value must be an object; a bare array or scalar at the top level is not tested.
- Output is compact (no indentation or newlines between tags).
