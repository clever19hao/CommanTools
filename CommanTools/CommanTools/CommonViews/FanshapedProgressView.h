//
//  FanshapedProgressView.h
//  HBSDrone
//
//  Created by Arvin on 2018/1/3.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FanshapedProgressView : UIView

@property (nonatomic,strong) UIColor *coverColor;

- (void)setProgress:(float)progress ispaused:(BOOL)ispaused;

@end
