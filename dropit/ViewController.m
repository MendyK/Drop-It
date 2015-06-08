//
//  ViewController.m
//  dropit
//
//  Created by Mendy Krinsky on 10/28/14.
//  Copyright (c) 2014 Mendy Krinsky. All rights reserved.
//

#import "ViewController.h"
#import "dropitBehavior.h"
#import "BezierPathView.h"

@interface ViewController ()<UIDynamicAnimatorDelegate>
@property (strong, nonatomic) IBOutlet BezierPathView *dropView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) dropitBehavior *dropItBehave;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIView *droppingView;

@property (strong, nonatomic) UIGravityBehavior *behavior;
@end

@implementation ViewController

static const CGSize DROP_SIZE = { 40, 40 };
- (dropitBehavior *) dropItBehave
{
    if (!_dropItBehave) {
        _dropItBehave = [dropitBehavior new];
        [self.animator addBehavior:_dropItBehave];
    }
    return _dropItBehave;
}
- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRows];
}
- (BOOL) removeCompletedRows
{
    NSMutableArray *dropsToRemove = [NSMutableArray new];
    
    for (CGFloat y = self.dropView.bounds.size.height-DROP_SIZE.height/2; y > 0; y -= DROP_SIZE.height)
    {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [NSMutableArray new];
        for (CGFloat x = DROP_SIZE.width/2; x <= self.dropView.bounds.size.width-DROP_SIZE.width/2; x += DROP_SIZE.width)
        {
            UIView *hitView = [self.dropView hitTest:CGPointMake(x, y) withEvent:NULL];
            
            if ([hitView superview] == self.dropView)
            {
                [dropsFound addObject:hitView];
            }
            else
            {
                rowIsComplete = NO;
                break;
            }
        }
            if (![dropsFound count]) break;
            if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
        
    }
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropItBehave removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
    }
    return NO;
}
- (void) animateRemovingDrops: (NSArray *) dropsToMove
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         for (UIView *drop in dropsToMove) {
                             int x = (arc4random()%(int)(self.dropView.bounds.size.width *5)) - (int) self.dropView.bounds.size.width *2;
                             int y = self.dropView.bounds.size.height;
                             drop.center = CGPointMake(x, -y);
                         }
                     }
                     completion:^(BOOL finished){
                         [dropsToMove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}
- (UIDynamicAnimator *) animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.dropView];
        _animator.delegate = self;
    }
    return _animator;
}
- (UIGravityBehavior *) behavior
{
    if (!_behavior) {
        _behavior = [[UIGravityBehavior alloc]init];
        [self.animator addBehavior:_behavior];
    }
    return _behavior;
}
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}
- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    CGPoint gesturePoint = [sender locationInView:self.dropView];

    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self attachDroppingViewToPoint:gesturePoint];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        //
        self.attachment.anchorPoint = gesturePoint;
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        //remove attachment, stop animation
        [self.animator removeBehavior:self.attachment];
        
        //get rid of line
        self.dropView.path = nil;
    }
        
}
- (void) attachDroppingViewToPoint: (CGPoint) anchorPoint
{
    if (self.droppingView) {
        //create new attachment bahavior
        self.attachment = [[UIAttachmentBehavior alloc]initWithItem:self.droppingView attachedToAnchor:anchorPoint];
        UIView *droppingView = self.droppingView;
        __weak ViewController *weakSelf = self;
        //every time it animates, it will call this code
        self.attachment.action = ^{
            UIBezierPath *path = [[UIBezierPath alloc]init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:droppingView.center];
            weakSelf.dropView.path = path;
        };
        //make user not be able to do it again
        self.droppingView = nil;
        [self.animator addBehavior:self.attachment];
        
    }
    
}
- (void) drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random() % (int) self.view.bounds.size.width / DROP_SIZE.width);
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc]initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    
    [self.dropView addSubview:dropView];
    
    self.droppingView = dropView;
    
    [self.dropItBehave addItem:dropView];
    

}
- (UIColor *) randomColor
{
    switch (arc4random()%5) {
        case 0:
            return [UIColor greenColor];
            
        case 1:
            return [UIColor redColor];
        case 2:
            return [UIColor orangeColor];
        case 3:
            return [UIColor blueColor];
        case 4:
            return [UIColor purpleColor];
        default:
            break;
    }
    return [UIColor blackColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
