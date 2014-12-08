//
//  RZFDDiscsViewController.m
//  RZFlypDiscs
//
//  Created by John Stricker on 12/8/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZFDDiscsViewController.h"

@interface RZFDDiscsViewController ()

@end

@implementation RZFDDiscsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:self.view.bounds.size PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    [self.glmgr loadBitmapFontShaderAndSettings];
    
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f)];
    self.view.opaque = NO;
    
    GLfloat mainZ = -10.0f;
    
    RZGModel *disc = [[RZGModel alloc] initWithModelFileName:@"disc" UseDefaultSettingsInManager:self.glmgr];
    [disc setTexture0Id: [RZGAssetManager loadTexture:@"whiteSpeck" ofType:@"png" shouldLoadWithMipMapping:NO]];
    disc.shadowMax = 0.1f;
    disc.diffuseColor = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
    
    disc.prs.pz = mainZ;
    
    RZGModel *discLetter = [[RZGModel alloc] initWithModelFileName:@"discLabel" UseDefaultSettingsInManager:self.glmgr];
    
    CGSize imageSize = CGSizeMake(64.0f,64.0f);
    UIGraphicsBeginImageContext(imageSize);

    CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, imageSize.width, imageSize.height)); // this may not be necessary
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *letterImage = [RZFDDiscsViewController drawText:@"H" inImage:blankImage];
    
    [discLetter setTexture0Id:[RZGAssetManager loadTextureNamed:@"W" FromUIImage:letterImage shouldLoadWithMipMapping:YES]];
    
    discLetter.prs.pz = mainZ;
    
    [self.modelController addModel:disc];
    [self.modelController addModel:discLetter];
    
    [disc.prs setRotationConstantToVector:GLKVector3Make(0.0f, 1.0f, 0.0f)];
    [discLetter.prs setRotationConstantToVector:GLKVector3Make(0.0f, 1.0f, 0.0f)];
}

+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
{
    NSDictionary *attDir = @{
                             NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:40.0f],
                             NSForegroundColorAttributeName : [UIColor whiteColor]
                             };
    CGSize textSize = [text sizeWithAttributes:attDir];
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(image.size.width / 2.0f - textSize.width / 2.0f, image.size.height / 2.0f - textSize.height / 2.0f, textSize.width, textSize.height);
    [[UIColor whiteColor] set];
 
    
    [text drawInRect:rect withAttributes:attDir];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"TOUCHED DOWN!!!!");
}
@end
