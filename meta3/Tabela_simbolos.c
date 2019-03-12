
#include "Tabela_simbolos.h"

table symTable = NULL;

void init_global_table(){
	symTable = calloc(1, sizeof(tab));

	symTable->type = (char *)calloc((strlen("Global") + 1), sizeof(char));
	strcpy(symTable->type, "Global");

	symTable->name = "";
	symTable->flag = 1;
	symTable->paramslist = NULL;

	insert("putchar","int(int)","","Global");
	insert("getchar","int(void)","","Global");
}

void init_function_table(char * name, char ** paramslist, int flag){
	table newTable = calloc(1, sizeof(tab));

	newTable->type = (char *)calloc((strlen("Function") + 1), sizeof(char));
	strcpy(newTable->type, "Function");

	newTable->name = name;
	newTable->flag = flag;
	newTable->paramslist = paramslist;
	table auxTable = symTable;

	if (auxTable == NULL)
		auxTable = newTable;
	else{
		while (auxTable->next != NULL){
			if (strcmp(auxTable->name, name)==0 && auxTable->flag==0){
				auxTable->flag = 1;
				free(newTable);
				return;
			}
			auxTable = auxTable->next;
		}
		if (strcmp(auxTable->name, name)==0 && auxTable->flag==0){
			auxTable->flag = 1;
			free(newTable);
			return;
		}
		auxTable->next = newTable;
	}
}

void insert(char * id, char * types, char * params, char * nameTable){
	nodeTable newNodeTable = (nodeTable) malloc(sizeof(notab));
	newNodeTable->id = id;
	newNodeTable->types = types;
	newNodeTable->params = params;
	newNodeTable->next = NULL;

	table auxTable = NULL;

	if (strcmp(nameTable, "Global")==0)
		auxTable = symTable;
	else{
		auxTable = symTable->next;
		while (auxTable != NULL && strcmp(nameTable,auxTable->name)!=0)
			auxTable = auxTable->next;
	}

	if (auxTable->table == NULL)
		auxTable->table = newNodeTable;
	else{
		nodeTable auxNodeTable = auxTable->table;
		while (auxNodeTable->next != NULL){

			if (strcmp(auxNodeTable->id, id)==0){
				free(newNodeTable);
				return;
			}
			auxNodeTable = auxNodeTable->next;
		}
		if (strcmp(auxNodeTable->id, id)==0){
			free(newNodeTable);
			return;
		}
		auxNodeTable->next = newNodeTable;
	}
}

void print_tables(){
	table auxTable = symTable;
	nodeTable auxNodeTable;

	while (auxTable != NULL){
		if (auxTable->flag == 1){
			if (strcmp(auxTable->type,"Global")==0)
				printf("===== Global Symbol Table =====\n");
			else 
				printf("===== %s %s Symbol Table =====\n", auxTable->type, auxTable->name);
			auxNodeTable = auxTable->table;

			while ( auxNodeTable != NULL){
				printf("%s\t%s%s\n", auxNodeTable->id, auxNodeTable->types, auxNodeTable->params);
				auxNodeTable = auxNodeTable->next;
			}
			printf("\n");
		}
		auxTable = auxTable->next;
	}
}

char * search_type(char * id, char * nameTable){
	table auxTable = symTable;
	while(auxTable != NULL){
		if (strcmp(auxTable->name, nameTable) == 0){
			nodeTable auxNodeTable = auxTable->table;
			while (auxNodeTable != NULL){
				if (strcmp(auxNodeTable->id, id) == 0)
					return (char *) strdup(auxNodeTable->types);

				auxNodeTable = auxNodeTable->next;
			}
		}
		auxTable = auxTable->next;
	}
	auxTable = symTable;
	nodeTable auxNodeTable = auxTable->table;
	while (auxNodeTable != NULL){
		if (strcmp(auxNodeTable->id, id) == 0){
			char * str = (char *) malloc(sizeof(char)*(strlen(auxNodeTable->types) + strlen(auxNodeTable->params) + 1));
			str[0] = '\0';
			strcat(str, auxNodeTable->types);
			strcat(str, auxNodeTable->params);
			return (char *) strdup(str);
		}

		auxNodeTable = auxNodeTable->next;
	}

	return "";
}