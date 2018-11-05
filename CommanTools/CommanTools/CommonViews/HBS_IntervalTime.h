//
//  HBS_IntervalTime.h
//  Vividia
//
//  Created by Arvin on 2017/7/24.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBS_IntervalTime : UIView

@property (nonatomic,assign) NSTimeInterval duration;//每张图片的播放速度
@property (nonatomic,assign) NSInteger number;//一次动画的图片数量 默认10

- (void)startAnimate;

- (BOOL)isAnimating;

- (void)stopAnimate;

@end
