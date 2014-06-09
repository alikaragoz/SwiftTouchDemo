//
//  TouchDelayGestureRecognizer.m
//  SwiftTouchDemo
//
//  Created by Ali Karagoz on 09/06/14.
//  Copyright (c) 2014 Ali Karagoz. All rights reserved.
//

#import "TouchDelayGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface TouchDelayGestureRecognizer ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TouchDelayGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (!self) {
        return nil;
    }
    
    self.delaysTouchesBegan = YES;
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(fail) userInfo:nil repeats:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self fail];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self fail];
}

- (void)fail {
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
    [_timer invalidate];
    _timer = nil;
}

@end
