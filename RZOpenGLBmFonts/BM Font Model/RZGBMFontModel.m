//
//  SSGBMFontModel.m
//  SSGOGL
//
//  Created by John Stricker on 3/7/14.
//  Copyright (c) 2014 Sway Software. All rights reserved.
//

#import "SSGBMFontModel.h"
#import "SSGModelData.h"
#import "SSGBMFontData.h"
#import "SSGBMFontCharData.h"
#import "SSGVaoInfo.h"
#import "SSGShaderManager.h"
#import "SSGBitmapFontShaderSettings.h"
#import "SSGCommand.h"

#define kCharMax 1000
#define kLineBreakChar '~'
@interface SSGBMFontModel()
{
    GLfloat dataArr[kCharMax*30];
    const char *textCharPtr;
    SSGModelData *modelData;
}
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) GLint charCount;
@property (nonatomic, assign) GLint assignedCharMax;
@property (nonatomic, assign) GLint currentIndex;

- (void)setData:(GLfloat*)data;
- (GLboolean)nextWordShouldWrapAtIndex:(int)currentIndex CurrentXpos:(GLfloat)xPos;

@end

@implementation SSGBMFontModel

- (instancetype)initWithName:(NSString *)name BMFontData:(SSGBMFontData *)bmfd
{
    self = [super init];
    if(self)
    {
        //init base class but w/out model file
        self = [self initWithModelFileName:nil];
        _applyLineHeightAdjWhenWrapping = YES;
        _fontData = bmfd;
    }
    
    return self;
}

- (GLboolean)nextWordShouldWrapAtIndex:(int)currentIndex CurrentXpos:(GLfloat)xPos
{
    char c;
    SSGBMFontCharData *cd;
    
    for(int i = self.currentIndex+1; i < [self.text length]; i++)
    {
        c = textCharPtr[i];
        if(c != ' ' && c != kLineBreakChar)
        {
            cd = [self.fontData charDataFor:c];
            xPos = cd.xOffset + cd.width;
            if(xPos > self.maxWidth)
            {
                return YES;
            }
        }
        else
        {
            return NO;
        }
    }
    
    return NO;
}

- (NSString*)getCurrentText
{
    return self.text;
}

- (void)setData:(GLfloat *)data
{
    glBindBuffer(GL_ARRAY_BUFFER, self.vaoInfo.vboIndex);
    glBufferSubData(GL_ARRAY_BUFFER, 0, 120*self.charCount, data);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    self.vaoInfo.nVerts = self.charCount * 6;
}

-(void)adjustDataXY:(GLfloat)x :(GLfloat)y
{
    int iAdj = 0;
    for(int i = 0; i < self.charCount; i++)
    {
        iAdj = 30 * i;
        //lower left
        dataArr[0+iAdj] += x;
        dataArr[1+iAdj] += y;
        //lower right
        dataArr[5+iAdj] += x;
        dataArr[6+iAdj] += y;
        //upper right
        dataArr[10+iAdj] += x;
        dataArr[11+iAdj] += y;
        //upper left
        dataArr[15+iAdj] +=x;
        dataArr[16+iAdj] +=y;
        //lower left
        dataArr[20+iAdj] +=x;
        dataArr[21+iAdj] +=y;
        //upper right
        dataArr[25+iAdj] += x;
        dataArr[26+iAdj] += y;
    }
}

- (void)setupWithCharMax:(GLint)cMax
{
    if(cMax > kCharMax)
    {
        NSLog(@"WARNING: BMFONT ASSIGNED W/ CHAR MAX EXCEEDED");
    }
    
    self.assignedCharMax = cMax;
    GLuint vao, vbo;
    
    glGenVertexArraysOES(1,&vao);
    glBindVertexArrayOES(vao);
    
    glGenBuffers(1,&vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, 120*cMax,dataArr, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 20, (char*)NULL + 0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 20, (char*)NULL + 12);
    
    self.vaoInfo = [[SSGVaoInfo alloc] initWithVaoIndex:vao vboIndex:vbo andNVerts:6*cMax];
}

