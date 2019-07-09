//
//  ViewController.m
//  TestGestures
//
//  Created by Сергей Лепинин on 19/03/2019.
//  Copyright © 2019 Сергей Лепинин. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView* testView;
@property (assign, nonatomic) CGFloat testViewScale;
@property (assign, nonatomic) CGFloat testViewRotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 50, CGRectGetMidY(self.view.bounds) - 50, 100, 100)];
    view.backgroundColor = [self randomColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.testView = view;
    
    [self.view addSubview:view];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:doubleTapGesture];
    
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
 
    UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    pinchGesture.delegate = self;
    
    [self.view addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer* rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    
    rotateGesture.delegate = self;
    
    [self.view addGestureRecognizer:rotateGesture];
 
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    
    [self.view addGestureRecognizer:panGesture];
    
    //swipes
    UISwipeGestureRecognizer* horizontSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeHorizont:)];
    horizontSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    horizontSwipeGesture.delegate = self;
    
    [self.view addGestureRecognizer:horizontSwipeGesture];
    
    UISwipeGestureRecognizer* verticalSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeVertical:)];
    verticalSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    verticalSwipeGesture.delegate = self;
    
    [self.view addGestureRecognizer:verticalSwipeGesture];
    
}

#pragma mark - Methods

- (UIColor*) randomColor {
    
    CGFloat r = (float)(arc4random() % 256) / 255.f;
    CGFloat g = (float)(arc4random() % 256) / 255.f;
    CGFloat b = (float)(arc4random() % 256) / 255.f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
    
}

#pragma mark - Gestures

- (void) handleTap:(UITapGestureRecognizer*) tapGesture {
    
    NSLog(@"tap: %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    
    self.testView.backgroundColor = [self randomColor];
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1.2f, 1.2f);
    
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.testView.transform = newTransform;
                     }];
    
    self.testViewScale = 1.2f;
}

- (void) handleDoubleTap:(UITapGestureRecognizer*) tapGesture {
    
    NSLog(@"double tap: %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 0.8f, 0.8f);
    
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.testView.transform = newTransform;
                     }];
    
    self.testViewScale = 0.8f;
}

- (void) handlePinch:(UIPinchGestureRecognizer*) pinchGesture {
    
    NSLog(@"handle pinch: %1.3f", pinchGesture.scale);
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewScale = 1.f;
    }
    
    CGFloat newScale = 1.f + pinchGesture.scale - self.testViewScale;
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
 
    self.testView.transform = newTransform;
    self.testViewScale = pinchGesture.scale;
}

- (void) handleRotate:(UIRotationGestureRecognizer*) rotateGesture {
    
    NSLog(@"handle rotate %1.3f", rotateGesture.rotation);
    
    if (rotateGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewRotation = 0.f;
    }
    
    CGFloat newRotation = rotateGesture.rotation - self.testViewRotation;
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, newRotation);
    
    self.testView.transform = newTransform;
    self.testViewRotation = rotateGesture.rotation;
    
}

- (void) handlePan:(UIPanGestureRecognizer*) panGesture {
    
    //NSLog(@"handle pan %1.3f", panGesture.ro);
    
    self.testView.center = [panGesture locationInView:self.view];
    
}

- (void) handleSwipeHorizont:(UISwipeGestureRecognizer*) swipeGesture {
    
    NSLog(@"horizont swipe");
    
}

- (void) handleSwipeVertical:(UISwipeGestureRecognizer*) swipeGesture {
    
    NSLog(@"vert swipe");
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    
    
    return YES;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
 
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]];
    
}

@end
