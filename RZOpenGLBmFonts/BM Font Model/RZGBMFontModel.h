//
//  RZGBMFontModel.h
//  RZGOGL
//
//  Created by John Stricker on 4/24/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZGModel.h"
@class RZGBMFontData;
@class RZGBitmapFontShaderSettings;
@class RZGOpenGLManager;

@interface RZGBMFontModel : RZGModel
@property (nonatomic, strong) RZGBitmapFontShaderSettings *shaderSettings;
@property (nonatomic, strong) RZGBMFontData *fontData;
@property (nonatomic, assign) GLfloat maxWidth;
@property (nonatomic, assign, readonly) GLfloat lastLineY;
@property (nonatomic, assign) GLfloat lineHeightAdjustment;
@property (nonatomic, assign) GLboolean centerHorizontal;
@property (nonatomic, assign) GLboolean centerVertical;
@property (nonatomic, assign) GLboolean applyLineHeightAdjWhenWrapping;

- (instancetype)initWithName:(NSString*)name BMfontData:(RZGBMFontData *)bmfd UseGLManager:(RZGOpenGLManager *)glmgr;
- (instancetype)initWithName:(NSString*)name BMFontData:(RZGBMFontData*)bmfd;
- (void)setupWithCharMax:(GLint)cMax;
- (void)updateWithText:(NSString*)str;
- (void)clearText;
- (NSString*)getCurrentText;
- (void)alternatingCharacterPositionAdjustmentX:(GLfloat)x Y:(GLfloat)y;
@end
