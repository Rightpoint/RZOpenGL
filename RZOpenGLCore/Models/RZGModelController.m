//
//  RZGModelController.m
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGModelController.h"
#import "RZGModel.h"

@interface RZGModelController()

@property (nonatomic, strong) NSMutableArray *mainModelArray;

@end

@implementation RZGModelController

- (void)addModel:(RZGModel *)model
{
    if(!self.mainModelArray) {
        self.mainModelArray = [NSMutableArray array];
    }
    
    [self.mainModelArray addObject:model];
}

- (void)removeModel:(RZGModel *)model
{
    [self.mainModelArray removeObject:model];
}

- (void)removeAllModels
{
    if ( self.mainModelArray ) {
        [self.mainModelArray removeAllObjects];
    }
}

- (void)addCommandToAllModels:(RZGCommand *)command
{
    for(RZGModel *model in self.mainModelArray) {
        [model addCommand:command];
    }
}

- (void)updateWithTime:(CFTimeInterval)time
{
    for(RZGModel *model in self.mainModelArray) {
        [model updateWithTime:time];
    }
}

- (void)draw
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    for (RZGModel *model in self.mainModelArray) {
        if (!model.isHidden) {
            [model draw];
        }
    }
}

@end
