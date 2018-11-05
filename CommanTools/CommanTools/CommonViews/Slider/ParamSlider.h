//
//  ParamSlider.h
//  HBSDrone
//
//  Created by Arvin on 2018/5/14.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParamSlider : UIView

@property (nonatomic,copy) void (^valueChanged)(int value);
@property (nonatomic,copy) void (^valueEnd)(int value);

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *titleDescribe;

@property (nonatomic,strong) NSString *unit;//m

@property (nonatomic,assign) int minValue;
@property (nonatomic,assign) int maxValue;
@property (nonatomic,assign) int curValue;

@property (nonatomic,assign) BOOL isShowSmallAdjust;

@end
