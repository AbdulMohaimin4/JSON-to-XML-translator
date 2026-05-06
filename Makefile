CXX      = g++
CXXFLAGS = -Wall -std=c++17

all: json2xml

json2xml: parser.tab.o lex.yy.o ast.o xml_generator.o main.o
	$(CXX) $(CXXFLAGS) -o json2xml parser.tab.o lex.yy.o ast.o xml_generator.o main.o

# Step 1: Bison generates parser.tab.c AND parser.tab.h
parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

# Step 2: Flex uses parser.tab.h for token constants
lex.yy.c: scanner.l parser.tab.h
	flex scanner.l

parser.tab.o: parser.tab.c
	$(CXX) $(CXXFLAGS) -c parser.tab.c

lex.yy.o: lex.yy.c
	$(CXX) $(CXXFLAGS) -c lex.yy.c

ast.o: ast.cpp ast.h
	$(CXX) $(CXXFLAGS) -c ast.cpp

xml_generator.o: xml_generator.cpp xml_generator.h ast.h
	$(CXX) $(CXXFLAGS) -c xml_generator.cpp

main.o: main.cpp ast.h xml_generator.h
	$(CXX) $(CXXFLAGS) -c main.cpp

clean:
	rm -f *.o lex.yy.c parser.tab.c parser.tab.h json2xml
