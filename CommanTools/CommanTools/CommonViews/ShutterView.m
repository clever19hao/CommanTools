//
//  ShutterView.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/13.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "ShutterView.h"
#import <AVFoundation/AVFoundation.h>

@interface ShutterView () <CAAnimationDelegate>
@end

@implementation ShutterView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (id)init {
    
    return [self initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
}

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self removeFromSuperview];
}

+ (void)shutter {
    
    ShutterView *stview = [[ShutterView alloc] init];
    
    [[UIApplication sharedApplication].keyWindow addSubview:stview];
    
    [UIView animateWithDuration:0.3 animations:^{
        stview.alpha = 0;
    } completion:^(BOOL finished) {
        [stview removeFromSuperview];
    }];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    AudioServicesPlaySystemSound(1108);
}

+ (void)waitWithNumber:(int)number {
    
    ShutterView *stview = [[ShutterView alloc] init];
    stview.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:stview];
    
    UILabel *lbNumber = [[UILabel alloc] initWithFrame:CGRectMake((stview.frame.size.width - 200)/2, (stview.frame.size.height - 200)/2, 200, 200)];
    lbNumber.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    lbNumber.font = [UIFont boldSystemFontOfSize:200];
    lbNumber.adjustsFontSizeToFitWidth = YES;
    lbNumber.layer.shadowColor = [UIColor blackColor].CGColor;
    lbNumber.layer.shadowOpacity = 1;
    lbNumber.layer.shadowOffset = CGSizeMake(0, 0);
    lbNumber.textAlignment = NSTextAlignmentCenter;
    lbNumber.text = [NSString stringWithFormat:@"%d",number];
    [stview addSubview:lbNumber];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @(1);
    scale.toValue = @(0.2);
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(1);
    opacity.toValue = @(0.4);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.5;
    group.animations = @[scale,opacity];
    group.delegate = stview;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;

    [lbNumber.layer addAnimation:group forKey:nil];
}

+ (void)shutterWithNumber:(int)number hasSound:(BOOL)hasSound {
    
    ShutterView *stview = [[ShutterView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:stview];
    
    UILabel *lbNumber = [[UILabel alloc] initWithFrame:CGRectMake((stview.frame.size.width - 200)/2, (stview.frame.size.height - 200)/2, 200, 200)];
    lbNumber.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    lbNumber.font = [UIFont boldSystemFontOfSize:200];
    lbNumber.adjustsFontSizeToFitWidth = YES;
    lbNumber.textAlignment = NSTextAlignmentCenter;
    lbNumber.text = [NSString stringWithFormat:@"%d",number];
    lbNumber.layer.shadowColor = [UIColor blackColor].CGColor;
    lbNumber.layer.shadowOpacity = 1;
    lbNumber.layer.shadowOffset = CGSizeMake(0, 0);
    [stview addSubview:lbNumber];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @(1);
    scale.toValue = @(0.2);
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(1);
    opacity.toValue = @(0.4);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.5;
    group.animations = @[scale,opacity];
    group.delegate = stview;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [lbNumber.layer addAnimation:group forKey:nil];
    
    if (hasSound) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
        AudioServicesPlaySystemSound(1108);
    }
}

@end
