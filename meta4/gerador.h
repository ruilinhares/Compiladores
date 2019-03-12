
#ifndef GERADOR_H
#define GERADOR_H

#include <stdio.h>
#include <stdlib.h>  
#include <string.h> 
#include "tree.h"

void check_gerador(node self);
void gerador_FuncDefinition(node self);
void gerador_FuncDeclaration(node self);
void gerador_FuncBody(node self, char * type);
char * check_params(node self);
char * check_type(char * type);

#endif 
