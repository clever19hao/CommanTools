//
//  PopViewTool.m
//  HBSDrone
//
//  Created by Arvin on 2018/3/21.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "PopViewTool.h"

static NSMutableArray *popArray = nil;

@interface PopViewTool ()

@property (nonatomic,strong) UIControl *control;
@property (nonatomic,assign) AnimateStyle style;

@end

@implementation PopViewTool

+ (void)initialize {
    
    popArray = [NSMutableArray arrayWithCapacity:1];
}

- (void)dealloc {
    
    NSLog(@"%@ 销毁",NSStringFromClass([self class]));
}

- (id)init {
    if (self = [super init]) {
        _pressBackgroundDismiss = YES;
    }
    return self;
}

- (void)setPressBackgroundDismiss:(BOOL)pressBackgroundDismiss {
    
    if (_pressBackgroundDismiss == pressBackgroundDismiss) {
        return;
    }
    
    _pressBackgroundDismiss = pressBackgroundDismiss;
    
    [_control removeTarget:self action:@selector(pressBg) forControlEvents:UIControlEventTouchUpInside];
    
    if (_pressBackgroundDismiss) {
        [_control addTarget:self action:@selector(pressBg) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showWithContent:(UIView *)content style:(AnimateStyle)style {
    
    _content = content;
    _style = style;
    [popArray addObject:self];
    
    _control = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _control.backgroundColor = _backgroundColor;
    if (_pressBackgroundDismiss) {
        [_control addTarget:self action:@selector(pressBg) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:_control];

    [_control addSubview:content];
    
    CGRect rect = content.frame;
    
    if (style == animate_downUp) {
        
        content.frame = CGRectMake(rect.origin.x, _control.frame.size.height, rect.size.width, rect.size.height);
        _control.alpha = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
            content.frame = rect;
            _control.alpha = 1;
        }];
    }
    else if (style == animate_rightLeft) {
        
        content.frame = CGRectMake(_control.frame.size.width, rect.origin.y, rect.size.width, rect.size.height);
        _control.alpha = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
            content.frame = rect;
            _control.alpha = 1;
        }];
    }
    else if (style == animate_center) {
        
        content.frame = rect;
        _control.alpha = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
            _control.alpha = 1;
        }];
    }
}

- (void)resumeShow {
    
    if (![popArray containsObject:self]) {
        [self showWithContent:_content style:_style];
    }
}

- (void)pressBg {
    
    [self dismiss];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _control.alpha = 0;
        CGRect rect = _content.frame;
        
        if (_style == animate_downUp) {
            _content.frame = CGRectMake(rect.origin.x, _control.frame.size.height, rect.size.width, rect.size.height);
        }
        else if (_style == animate_rightLeft) {
           _content.frame = CGRectMake(_control.frame.size.width, rect.origin.y, rect.size.width, rect.size.height);
        }
    } completion:^(BOOL finished) {
        
        [_control removeFromSuperview];
        if (finished) {
            if (self.dismissBlock) {
                self.dismissBlock();
            }
        }
    }];
    
    [popArray removeObject:self];
}

- (void)dismissNoAnimate {
    
    [popArray removeObject:self];
    
    [_control removeFromSuperview];
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
@end
