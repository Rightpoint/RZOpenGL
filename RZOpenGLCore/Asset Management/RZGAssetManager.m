//
//  RZGAssetManager.m
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGAssetManager.h"
#import "RZGModelData.h"
#import "RZGVaoInfo.h"
#import <GLKit/GLKit.h>
#import  <OpenGLES/ES2/glext.h>

static NSMutableDictionary *loadedTextures;
static NSMutableDictionary *loadedVaos;

@implementation RZGAssetManager

+ (GLuint)loadTexture:(NSString *)name ofType:(NSString *)type shouldLoadWithMipMapping:(BOOL)mipMappingOn
{
    if((loadedTextures) && [loadedTextures objectForKey:name])
    {
        return ((GLKTextureInfo*)[loadedTextures objectForKey:name]).name;
    }
    
    if(!loadedTextures)
    {
        loadedTextures = [[NSMutableDictionary alloc] init];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if(!path)
    {
        NSLog(@"TEXTURE FILE NOT FOUND for:%@.%@",name,type);
        return 0;
    }
    
    NSError *error;
    NSMutableDictionary *options= [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft];
    
    if(mipMappingOn)
    {
        [options setObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderGenerateMipmaps];
    }
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
     if(error != nil)
    {
        NSLog(@"ERROR LOADING TEXTURE: %@: %@",path,[error debugDescription]);
        return 0;
    }
    
    [loadedTextures setValue:textureInfo forKey:name];
    
    return textureInfo.name;
}

+ (GLuint)loadTextureNamed:(NSString *)name FromUIImage:(UIImage *)image shouldLoadWithMipMapping:(BOOL)mipMappingOn
{
    if( (loadedTextures) && [loadedTextures objectForKey:name])
    {
        return ((GLKTextureInfo*)[loadedTextures objectForKey:name]).name;
    }
    
    if(!loadedTextures)
    {
        loadedTextures = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary *options= [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft];
    
    if(mipMappingOn)
    {
        [options setObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderGenerateMipmaps];
    }
    
    NSError *error;
     GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:options error:&error];
    if ( error ) {
        if(error != nil)
        {
            NSLog(@"ERROR LOADING TEXTURE: %@: %@",name,[error debugDescription]);
            return 0;
        }
    }
    
    [loadedTextures setValue:textureInfo forKey:name];

    return textureInfo.name;
}

+ (GLuint)loadTextureFromUrl:(NSURL *)url shouldLoadWithMipMapping:(BOOL)mipMappingOn
{
    if((loadedTextures) && [loadedTextures objectForKey:url])
    {
    
        return ((GLKTextureInfo*)[loadedTextures objectForKey:url.absoluteString]).name;
    }
    
    if(!loadedTextures)
    {
        loadedTextures = [[NSMutableDictionary alloc] init];
    }
    
    NSError *error;
    NSMutableDictionary *options= [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft];
    
    if(mipMappingOn)
    {
        [options setObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderGenerateMipmaps];
    }
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfURL:url options:options error:&error];
    if(error != nil)
    {
        NSLog(@"ERROR LOADING TEXTURE: %@: %@",url,[error debugDescription]);
        return 0;
    }
    
    [loadedTextures setValue:textureInfo forKey:url.absoluteString];
    
    
    return textureInfo.name;
}


+ (RZGVaoInfo*)loadVaoInfo:(NSString*)name
{
    if((loadedVaos) && [loadedVaos objectForKey:name]) {
        return (RZGVaoInfo*)[loadedVaos objectForKey:name];
    }
    
    if(!loadedVaos) {
        loadedVaos = [[NSMutableDictionary alloc] init];
    }
    
    NSString* filepathname = [[NSBundle mainBundle] pathForResource:name ofType:@"model"];
    
    if(!filepathname)
    {
        NSLog(@"UNABLE TO LOCATE MODEL DATA for %@",name);
        return nil;
    }
    
    GLuint vao,vbo,nVerts;
    generateVaoInfoFromModelAtPath([filepathname cStringUsingEncoding:NSASCIIStringEncoding], &vao, &vbo, &nVerts);
    RZGVaoInfo *vic = [[RZGVaoInfo alloc] initWithVaoIndex:vao vboIndex:vbo andNVerts:nVerts];
    [loadedVaos setValue:vic forKey:name];
    
    return vic;
}

+(RZGVaoInfo*)loadVaoInfoFromData:(RZGModelData)data AssignName:(NSString *)name
{
    if((loadedVaos) && [loadedVaos objectForKey:name])
    {
        return (RZGVaoInfo*)[loadedVaos objectForKey:name];
    }
    if(!loadedVaos)
    {
        loadedVaos = [[NSMutableDictionary alloc] init];
    }
    
    GLuint vao,vbo,nVerts;
    generateVaoInfoFromModelData(&data, &vao, &vbo, &nVerts);
    RZGVaoInfo *vic = [[RZGVaoInfo alloc] initWithVaoIndex:vao vboIndex:vbo andNVerts:nVerts];
    [loadedVaos setValue:vic forKey:name];
    
    return vic;
}

//straight from iOS GLEssentials
+(void)destroyVAO:(GLuint) vaoName
{
	GLuint index;
	GLuint bufName;
	
	// Bind the VAO so we can get data from it
	glBindVertexArrayOES(vaoName);
	
	// For every possible attribute set in the VAO
	for(index = 0; index < 16; index++)
	{
		// Get the VBO set for that attibute
		glGetVertexAttribiv(index , GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING, (GLint*)&bufName);
		
		// If there was a VBO set...
		if(bufName)
		{
			//...delete the VBO
			glDeleteBuffers(1, &bufName);
		}
	}
    
    // Get any element array VBO set in the VAO
	glGetIntegerv(GL_ELEMENT_ARRAY_BUFFER_BINDING, (GLint*)&bufName);
	
	// If there was a element array VBO set in the VAO
	if(bufName)
	{
		//...delete the VBO
		glDeleteBuffers(1, &bufName);
	}
	
	// Finally, delete the VAO
	glDeleteVertexArraysOES(1, &vaoName);
    
}

+(void)unload
{
    // delete textures
    if(loadedTextures)
    {
        [loadedTextures enumerateKeysAndObjectsUsingBlock:^(id key, GLKTextureInfo *obj, BOOL *stop) {
            GLuint textureId = obj.name;
            glDeleteTextures(1,&textureId);
        }];
        loadedTextures = nil;
    }
    // delete VAOs
    if(loadedVaos)
    {
        [loadedVaos enumerateKeysAndObjectsUsingBlock:^(id key, RZGVaoInfo *obj, BOOL *stop) {
            [self destroyVAO:obj.vaoIndex];
        }];
        loadedVaos = nil;
    }
    
}



@end
