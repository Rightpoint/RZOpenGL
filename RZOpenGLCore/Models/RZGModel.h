//
//  RZGModel.h
//  RZGOGL
//
//  Created by John Stricker on 11/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class RZGDefaultShaderSettings;
@class RZGPrs;
@class RZGCommand;
@class RZGVaoInfo;
@class RZGOpenGLManager;

@interface RZGModel : NSObject

@property (strong, nonatomic) RZGOpenGLManager *glmgr;
@property (strong, nonatomic) RZGPrs *prs;
@property (strong, nonatomic) RZGPrs *worldPrs;
@property (assign, nonatomic) BOOL isHidden;
@property (assign, nonatomic) BOOL useDepthTest;
@property (assign, nonatomic) GLKVector4 diffuseColor;
@property (assign, nonatomic) GLfloat alpha;
@property (assign, nonatomic) GLfloat shadowMax;

//properties needed for subclasses: TO DO maybe: implement a protected solution such as dscribed here:
//http://stackoverflow.com/questions/11047351/workaround-to-accomplish-protected-properties-in-objective-c
@property (strong, nonatomic) RZGVaoInfo* vaoInfo;
@property (assign, nonatomic) GLuint texture0Id;
@property (assign, nonatomic) GLKMatrix4 projection;
@property (assign, nonatomic) GLKMatrix3 normalMatrix;
@property (assign, nonatomic) GLKMatrix4 modelViewProjection;
@property (strong, nonatomic) RZGDefaultShaderSettings *defaultShaderSettings;
@property (assign, nonatomic) CGPoint dimensions2d;
@property (strong, nonatomic) NSMutableArray *commands;
@property (strong, nonatomic) NSMutableArray *finishedCommands;


- (instancetype) initWithModelFileName:(NSString*)modelFileName;
- (instancetype) initWithModelFileName:(NSString*)modelFileName UseDefaultSettingsInManager:(RZGOpenGLManager*)manager;
- (void)setProjection:(GLKMatrix4)projection;
- (void)setTexture0Id:(GLuint)texture0Id;
- (void)setDefaultShaderSettings:(RZGDefaultShaderSettings*)defaultShaderSettings;
- (void)setDimensions2dX:(GLfloat)x andY:(GLfloat)y;
- (BOOL)isTransformedPointWithinModel2d:(CGPoint)point;
- (void)addCommand:(RZGCommand*)command;
- (void)clearAllCommands;
- (void)clearCommandsOfTypes:(NSArray*)commandTypes;
- (void)clearCommandsOfType:(NSUInteger)commandType;
- (void)updateWithTime:(GLfloat)time;
- (void)processCommand:(RZGCommand*)command withTime:(GLfloat)time;
- (void)updateModelViewProjection;
- (void)draw;
@end
