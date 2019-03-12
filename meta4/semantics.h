
#ifndef SEMANTICS_H
#define SEMANTICS_H

#include "Tabela_simbolos.h"
#include "tree.h"

void check_program(node self);
void check_FuncDefinition(node self);
void check_FuncDeclaration(node self);
void check_Declaration(node self);
char * check_TypeSpec(char * typeSpec);
char * check_Params(node self);
char ** check_Params_List(node self);
void add_Params_Function(node self, char * nameTable);

void check_tree(node self);
void check_FuncBody(node self, char * nameTable);

#endif 