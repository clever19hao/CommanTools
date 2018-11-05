//
//  UIView+WaitView.m
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/11/7.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "UIView+WaitView.h"
#import <objc/runtime.h>

@implementation UIView (WaitView)

static const char waitViewKey = 'w';
static const char waitViewColorKey = 'c';
static const char waitViewSizeKey = 's';
static const char waitViewPointKey = 'p';
static const char viewTipKey = 't';

- (void)setWaitColor:(UIColor *)color {
    
    objc_setAssociatedObject(self, &waitViewColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIActivityIndicatorView *actView = objc_getAssociatedObject(self, &waitViewKey);
    if (actView) {
        actView.color = color;
    }
}

- (void)setWaitPoint:(CGPoint)point {
    
    objc_setAssociatedObject(self, &waitViewPointKey, [NSValue valueWithCGPoint:point], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIActivityIndicatorView *actView = objc_getAssociatedObject(self, &waitViewKey);
    if (actView) {
        
        actView.center = point;
    }
}

- (void)setWaitSize:(CGSize)size {
    
    objc_setAssociatedObject(self, &waitViewSizeKey, [NSValue valueWithCGSize:size], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIActivityIndicatorView *actView = objc_getAssociatedObject(self, &waitViewKey);
    if (actView) {
        actView.transform = CGAffineTransformScale(CGAffineTransformIdentity, size.width/actView.frame.size.width , size.height/actView.frame.size.height);
    }
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    if (objc_getAssociatedObject(self,&waitViewPointKey)) {
        center = [objc_getAssociatedObject(self,&waitViewPointKey) CGPointValue];
    }
    
    actView.center = center;
}

- (void)showWait {
    
    UIActivityIndicatorView *actView = objc_getAssociatedObject(self, &waitViewKey);
    if (!actView) {
        actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        objc_setAssociatedObject(self, &waitViewKey, actView, OBJC_ASSOCIATION_ASSIGN);
    }
    
    UIColor *color = objc_getAssociatedObject(self, &waitViewColorKey);
    if (color) {
        actView.color = color;
    }
    else {
        actView.color = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1];
    }
    NSValue *sizeValue = objc_getAssociatedObject(self, &waitViewSizeKey);
    if (sizeValue) {
        CGSize size = [sizeValue CGSizeValue];
        actView.transform = CGAffineTransformScale(CGAffineTransformIdentity, size.width/actView.frame.size.width , size.height/actView.frame.size.height);
    }
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    if (objc_getAssociatedObject(self,&waitViewPointKey)) {
        center = [objc_getAssociatedObject(self,&waitViewPointKey) CGPointValue];
    }
    
    actView.center = center;
    
    [self addSubview:actView];
    [actView startAnimating];
    
    self.userInteractionEnabled = NO;
}

- (void)hideWait {
    
    UIActivityIndicatorView *actView = objc_getAssociatedObject(self, &waitViewKey);
    if (actView) {
        [actView stopAnimating];
        [actView removeFromSuperview];
        objc_setAssociatedObject(self, &waitViewKey, nil, OBJC_ASSOCIATION_ASSIGN);
        objc_setAssociatedObject(self, &waitViewColorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &waitViewSizeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &waitViewPointKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.userInteractionEnabled = YES;
}

- (void)showWaitUntilDeday:(NSTimeInterval)delay {
    
    [self showWait];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self hideWait];
    });
}

- (BOOL)isWaiting {
    
    UIActivityIndicatorView *actView = objc_getAssociatedObject(self, &waitViewKey);
    if (actView) {
        return YES;
    }
    
    return NO;
}

- (void)setTip:(NSString *)tip {
    
    UILabel *lbTip = objc_getAssociatedObject(self, &viewTipKey);
    if (!lbTip) {
        
        lbTip = [[UILabel alloc] init];
        lbTip.textAlignment = NSTextAlignmentCenter;
        lbTip.textColor = [UIColor lightGrayColor];
        lbTip.font = [UIFont boldSystemFontOfSize:16];
        lbTip.numberOfLines = 0;
        lbTip.adjustsFontSizeToFitWidth = YES;
        [self addSubview:lbTip];
        
        objc_setAssociatedObject(self, &viewTipKey, lbTip, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    CGRect rect = [tip boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lbTip.font} context:nil];
    lbTip.frame = CGRectMake(0, 0, rect.size.width + 0.5, rect.size.height + 1);
    lbTip.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    lbTip.text = tip;
}

- (void)hideTip {
    
    UILabel *lbTip = objc_getAssociatedObject(self, &viewTipKey);
    [lbTip removeFromSuperview];
    
    objc_setAssociatedObject(self, &viewTipKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
