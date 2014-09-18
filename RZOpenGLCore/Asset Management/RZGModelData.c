//
//  RZGModelData.c
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGModelData.h"
#import <stdio.h>
#import <stdlib.h>
#import <OpenGLES/ES2/glext.h>

// Load data only
// Make sure the data is freed by the caller
RZGModelData* loadModelFromPath(const char* filepath)
{
    FILE* curFile = fopen(filepath,"r");
    if(!curFile)
    {
        return NULL;
    }
    
    RZGModelData *md = (RZGModelData*)malloc(sizeof(RZGModelData));
    fread(&md->arrayRows,sizeof(GLint),1,curFile);
    md->arrayRows *= 3;
    md->arraySize = md->arrayRows * 8 * sizeof(GLfloat);
    md->vertexArray = (GLfloat*) malloc(md->arraySize);
    fread(md->vertexArray,1,md->arraySize,curFile);
    md->arrayCount = md->arrayRows * 8;
    fclose(curFile);
    
    //used for testing model output
    /*
     int colCount = 0;
     for(int i = 0; i < md->arrayCount; ++i)
     {
     printf("%f",md->vertexArray[i]);
     if(++colCount == 8)
     {
     printf("\n");
     colCount = 0;
     }
     else
     {
     printf(", ");
     }
     }*/
    
    return md;
}

// Load data and create a VAO
// Assumes an active OpenGL context
void generateVaoInfoFromModelAtPath(const char *filepath, GLuint *vaoIndex, GLuint *vboIndex, GLuint *nVerts)
{
    RZGModelData *data = loadModelFromPath(filepath);
    
    if(data)
    {
        generateVaoInfoFromModelData(data, vaoIndex, vboIndex, nVerts);
    
        free(data->vertexArray);
        free(data);
    }
}

// Create a VAO
void generateVaoInfoFromModelData(RZGModelData *data, GLuint *vaoIndex, GLuint *vboIndex, GLuint *nVerts)
{
    if(data)
    {
        GLuint vao,vbo;
        
        glGenVertexArraysOES(1,&vao);
        glBindVertexArrayOES(vao);
        
        glGenBuffers(1,&vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, data->arraySize,data->vertexArray, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 32, (char*)NULL + 0);
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 32, (char*)NULL + 12);
        glEnableVertexAttribArray(2);
        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 32, (char*)NULL + 24);
        
        *nVerts = data->arrayRows;
        *vaoIndex = vao;
        *vboIndex = vbo;
    }
}

