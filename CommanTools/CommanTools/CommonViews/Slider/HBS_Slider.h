//
//  HBS_Slider.h
//  Vividia
//
//  Created by Arvin on 2017/4/25.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBS_Slider : UIView

@property (nonatomic,assign) int decimalLen;//小数点长度
@property (nonatomic,strong) NSString *title;
@property (nonatomic,readonly) int value;
@property (nonatomic,readonly) int minimumValue;
@property (nonatomic,readonly) int maximumValue;

@property (nonatomic,assign) float unit;//默认1

@property (nonatomic,copy) void (^sliderValueChange)(HBS_Slider *slider);

- (void)setValue:(int)value minValue:(int)minValue maxValue:(int)maxValue;

@end
