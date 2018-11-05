//
//  AnimateView.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/11.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "AnimateView.h"

@implementation AnimateView
{
    CGRect goalFrame;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        goalFrame = frame;
    }
    return self;
}

- (void)show {
    
    CGRect rect = self.superview.frame;
    
    if (_animate == AnimateFromBottom) {
        
        self.frame = CGRectMake(self.frame.origin.x, rect.size.height, self.frame.size.width, self.frame.size.height);
        
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = self->goalFrame;
        }];
    }
}

- (void)dismiss {
    
    CGRect rect = self.superview.frame;
    
    if (_animate == AnimateFromBottom) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(self.frame.origin.x, rect.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    }
    else {
        [self removeFromSuperview];
    }
}

@end
