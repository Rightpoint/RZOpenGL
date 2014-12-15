//
//  UIImage+RZGTextureExtensions.m
//  RZGTransitionsAndSIze
//
//  Created by John Stricker on 12/15/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "UIImage+RZGTextureExtensions.h"

@implementation UIImage (RZGTextureExtensions)

+ (UIImage*) imageWithText:(NSString *) text
                 textColor:(UIColor *) textColor
                      font:(UIFont *) font
               textureSize:(CGSize) imageSize
{
    UIGraphicsBeginImageContext(imageSize);
    CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, imageSize.width, imageSize.height)); // this may not be necessary
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSDictionary *attDir = @{
                             NSFontAttributeName : font,
                             NSForegroundColorAttributeName : textColor
                             };
    CGSize textSize = [text sizeWithAttributes:attDir];
    
    UIGraphicsBeginImageContext(imageSize);
    [blankImage drawInRect:CGRectMake(0,0,imageSize.width,imageSize.height)];
    CGRect rect = CGRectMake(imageSize.width / 2.0f - textSize.width / 2.0f, imageSize.height / 2.0f - textSize.height / 2.0f, textSize.width, textSize.height);
    [[UIColor whiteColor] set];
    
    [text drawInRect:rect withAttributes:attDir];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
