//
//  RZGModelData.h
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//
/*
 Designed to read and work with interleaved binary data (xyzxyzuv: vertex position: xyz, normals: xyz, and texture mapping: uv). Also can generate a Vertex Array Object (VAO) and Vertex Buffer Object (VBO)based on the data
 */

#ifndef RZOpenGLCoreDevelopment_RZGModelData_h
#define RZOpenGLCoreDevelopment_RZGModelData_h
#import <OpenGLES/ES2/gl.h>

typedef struct RZGModelData
{
    GLint arrayRows;
    GLint arraySize;
    GLint arrayCount;
    GLfloat * vertexArray;
}RZGModelData;

//load data and return a Vertex Array Object (VAO)
//assumes an active OpenGL context
void generateVaoInfoFromModelAtPath(const char *filepath, GLuint *vaoIndex, GLuint *vboIndex, GLuint *nVerts);
void generateVaoInfoFromModelData(RZGModelData *data, GLuint *vaoIndex, GLuint *vboIndex, GLuint *nVerts);

#endif
