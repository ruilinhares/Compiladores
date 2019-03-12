
#include <stdio.h>
#include <stdlib.h>  
#include <string.h> 
#include "semantics.h"
#include "Tabela_simbolos.h"
#include "tree.h"

char name[20];
char decType[20];

void check_program(node self){ 
	if (self == NULL)
		return;

	if (self->type != NULL){
		if (strcmp(self->type, "Program")==0){
			init_global_table();
		}

		if (strcmp(self->type, "FuncDefinition")==0){
			check_FuncDefinition(self);
		}

		if (strcmp(self->type, "FuncDeclaration")==0){
			check_FuncDeclaration(self);
		}

		if (strcmp(self->type, "Declaration")==0){
			check_Declaration(self);
		}
	}
	node auxNode = self->nodeSon;

	while(auxNode != NULL){
		if (self->type != NULL && strcmp(self->type, "Program")==0)
			strcpy(name,"Global");
		check_program(auxNode);
		auxNode = auxNode->nodeBrother;	
	}
}

void check_FuncDefinition(node self){
	char * types = check_TypeSpec(self->nodeSon->type);
	char * id = (char *) strdup(self->nodeSon->nodeBrother->nodeSon->id);
	char * params = check_Params(self->nodeSon->nodeBrother->nodeSon->nodeBrother);
	char ** paramlist = check_Params_List(self->nodeSon->nodeBrother->nodeSon->nodeBrother);

	strcpy(name, id);

	insert(id, types, params, "Global");
	init_function_table(id, paramlist, 1);
	insert("return", types, "", id);
	add_Params_Function(self->nodeSon->nodeBrother->nodeSon->nodeBrother, id);
}

void check_FuncDeclaration(node self){
	char * types = check_TypeSpec(self->nodeSon->type);
	char * id = (char *) strdup(self->nodeSon->nodeBrother->nodeSon->id);
	char * params = check_Params(self->nodeSon->nodeBrother->nodeSon->nodeBrother);
	char ** paramlist = check_Params_List(self->nodeSon->nodeBrother->nodeSon->nodeBrother);

	insert(id, types, params, "Global");
	init_function_table(id, paramlist, 0);
}

void check_Declaration(node self){
	
	if (self->id == NULL){
		char * types = check_TypeSpec(self->nodeSon->type);
		char * id = (char *) strdup(self->nodeSon->nodeBrother->id);
		strcpy(decType,types);
		insert(id, types, "", name);
	}
	
	else {
		char * id = (char *) strdup(self->nodeSon->id);
		insert(id, strdup(decType), "", name);
	}
}



char * check_TypeSpec(char * typeSpec){
	char * types = NULL;

	if (strcmp(typeSpec, "Char") == 0){
		types = (char *) strdup("char");
	}

	if (strcmp(typeSpec, "Int") == 0){
		types = (char *) strdup("int");
	}

	if (strcmp(typeSpec, "Void") == 0){
		types = (char *) strdup("void");
	}

	if (strcmp(typeSpec, "Short") == 0){
		types = (char *) strdup("short");
	}

	if (strcmp(typeSpec, "Double") == 0){
		types = (char *) strdup("double");
	}

	return strdup(types);
}

char * check_Params(node self){
	char params[200] = "(";

	node auxNode = self->nodeSon;

	while(auxNode != NULL){
		char * types =	check_TypeSpec(auxNode->nodeSon->type);	
		strcat(params,types);
		auxNode = auxNode->nodeBrother;
		if (auxNode != NULL)
			strcat(params,",");
	}
	strcat(params,")");
	return strdup(params);
}

char ** check_Params_List(node self){
	char ** paramlist = (char **) malloc(sizeof(char *) * 50);
	int i = 1;
	node auxNode = self->nodeSon;

	while(auxNode != NULL){
		char * types =	check_TypeSpec(auxNode->nodeSon->type);	
		paramlist[i] = types;
		auxNode = auxNode->nodeBrother;
		
	}
	return paramlist;
}

void add_Params_Function(node self, char * nameTable){
	node auxNode = self->nodeSon;

	while(auxNode != NULL){
		if (auxNode->nodeSon->nodeBrother != NULL){
			char * types =	check_TypeSpec(auxNode->nodeSon->type);	
			insert(auxNode->nodeSon->nodeBrother->id, types, "\tparam", nameTable);
		}
		auxNode = auxNode->nodeBrother;
	}
}

// ==================== arvore anotada ==========================

void check_tree(node self){
	if (self == NULL)
		return;
	if (self->type != NULL){

		if (strcmp(self->type, "FuncDefinition") == 0){
			char * id = (char *) strdup(self->nodeSon->nodeBrother->nodeSon->id);
			check_FuncBody(self->nodeSon->nodeBrother->nodeBrother, id);
			strcpy(name, "");
		}

		if (strcmp(self->type, "Declaration") == 0 && strcmp(name, "Global") == 0){
			if (self->id == NULL )
				check_FuncBody(self, "Global");
		}
	}

	node auxNode = self->nodeSon;

	while(auxNode != NULL){
		if (self->type != NULL && strcmp(self->type, "Program")==0)
			strcpy(name,"Global");
		check_tree(auxNode);
		auxNode = auxNode->nodeBrother;	
	}
}

