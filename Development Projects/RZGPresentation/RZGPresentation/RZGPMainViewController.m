//
//  RZGPMainViewController.m
//  RZGPresentation
//
//  Created by John Stricker on 9/17/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZGPMainViewController.h"
#import "RZGBMFontHeaders.h"
#import "RZGPSlide.h"

static float const kSlideFadeDuration = 0.2f;

@interface RZGPMainViewController ()

@property (nonatomic, strong) RZGBMFontModel *titleFontModel;
@property (nonatomic, strong) RZGBMFontModel *bodyFontModel;
@property (nonatomic, strong) RZGModel *cube;
@property (nonatomic, strong) RZGModel *imageQuad;
@property (nonatomic, strong) NSMutableArray *cubeArray;
@property (nonatomic, strong) NSArray *slides;
@property (nonatomic, assign) NSInteger currentSlideIndex;
@end

@implementation RZGPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:self.view.bounds.size PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    
    [self.glmgr loadBitmapFontShaderAndSettings];
    
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0)];
    
    RZGModel *cube = [[RZGModel alloc] initWithModelFileName:@"cube" UseDefaultSettingsInManager:self.glmgr];
    [cube setTexture0Id:[RZGAssetManager loadTexture:@"rzMetal" ofType:@"png" shouldLoadWithMipMapping:YES]];
    cube.prs.px = 0.0f;
    cube.prs.py = -0.35f;
    cube.prs.pz = -6.0f;
    RZGCommand *rotate = [[RZGCommand alloc] initWithCommandEnum:kRZGCommand_setConstantRotation Target:GLKVector4MakeWith3f(0.1f, -0.25f, 0.0f) Duration:0.5f IsAbsolute:YES Delay:0.2f];
    [cube addCommand:rotate];
    [self.modelController addModel:cube];
    self.cube = cube;
    
    self.imageQuad = [[RZGModel alloc] initWithModelFileName:@"quad" UseDefaultSettingsInManager:self.glmgr];
    self.imageQuad.isHidden = YES;
    self.imageQuad.prs.pz = -2.0f;
    [self.modelController addModel:self.imageQuad];
    
    self.titleFontModel = [[RZGBMFontModel alloc] initWithName:@"redHNFont" BMfontData:[[RZGBMFontData alloc] initWithFontFile:@"redHNFont"] UseGLManager:self.glmgr];
    [self.titleFontModel setTexture0Id:[RZGAssetManager loadTexture:@"redHNFont" ofType:@"png" shouldLoadWithMipMapping:YES]];
    
    [self.titleFontModel setupWithCharMax:50.0f];
    self.titleFontModel.centerHorizontal = YES;
    [self.titleFontModel updateWithText:@"OpenGL & Metal"];
    self.titleFontModel.prs.pz = -1.5f;
    self.titleFontModel.prs.py = 0.4f;
    [self.modelController addModel:self.titleFontModel];
    
    self.bodyFontModel = [[RZGBMFontModel alloc] initWithName:@"whiteHNFont" BMfontData:[[RZGBMFontData alloc] initWithFontFile:@"whiteHNFont"] UseGLManager:self.glmgr];
    [self.bodyFontModel setupWithCharMax:300];
    [self.bodyFontModel setTexture0Id:[RZGAssetManager loadTexture:@"whiteHNFont" ofType:@"png" shouldLoadWithMipMapping:YES]];
    self.bodyFontModel.centerHorizontal = YES;
    self.bodyFontModel.prs.py = 0.25f;
    self.bodyFontModel.prs.pz = -2.8f;
    self.bodyFontModel.alpha = 0.0f;
    [self.modelController addModel:self.bodyFontModel];
    

    
    self.currentSlideIndex = -1;
    [self setupSlides];
}

- (void)addABunchOfCubes
{
    float x = -2.0f;
    float y = 0.0f;
    float xInc = 0.2f;
    float yInc = 0.2f;
    
    self.cubeArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 100; i++ ) {
        RZGModel *cube = [[RZGModel alloc] initWithModelFileName:@"cube" UseDefaultSettingsInManager:self.glmgr];
        [cube setTexture0Id:[RZGAssetManager loadTexture:@"rzMetal128" ofType:@"png" shouldLoadWithMipMapping:YES]];
        cube.prs.pz = -5.0f;
        cube.prs.py = y + yInc * i;
        cube.prs.px = x + xInc * i;
        
        RZGCommand *rotate = [[RZGCommand alloc] initWithCommandEnum:kRZGCommand_setConstantRotation Target:GLKVector4MakeWith3f(0.1f, -0.2f, 0.0f) Duration:0.5f IsAbsolute:YES Delay:0.5];
        [cube addCommand:rotate];
        [self.modelController addModel:cube];
        [self.cubeArray addObject:cube];
    }
}

