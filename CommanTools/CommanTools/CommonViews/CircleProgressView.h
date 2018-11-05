//
//  CircleProgressView.h
//  HBSDrone
//
//  Created by Arvin on 2018/1/8.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView

@property (nonatomic,strong) UIColor *progressColor;

//0等待下载 1正在下载 2暂停
- (void)setProgress:(float)progress status:(int)status;

@end