- (void)updateWithText:(NSString *)str
{
    self.text = str;
    GLfloat currX = 0.0f;
    GLfloat currY;
    GLfloat currentLineY = self.fontData.lineHeight;
    GLfloat dstY = 0.0f;
    self.dimensions2d = CGPointMake(0.0f, 0.0f);
    
    if(self.charCount != 0)
    {
        for(int i = 0; i < (self.charCount - 1) * 30 + 5; i++)
        {
            dataArr[i] = 0.0f;
        }
    }
    
    self.charCount = (GLint)[str length];
    self.currentIndex = self.charCount;
    if(self.charCount > self.assignedCharMax)
    {
        NSLog(@"WARNING: BMFont assigned character max of %i exceeded in text:%@",self.assignedCharMax,str);
    }
    
    textCharPtr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    
    GLint iAdj;
    
    for (int i = 0; i < self.charCount; i++)
    {
        char c = textCharPtr[i];
        
        
        if(c != '~')
        {
            SSGBMFontCharData *cd = [self.fontData charDataFor:c];
            
            currY = currentLineY - cd.yOffset;
            dstY = currY - cd.height;
            
            iAdj = 30*i;
            
            //lower left
            dataArr[0+iAdj] = currX + cd.xOffset;
            dataArr[1+iAdj] = dstY;
            dataArr[2+iAdj] = 0.0f;
            dataArr[3+iAdj] = cd.xPos;
            dataArr[4+iAdj] = cd.yPos - cd.height;
            
            //lower right
            dataArr[5+iAdj] = currX + cd.xOffset + cd.width;
            dataArr[6+iAdj] = dstY;
            dataArr[7+iAdj] = 0.0f;
            dataArr[8+iAdj] = cd.xPos + cd.width;
            dataArr[9+iAdj] = cd.yPos - cd.height;
            
            //upper right
            dataArr[10+iAdj] = currX + cd.xOffset + cd.width;
            dataArr[11+iAdj] = currY;
            dataArr[12+iAdj] = 0.0f;
            dataArr[13+iAdj] = cd.xPos + cd.width;
            dataArr[14+iAdj] = cd.yPos;
            
            //upper left
            dataArr[15+iAdj] = currX + cd.xOffset ;
            dataArr[16+iAdj] =currY;
            dataArr[17+iAdj] = 0.0f;
            dataArr[18+iAdj] = cd.xPos;
            dataArr[19+iAdj] = cd.yPos;
            
            //lower left
            dataArr[20+iAdj] = currX + cd.xOffset;
            dataArr[21+iAdj] = dstY;
            dataArr[22+iAdj] = 0.0f;
            dataArr[23+iAdj] = cd.xPos;
            dataArr[24+iAdj] = cd.yPos - cd.height;
            
            //upper right
            dataArr[25+iAdj] = currX + cd.xOffset +cd.width;
            dataArr[26+iAdj] = currY;
            dataArr[27+iAdj] = 0.0f;
            dataArr[28+iAdj] = cd.xPos + cd.width;
            dataArr[29+iAdj] = cd.yPos;
            
            currX += cd.xAdvance;
            
            GLfloat newXSize = dataArr[25+iAdj];
            if(newXSize < self.dimensions2d.x)
            {
                newXSize = self.dimensions2d.x;
            }
            self.dimensions2d = CGPointMake(newXSize, dataArr[26+iAdj]);
        }
        if((_maxWidth > 0 && c == ' ' && [self nextWordShouldWrapAtIndex:i CurrentXpos:currX]))
        {
            currX = 0.0f;
            currentLineY -= self.fontData.lineHeight;
            if(_applyLineHeightAdjWhenWrapping && self.lineHeightAdjustment != 0.0f)
            {
                currentLineY -= self.lineHeightAdjustment;
            }
        }
        if(c == '~')
        {
            currX = 0.0f;
            currentLineY -= self.fontData.lineHeight;
            currentLineY -= self.lineHeightAdjustment;
        }
        
    }
    _lastLineY = currentLineY;
    if(self.centerHorizontal || self.centerVertical)
    {
        GLfloat xAdj = 0.0f;
        GLfloat yAdj = 0.0f;
        
        if(_centerHorizontal)
            xAdj = -self.dimensions2d.x/2.0f;
        if(_centerVertical)
            yAdj = -self.dimensions2d.y/2.0f;
        
        [self adjustDataXY:xAdj :yAdj];
    }
    [self setData:dataArr];
}

- (void)alternatingCharacterPositionAdjustmentX:(GLfloat)x Y:(GLfloat)y
{
    int index = 0;
    for(int i = 0; i < self.charCount; i++)
    {
        dataArr[index] = dataArr[index]+x;
        dataArr[index+1] = dataArr[index+1]+y;
        dataArr[index+5] = dataArr[index+5]+x;
        dataArr[index+6] = dataArr[index+6]+y;
        dataArr[index+10] = dataArr[index+10]+x;
        dataArr[index+11] = dataArr[index+11]+y;
        dataArr[index+15] = dataArr[index+15]+x;
        dataArr[index+16] = dataArr[index+16]+y;
        dataArr[index+20] = dataArr[index+20]+x;
        dataArr[index+21] = dataArr[index+21]+y;
        dataArr[index+25] = dataArr[index+25]+x;
        dataArr[index+26] = dataArr[index+26]+y;
        
        index += 30;
        x = -x;
        y = -y;
    }
    [self setData:dataArr];
}

- (void)clearText
{
    self.text = @"";
    if(self.assignedCharMax != 0)
    {
        for(int i = 0; i < (self.assignedCharMax - 1) * 30 + 5; i++)
        {
            dataArr[i] = 0.0f;
        }
        [self setData:dataArr];
    }
}

- (void)processCommand:(SSGCommand*)command withTime:(GLfloat)time
{
    switch (command.commandEnum) {
        case kSSGCommand_font_alternatingSplit:
            if(command.duration <= 0.0f)
            {
                [self alternatingCharacterPositionAdjustmentX:command.target.x Y:command.target.y];
                command.isFinished = YES;
            }
            else
            {
                if(!command.isStarted)
                {
                    command.step = command2float(command.target.x / command.duration, command.target.y / command.duration);
                    command.isStarted = YES;
                }
                command.duration -= time;
                [self alternatingCharacterPositionAdjustmentX:command.step.x*time Y:command.step.y * time];
            }
            
            break;
            
        default:
            break;
    }
    
    [super processCommand:command withTime:time];
    
}

- (void)draw
{
    if(self.isHidden)
    {
        return;
    }
    
    [SSGShaderManager useProgram:self.shaderSettings.programId];
    [self.shaderSettings setAlpha:self.alpha];
    [self.shaderSettings setModelViewProjectionMatrix:self.modelViewProjection];
    
    glBindVertexArrayOES(self.vaoInfo.vaoIndex);
    glBindTexture(GL_TEXTURE_2D, self.texture0Id);
    glDrawArrays(GL_TRIANGLES, 0, self.vaoInfo.nVerts);
}

@end
