//
//  UIImage+RZGTextureExtensions.h
//  RZGTransitionsAndSIze
//
//  Created by John Stricker on 12/15/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(RZGTextureExtentions)

+ (UIImage*) imageWithText:(NSString *) text
                 textColor:(UIColor *) textColor
                      font:(UIFont *) font
               textureSize:(CGSize) imageSize;

@end
