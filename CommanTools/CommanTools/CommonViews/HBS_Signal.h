//
//  HBS_Signal.h
//  HBSDrone
//
//  Created by Arvin on 2017/8/1.
//  Copyright © 2017年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBS_Signal : UIView

- (id)initWithFrame:(CGRect)frame maxSignal:(int)signal;

- (void)setSignal:(int)curSignal;

@end
