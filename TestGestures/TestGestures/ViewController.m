//
//  ViewController.m
//  TestGestures
//
//  Created by Сергей Лепинин on 19/03/2019.
//  Copyright © 2019 Сергей Лепинин. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) UIView* testView;
@property (assign, nonatomic) CGFloat testViewScale;

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
    
    [self.view addGestureRecognizer:pinchGesture];
    
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

@end
