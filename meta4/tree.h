
#ifndef TREE_H
#define TREE_H

typedef struct no * node;
typedef struct no {
        char * id;
        char * type;
        node nodeSon;
        node nodeBrother;

        char * note;
}no;

void printTree(node auxNode, int pontos);

#endif