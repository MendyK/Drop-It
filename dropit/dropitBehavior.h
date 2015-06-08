//
//  dropitBehavior.h
//  dropit
//
//  Created by Mendy Krinsky on 10/28/14.
//  Copyright (c) 2014 Mendy Krinsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dropitBehavior : UIDynamicBehavior
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;



-(void) addItem: (id <UIDynamicItem>) item;
-(void) removeItem: (id <UIDynamicItem>) item;
@end
