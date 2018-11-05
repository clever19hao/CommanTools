//
//  HBS_Slider.m
//  Vividia
//
//  Created by Arvin on 2017/4/25.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "HBS_Slider.h"

@implementation HBS_Slider
{
    UILabel *lbTitle;
    
    UILabel *lbMinValue;
    UILabel *lbMaxValue;
    UILabel *lbCurValue;
    
    UISlider *slider;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _unit = 1;
        
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*0.4)];
        lbTitle.text = nil;
        lbTitle.textColor = [UIColor blackColor];
        lbTitle.font = [UIFont systemFontOfSize:18];
        lbTitle.adjustsFontSizeToFitWidth = YES;
        lbTitle.numberOfLines = 0;
        [self addSubview:lbTitle];
        
        lbMinValue = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lbTitle.frame), frame.size.width*0.333, frame.size.height*0.2)];
        lbMinValue.text = nil;
        lbMinValue.textColor = [UIColor blackColor];
        lbMinValue.font = [UIFont systemFontOfSize:14];
        lbMinValue.adjustsFontSizeToFitWidth = YES;
        lbMinValue.numberOfLines = 0;
        [self addSubview:lbMinValue];
        
        lbCurValue = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width*0.333, CGRectGetMaxY(lbTitle.frame), frame.size.width*0.334, frame.size.height*0.2)];
        lbCurValue.text = nil;
        lbCurValue.textAlignment = NSTextAlignmentCenter;
        lbCurValue.textColor = [UIColor blackColor];
        lbCurValue.font = [UIFont systemFontOfSize:14];
        lbCurValue.adjustsFontSizeToFitWidth = YES;
        lbCurValue.numberOfLines = 0;
        [self addSubview:lbCurValue];
        
        lbMaxValue = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - frame.size.width*0.333, CGRectGetMaxY(lbTitle.frame), frame.size.width*0.333, frame.size.height*0.2)];
        lbMaxValue.text = nil;
        lbMaxValue.textColor = [UIColor blackColor];
        lbMaxValue.textAlignment = NSTextAlignmentRight;
        lbMaxValue.font = [UIFont systemFontOfSize:14];
        lbMaxValue.adjustsFontSizeToFitWidth = YES;
        lbMaxValue.numberOfLines = 0;
        [self addSubview:lbMaxValue];
        
        slider = [[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lbMaxValue.frame), frame.size.width, frame.size.height*0.4)];
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        slider.minimumValue = 0;
        slider.maximumValue = 0;
        slider.value = 0;
        [self addSubview:slider];
    }
    
    return self;
}

- (void)sliderValueChanged:(UISlider *)sender {
    
    _value = (int)sender.value;
    
    NSString *format = [NSString stringWithFormat:@"%%.%df",_decimalLen];
    lbCurValue.text = [NSString stringWithFormat:format,_value*_unit];
    
    if ([lbCurValue.text isEqualToString:@"-0"]) {
        lbCurValue.text = @"0";
    }
    
    if (self.sliderValueChange) {
        self.sliderValueChange(self);
    }
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    lbTitle.text = title;
}

- (void)setValue:(int)value minValue:(int)minValue maxValue:(int)maxValue {
    
    _minimumValue = minValue;
    _maximumValue = maxValue;
    _value = value;
    
    NSString *format = [NSString stringWithFormat:@"%%.%df",_decimalLen];
    
    lbMinValue.text = [NSString stringWithFormat:format,minValue*_unit];
    lbMaxValue.text = [NSString stringWithFormat:format,maxValue*_unit];
    lbCurValue.text = [NSString stringWithFormat:format,value*_unit];
    
    slider.minimumValue = minValue;
    slider.maximumValue = maxValue;
    slider.value = value;
}

@end
