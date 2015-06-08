//
//  dropitBehavior.m
//  dropit
//
//  Created by Mendy Krinsky on 10/28/14.
//  Copyright (c) 2014 Mendy Krinsky. All rights reserved.
//

#import "dropitBehavior.h"

@interface dropitBehavior()
@property (strong, nonatomic) UIDynamicItemBehavior *animationOptions;


@end

@implementation dropitBehavior
- (instancetype) init
{
    self = [super init];
    if (self) {
        [self addChildBehavior:self.gravity];
        [self addChildBehavior:self.collider];
        [self addChildBehavior:self.animationOptions];
        
    }
    return self;
}
-(void) addItem: (id <UIDynamicItem>) item
{
    [self.gravity addItem:item];
    [self.collider addItem:item];
    [self.animationOptions addItem:item];
    
}
-(void) removeItem: (id <UIDynamicItem>) item
{
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
    [self.animationOptions removeItem:item];
}
- (UIDynamicItemBehavior *) animationOptions
{
    if (!_animationOptions) {
        _animationOptions = [[UIDynamicItemBehavior alloc]init];
        _animationOptions.allowsRotation = NO;
    }
    return _animationOptions;
}
- (UIGravityBehavior *) gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc]init];
        _gravity.magnitude = 0.9;
    }
    return _gravity;
}
- (UICollisionBehavior *) collider
{
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc]init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collider;
}

@end
