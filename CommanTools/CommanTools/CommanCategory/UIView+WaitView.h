//
//  UIView+WaitView.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/11/7.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WaitView)

- (void)setTip:(NSString *)tip;
- (void)hideTip;

- (void)setWaitColor:(UIColor *)color;//默认白色
- (void)setWaitSize:(CGSize)size;//默认CGSize(20,20)
- (void)setWaitPoint:(CGPoint)point;//默认中心

- (void)showWait;
- (void)hideWait;
- (void)showWaitUntilDeday:(NSTimeInterval)delay;
- (BOOL)isWaiting;

@end
