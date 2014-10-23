//
//  RZGShaderManager.m
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGShaderManager.h"
#import <GLKit/GLKit.h>



static GLuint lastProgramUsed; // Keeps track of last program used to minimize program switching

@interface RZGShaderManager()

+ (GLuint)loadProgram:(NSString *)vertShaderName :(NSString *)fragShaderName, ...;
+ (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
+ (BOOL)linkProgram:(GLuint)prog;
+ (BOOL)validateProgram:(GLuint)prog;

@end

@implementation RZGShaderManager

+(void) useProgram:(unsigned int)programId
{
    if(programId != lastProgramUsed)
    {
        glUseProgram(programId);
        lastProgramUsed = programId;
    }
}

+(unsigned int) loadModelDefaultShader
{
    return [self loadProgram:@"RZGDefaultShader" :@"RZGDefaultShader",3,0,"a_position",1,"a_normal",2,"a_texCoord"];
}

+ (unsigned int) loadBitmapFontShader
{
    return [self loadProgram:@"RZGBitmapFont" :@"RZGBitmapFont",2,0,"a_position",1,"a_texCoord"];
}

+ (unsigned int) loadColoredPointSpriteShader
{
    return [self loadProgram:@"RZGColoredPointSprite" :@"RZGColoredPointSprite",1,0,"a_position"];
}

+(GLuint) loadProgram:(NSString *)vertShaderName :(NSString *)fragShaderName, ...
{
    
    GLuint vertShader, fragShader, program;
    NSString *vertShaderPathname, *fragShaderPathname;
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:vertShaderName ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:fragShaderName ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    va_list attributeList;
    va_start(attributeList, fragShaderName);
    char *szNextArg;
    int iArgCount = va_arg(attributeList,int);
    for(int i = 0; i < iArgCount; i++)
    {
        int index = va_arg(attributeList,int);
        szNextArg = va_arg(attributeList,char*);
        glBindAttribLocation(program, index, szNextArg);
    }
    va_end(attributeList);
    
    // Link program.
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program) {
            glDeleteProgram(program);
            //program = 0;
        }
        
        return NO;
    }
    // Release vertex and fragment shaders.
    if (vertShader)
    {
        glDetachShader(program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader)
    {
        glDetachShader(program, fragShader);
        glDeleteShader(fragShader);
    }
    return program;
}
+(BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#ifdef DEBUG
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

+(BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#ifdef DEBUG
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
    {
        return NO;
    }
    
    return YES;
}

+(BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
    {
        return NO;
    }
    
    return YES;
}


@end