void check_FuncBody(node self, char * nameTable){
	int decFlag = 0;

	if (self == NULL)
		return;

	if (self->type != NULL){

		if (strcmp(self->type, "Declaration") == 0 ){
			decFlag = 1;
		}

		if (strcmp(self->type, "Id") == 0){
			char * types = search_type(self->id, nameTable);
			if (strcmp(types, "") == 0){
				self->note = strdup(" - undef");
			}
			else{
				char * note = (char *) malloc(sizeof(char) * (4 + strlen(types)));
				note[0] = '\0';
				strcat(note," - ");
				strcat(note,types);
				self->note = (char *) strdup(note);
			}
			
		}

		if (strcmp(self->type, "Or") == 0 || strcmp(self->type, "And") == 0 ||  strcmp(self->type, "BitWiseAnd") == 0 || strcmp(self->type, "BitWiseOr") == 0 || strcmp(self->type, "BitWiseXor") == 0 || strcmp(self->type, "Mod") == 0){
			self->note = (char *) strdup(" - int");
		}

		if (strcmp(self->type, "Not") == 0  || strcmp(self->type, "Eq") == 0 || strcmp(self->type, "Ne") == 0 ||  strcmp(self->type, "Le") == 0 || strcmp(self->type, "Ge") == 0 || strcmp(self->type, "Lt") == 0 || strcmp(self->type, "Gt") == 0){
			self->note = (char *) strdup(" - int");
		}

		if (strcmp(self->type, "IntLit") == 0 ||  strcmp(self->type, "ChrLit") == 0){
			self->note = (char *) strdup(" - int");
		}

		if (strcmp(self->type, "RealLit") == 0){
			self->note = (char *) strdup(" - double");
		}		
	}

	node auxNode = self->nodeSon;

	while(auxNode != NULL){
		if (decFlag == 1 && auxNode->type != NULL && strcmp(auxNode->type, "Id") == 0){
			if (auxNode->nodeBrother != NULL &&auxNode->nodeBrother->type != NULL && strcmp(auxNode->nodeBrother->type, "Id") == 0){
				auxNode = auxNode->nodeBrother;
				check_FuncBody(auxNode, nameTable);
			}
		}
		
		else
			check_FuncBody(auxNode, nameTable);
		auxNode = auxNode->nodeBrother;	
	}

	if (strcmp(self->type, "Plus") == 0 || strcmp(self->type, "Minus") == 0 || strcmp(self->type, "Store") == 0){
		node auxNode1 = self->nodeSon;
		while (strcmp(auxNode1->type,"Aux") == 0)
			auxNode1 = auxNode1->nodeSon;

		char * note = (char *) strdup(auxNode1->note);
		int i = 0;
		while (i<strlen(note) - 1 && note[i] != '(')
			i++;
		if (note[i] == '('){
			note[i] = '\0';
		}
		self->note = (char *) strdup(note);
	}

	if (strcmp(self->type, "Comma") == 0){
		node auxNode1 = self->nodeSon->nodeBrother;
		while (strcmp(auxNode1->type,"Aux") == 0)
			auxNode1 = auxNode1->nodeSon;

		char * note = (char *) strdup(auxNode1->note);
		int i = 0;
		while (i<strlen(note) - 1 && note[i]!='(')
			i++;
		if (note[i] == '('){
			note[i]='\0';
		}
		self->note = (char *) strdup(note);	
	}

	if (strcmp(self->type, "Add") == 0 || strcmp(self->type, "Sub") == 0 ||  strcmp(self->type, "Mul") == 0 || strcmp(self->type, "Div") == 0){
		node auxNode1 = self->nodeSon;
		while (strcmp(auxNode1->type,"Aux") == 0)
			auxNode1 = auxNode1->nodeSon;
		
		node auxNode2 = self->nodeSon->nodeBrother;
		while (strcmp(auxNode2->type,"Aux") == 0)
			auxNode2 = auxNode2->nodeSon;

		char * note1 = (char *) strdup(auxNode1->note);
		char * note2 = (char *) strdup(auxNode2->note);
		int i = 0;
		while (i<strlen(note1) - 1 && note1[i]!='(')
			i++;
		if (note1[i] == '('){
			note1[i]='\0';
		}

		i = 0;
		while (i<strlen(note2) - 1 && note2[i]!='(')
			i++;
		if (note2[i] == '('){
			note2[i]='\0';
		}

		if (strcmp(note1, " - undef") == 0 || strcmp(note2, " - undef") == 0)
			self->note = (char *) strdup(" - undef");

		else if (strcmp(note1, " - double") == 0 || strcmp(note2, " - double") == 0)
			self->note = (char *) strdup(" - double");

		else if (strcmp(note1, " - int") == 0 || strcmp(note2, " - int") == 0)
			self->note = (char *) strdup(" - int");

		else if (strcmp(note1, " - short") == 0 || strcmp(note2, " - short") == 0)
			self->note = (char *) strdup(" - short");

		else if (strcmp(note1, " - char") == 0 || strcmp(note2, " - char") == 0)
			self->note = (char *) strdup(" - char");
	}

	if (strcmp(self->type, "Call") == 0){
		node selfSon = self->nodeSon;
		while (strcmp(selfSon->type, "Aux") == 0)
			selfSon = selfSon->nodeSon;

		char * types = search_type(selfSon->id, "Global");
		if (strcmp(types, "") == 0){
			self->note = (char *)strdup(" - undef");
		}
		else{
			char * note = (char *) malloc(sizeof(char) * (4 + strlen(types)));
			note[0] = '\0';
			strcat(note," - ");
			strcat(note,types);
			int i = 0;
			while (i<strlen(note) - 1 && note[i] != '(')
				i++;
			if (note[i] == '('){
				note[i]='\0';
				self->note = (char *) strdup(note);
			}
			else{
				self->note = (char *) strdup("");
			}
		}
		
	}
}