/**
 * @file stack.c
 * @author Hugo Mathieu (hmathieu@insa-toulouse.fr)
 * @brief Implementation of a base C stack to store the functions IDs
 * @version 0.1
 * @date 2022-06-01
 *
 * @copyright Copyright (c) 2022
 *
 */

#include <stdio.h>
#include <stdlib.h>

// Structure to create a node with data and next pointer
typedef struct Node
{
    int data;
    struct Node *next;
} Node;

Node *top = NULL;

// Push() operation on a  stack
void push(int value)
{
    struct Node *newNode;
    newNode = (struct Node *)malloc(sizeof(struct Node));
    newNode->data = value; // assign value to the node
    if (top == NULL)
    {
        newNode->next = NULL;
    }
    else
    {
        newNode->next = top; // Make the node as top
    }
    top = newNode; // top always points to the newly created node
    printf("Node is Inserted\n\n");
}

int pop()
{
    if (top == NULL)
    {
        printf("\nStack Underflow\n");
        exit(-1);
    }
    struct Node *temp = top;
    int temp_data = top->data;
    top = top->next;
    free(temp);
    return temp_data;
}

void display()
{
    // Display the elements of the stack
    if (top == NULL)
    {
        printf("\nStack Underflow\n");
    }
    else
    {
        printf("The stack is \n");
        struct Node *temp = top;
        while (temp->next != NULL)
        {
            printf("%d--->", temp->data);
            temp = temp->next;
        }
        printf("%d--->NULL\n\n", temp->data);
    }
}
