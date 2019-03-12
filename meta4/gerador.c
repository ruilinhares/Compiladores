#include "gerador.h"

char * decType;
int count_var = 1;

void check_gerador(node self){

	if (self->type != NULL){
	if (strcmp(self->type, "FuncDefinition")==0){
		gerador_FuncDefinition(self);
	}

	if (strcmp(self->type, "FuncDeclaration")==0){
		gerador_FuncDeclaration(self);
	}

	if (strcmp(self->type, "Declaration")==0){

	}
}

	node auxNode = self->nodeSon;

while(auxNode != NULL){
	check_gerador(auxNode);
	auxNode = auxNode->nodeBrother;	
}
/*
if (self->type != NULL && strcmp(self->type, "Program")==0){
	printf("define i32 @main() {\n\tret i32 0\n}\n");
}*/
}

void gerador_FuncDefinition(node self){
	char * type = check_type(self->nodeSon->type);
	char * params = check_params(self->nodeSon->nodeBrother->nodeSon->nodeBrother);
	if (strcmp(params, "void") == 0)
		params = "";
	printf("define %s @%s(%s) {\n", type, self->nodeSon->nodeBrother->nodeSon->id, params);
	//gerador_FuncBody(self->nodeSon->nodeBrother->nodeBrother, type);
	printf("\tret %s 0\n", type);
	printf("}\n\n");
}

void gerador_FuncBody(node self, char * type){
	if (self->type != NULL){
		/*if (strcmp(self->type, "Store")==0){
			node auxNode1 = self->nodeSon;
			while (strcmp(auxNode1->type,"Aux") == 0)
				auxNode1 = auxNode1->nodeSon;

			printf("\tstore i32 %%%d, i32* %%%s, align 4\n", count_var, auxNode1->id);
		}*/

		if (/*strcmp(self->type, "Plus")==0 ||*/ strcmp(self->type, "Minus")==0 /*|| strcmp(self->type, "Not")==0*/){
			printf("%%%d = sub nsw i32 0, %%%d\n", count_var, count_var - 1);
			count_var++;
		}

		if (strcmp(self->type, "Declaration")==0){
			if (self->id == NULL){
				decType = self->nodeSon->type;
				if (strcmp(decType, "Char") == 0){
					printf("\t%%%s = alloca i8, align 1\n", self->nodeSon->nodeBrother->id);
				}

				if (strcmp(decType, "Int") == 0){
						printf("\t%%%s = alloca i32, align 4\n", self->nodeSon->nodeBrother->id);
				}

				if (strcmp(decType, "Short") == 0){
						printf("\t%%%s = alloca i16, align 2\n", self->nodeSon->nodeBrother->id);
				}

				if (strcmp(decType, "Double") == 0){
						printf("\t%%%s = alloca double, align 8\n", self->nodeSon->nodeBrother->id);
				}
			} else{
				if (strcmp(decType, "Char") == 0){
					printf("\t%%%s = alloca i8, align 1\n", self->nodeSon->id);
				}

				if (strcmp(decType, "Int") == 0){
					printf("\t%%%s = alloca i32, align 4\n", self->nodeSon->id);
				}

				if (strcmp(decType, "Short") == 0){
					printf("\t%%%s = alloca i16, align 2\n", self->nodeSon->id);
				}

				if (strcmp(decType, "Double") == 0){
					printf("\t%%%s = alloca double, align 8\n", self->nodeSon->id);
				}

			}
		}
		/*
		if (strcmp(self->type, "Return")==0){
			if (strcmp(self->nodeSon->type, "Null") == 0)
					printf("\tret %s\n", type);

				else if (strcmp(self->nodeSon->type, "Id") == 0)
					printf("\tret %s %%%s\n", type, self->nodeSon->id);
		}*/
	}

	node auxNode = self->nodeSon;

	while(auxNode != NULL){
		gerador_FuncBody(auxNode, type);
		auxNode = auxNode->nodeBrother;	
	}
}

char * check_params(node self){
	char params[200] = "";

	node auxNode = self->nodeSon;

	while(auxNode != NULL){
		char * types =	check_type(auxNode->nodeSon->type);	
		strcat(params,types);
		if (auxNode->nodeSon->nodeBrother != NULL && strcmp(auxNode->nodeSon->nodeBrother->type, "Id")==0){
			strcat(params," %");
			strcat(params,auxNode->nodeSon->nodeBrother->id);
		}
			
		auxNode = auxNode->nodeBrother;
		if (auxNode != NULL)
			strcat(params,", ");
	}
	return strdup(params);
}

void gerador_FuncDeclaration(node self){
	
}

char * check_type(char * type){
	char * types = NULL;

	if (strcmp(type, "Char") == 0){
		types = (char *) strdup("i8");
	}

	if (strcmp(type, "Int") == 0){
		types = (char *) strdup("i32");
	}

	if (strcmp(type, "Void") == 0){
		types = (char *) strdup("void");
	}

	if (strcmp(type, "Short") == 0){
		types = (char *) strdup("i16");
	}

	if (strcmp(type, "Double") == 0){
		types = (char *) strdup("double");
	}

	return strdup(types);
}