- (void)setupSlides
{
    self.slides = @[
                    [[RZGPSlide alloc] initWithTitle:@"WWDC WTF?" pictureName:@"wwdc" openGLManager:self.glmgr],
                    [[RZGPSlide alloc] initWithTitle:@"Some tips for starting out" body:@"start with Objective-C++~~Renderer-ViewController-View pattern~~Don't be confused by constants vs. uniforms~~Watch out for magic"],
                    [[RZGPSlide alloc] initWithTitle:@"Thank you!" body:@"~john.stricker@raizlabs.com~~              @jatsway"]
                    ];
}

- (void)removeBunchOfCubes
{
    for (RZGModel *c in self.cubeArray ) {
        [self.modelController removeModel:c];
    }
}

- (RZGCommand *)fadeOutCommand
{
    return [[RZGCommand alloc] initWithCommandEnum:kRZGCommand_alpha Target:GLKVector4MakeWith1f(0.0f) Duration:kSlideFadeDuration IsAbsolute:YES Delay:0.0];
}

- (RZGCommand *)fadeInCommand
{
    return [[RZGCommand alloc] initWithCommandEnum:kRZGCommand_alpha Target:GLKVector4MakeWith1f(1.0f) Duration:kSlideFadeDuration IsAbsolute:YES Delay:0.0];
}


- (void)transitionToSlide:(NSInteger)newSlideIndex
{
    static BOOL firstTransition = NO;
    
    if ( !firstTransition ) {
        firstTransition = YES;
        RZGCommand *cubeCmd = [[RZGCommand alloc] initWithCommandEnum:kRZGCommand_moveTo Target:GLKVector4MakeWith3f(16.0f, -8.5f, -25.0f) Duration:0.2f IsAbsolute:YES Delay:0.0f];
        [self.cube addCommand:cubeCmd];
    }
    
    self.currentSlideIndex = newSlideIndex;
    RZGPSlide *nextSlide = self.slides[newSlideIndex];
    
    RZGCommand *titleFadeCmd = [self fadeOutCommand];
    if ( nextSlide.titleText ) {
        titleFadeCmd.completionBlock = ^{
            [self.titleFontModel updateWithText:nextSlide.titleText];
            [self.titleFontModel addCommand:[self fadeInCommand]];
        };
    }
    [self.titleFontModel addCommand:titleFadeCmd];
    
    RZGCommand *bodyFadeCmd = [self fadeOutCommand];
    if ( nextSlide.bodyText ) {
        bodyFadeCmd.completionBlock = ^{
            [self.bodyFontModel updateWithText:nextSlide.bodyText];
            [self.bodyFontModel addCommand:[self fadeInCommand]];
        };
    }
    [self.bodyFontModel addCommand:bodyFadeCmd];
    
    RZGCommand *imageFadeCmd = [self fadeOutCommand];
    if ( nextSlide.isImageType ) {
        imageFadeCmd.completionBlock = ^{
            self.imageQuad.isHidden = NO;
            self.imageQuad.alpha = 0.0f;
            [self.imageQuad setTexture0Id:(GLuint)nextSlide.textureId];
            [self.imageQuad addCommand:[self fadeInCommand]];
        };
    }
    [self.imageQuad addCommand:imageFadeCmd];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint tPt = [touch locationInView:self.view];
    
    if ( tPt.y > 250.0f && ( tPt.x < 50 || tPt.x > 250 ) ) {
        NSInteger nextIndex = self.currentSlideIndex;
        if ( tPt.x > 250.0f ) {
            ++nextIndex;
        }
        else {
            --nextIndex;
        }
        if ( nextIndex < 0 ) {
            nextIndex = self.slides.count - 1;
        }
        if (nextIndex >= self.slides.count ) {
            nextIndex = 0;
        }
        [self transitionToSlide:nextIndex];
    }
}

@end
