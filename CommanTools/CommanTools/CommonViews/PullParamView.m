//
//  PullParamView.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/7.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "PullParamView.h"

@interface PullParamView ()

@property (nonatomic,strong) UIView *originView;
@property (nonatomic,strong) UIImageView *pullImageView;

@end

@implementation PullParamView


- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.alpha = 0;
        
        _originView = [[UIView alloc] init];
        _originView.backgroundColor = [UIColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:0.9];
        _originView.alpha = 0;
        
        _pullImageView = [[UIImageView alloc] init];
        _pullImageView.image = [UIImage imageNamed:@"HY012_Camera_pull_left_bg"];
        _pullImageView.clipsToBounds = YES;
        _pullImageView.userInteractionEnabled = YES;
        
        [self addSubview:_originView];
        [self addSubview:_pullImageView];
    }
    
    return self;
}

- (id)init {
    
    return [self initWithFrame:CGRectZero];
}

- (UIView *)pullContentView {
    
    return _pullImageView;
}

- (void)show {
    
    self.alpha = 1;
    self.originView.alpha = 1;
    _originView.frame = _originFrame;
    
    if (_direction == PullFromLeft) {
        _pullImageView.frame = CGRectMake(_originFrame.size.width, 0, 0, _pullFrame.size.height);
    }
    else if (_direction == PullFromRight) {
        _pullImageView.frame = CGRectMake(self.frame.size.width - _originFrame.size.width, 0, 0, _pullFrame.size.height);
    }
    __weak PullParamView *weakself = self;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        weakself.pullImageView.frame = weakself.pullFrame;
        
    }];
}

- (void)dismiss:(void (^)(void))complete {
    
    CGRect goal = CGRectZero;
    CGRect origin_goal = CGRectZero;
    if (_direction == PullFromLeft) {
        goal = CGRectMake(_originFrame.size.width, 0, 0, _pullFrame.size.height);
        origin_goal = CGRectMake(-self.originView.frame.size.width, 0, self.originView.frame.size.width, self.originView.frame.size.height);
    }
    else if (_direction == PullFromRight) {
        goal = CGRectMake(self.frame.size.width - _originFrame.size.width, 0, 0, _pullFrame.size.height);
        origin_goal = CGRectMake(self.frame.size.width, 0, self.originView.frame.size.width, self.originView.frame.size.height);
    }
    
    __weak PullParamView *weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakself.pullImageView.frame = goal;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (complete) {
            complete();
        }
    }];
}

@end
