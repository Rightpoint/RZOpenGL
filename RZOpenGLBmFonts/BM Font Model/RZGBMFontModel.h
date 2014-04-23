//
//  SSGBMFontModel.h
//  SSGOGL
//
//  Created by John Stricker on 3/7/14.
//  Copyright (c) 2014 Sway Software. All rights reserved.
//

#import "SSGModel.h"
@class SSGBMFontData;
@class SSGBitmapFontShaderSettings;

@interface SSGBMFontModel : SSGModel
@property (nonatomic, strong) SSGBitmapFontShaderSettings *shaderSettings;
@property (nonatomic, strong) SSGBMFontData *fontData;
@property (nonatomic, assign) GLfloat maxWidth;
@property (nonatomic, assign, readonly) GLfloat lastLineY;
@property (nonatomic, assign) GLfloat lineHeightAdjustment;
@property (nonatomic, assign) GLboolean centerHorizontal;
@property (nonatomic, assign) GLboolean centerVertical;
@property (nonatomic, assign) GLboolean applyLineHeightAdjWhenWrapping;

- (instancetype)initWithName:(NSString*)name BMFontData:(SSGBMFontData*)bmfd;
- (void)setupWithCharMax:(GLint)cMax;
- (void)updateWithText:(NSString*)str;
- (void)clearText;
- (NSString*)getCurrentText;
- (void)alternatingCharacterPositionAdjustmentX:(GLfloat)x Y:(GLfloat)y;
@end
