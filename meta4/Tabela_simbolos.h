
#ifndef TABELA_SIMBOLOS_H
#define TABELA_SIMBOLOS_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct notab * nodeTable;
typedef struct notab
{
	char * id;
	char * types;
	char * params;	

	nodeTable next;
} notab;

typedef struct tab * table;
typedef struct tab
{
	char * name;
	char * type;
	int flag;
	char ** paramslist;

	nodeTable table;
	table next;
} tab;

void init_global_table();
void init_function_table(char * name, char ** paramslist, int flag);
void insert(char * id, char * types, char * params, char * nameTable);
void print_tables();
char * search_type(char * id, char * nameTable);

#endif