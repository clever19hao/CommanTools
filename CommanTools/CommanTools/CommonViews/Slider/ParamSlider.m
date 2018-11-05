//
//  ParamSlider.m
//  HBSDrone
//
//  Created by Arvin on 2018/5/14.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "ParamSlider.h"

#define OFFSET_X    10
#define CENTER_Y    (self.frame.size.height * 0.5)

#define TITLE_H     (self.frame.size.height * 0.28)
#define ENDPOINT_H  5

@implementation ParamSlider
{
    UILabel *lbTitle;
    UILabel *lbTitleDes;
    
    UILabel *lbMinValue;
    UILabel *lbMaxValue;
    UILabel *lbCurValue;
    
    CAShapeLayer *shape;
    UIButton *btnLeft;
    UIButton *btnRight;
    
    UIImageView *ivTouch;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _unit = @"m";
        
        _isShowSmallAdjust = YES;
        
        shape = [CAShapeLayer layer];
        shape.lineWidth = 2;
        shape.strokeColor = [UIColor whiteColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(OFFSET_X, CENTER_Y - ENDPOINT_H)];
        [path addLineToPoint:CGPointMake(OFFSET_X, CENTER_Y)];
        [path addLineToPoint:CGPointMake(frame.size.width - OFFSET_X, CENTER_Y)];
        [path addLineToPoint:CGPointMake(frame.size.width - OFFSET_X, CENTER_Y - ENDPOINT_H)];
        shape.path = path.CGPath;
        [self.layer addSublayer:shape];
        
        ivTouch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        ivTouch.center = CGPointMake(OFFSET_X, CENTER_Y);
        ivTouch.image = [UIImage imageNamed:@"H117A_Mode_Radius setting_02"];
        ivTouch.highlightedImage = [UIImage imageNamed:@"H117A_Mode_Radius setting_03"];
        [self addSubview:ivTouch];
        
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, CENTER_Y - 10 - TITLE_H, frame.size.width - 5 - 40, TITLE_H)];
        lbTitle.text = nil;
        lbTitle.textColor = [UIColor whiteColor];
        lbTitle.font = [UIFont boldSystemFontOfSize:14];
        lbTitle.adjustsFontSizeToFitWidth = YES;
        lbTitle.numberOfLines = 0;
        [self addSubview:lbTitle];
        
        lbTitleDes = [[UILabel alloc] initWithFrame:CGRectMake(5, CENTER_Y - 10 - TITLE_H, frame.size.width - 5 - 40, TITLE_H)];
        lbTitleDes.text = nil;
        lbTitleDes.textColor = [UIColor whiteColor];
        lbTitleDes.font = [UIFont systemFontOfSize:10];
        lbTitleDes.adjustsFontSizeToFitWidth = YES;
        lbTitleDes.numberOfLines = 0;
        [self addSubview:lbTitleDes];
        
        lbMinValue = [[UILabel alloc] initWithFrame:CGRectMake(0, CENTER_Y + 10, 30, TITLE_H * 0.8)];
        lbMinValue.text = nil;
        lbMinValue.textColor = [UIColor whiteColor];
        lbMinValue.textAlignment = NSTextAlignmentCenter;
        lbMinValue.font = [UIFont boldSystemFontOfSize:10];
        lbMinValue.adjustsFontSizeToFitWidth = YES;
        lbMinValue.numberOfLines = 0;
        [self addSubview:lbMinValue];
        
        lbMaxValue = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 30, CENTER_Y + 10, 30, TITLE_H * 0.8)];
        lbMaxValue.text = nil;
        lbMaxValue.textColor = [UIColor whiteColor];
        lbMaxValue.textAlignment = NSTextAlignmentCenter;
        lbMaxValue.font = [UIFont boldSystemFontOfSize:10];
        lbMaxValue.adjustsFontSizeToFitWidth = YES;
        lbMaxValue.numberOfLines = 0;
        [self addSubview:lbMaxValue];
        
        lbCurValue = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 30, CENTER_Y - 10 - TITLE_H, 30, TITLE_H)];
        lbCurValue.text = nil;
        lbCurValue.textAlignment = NSTextAlignmentCenter;
        lbCurValue.textColor = [UIColor whiteColor];
        lbCurValue.font = [UIFont boldSystemFontOfSize:14];
        lbCurValue.adjustsFontSizeToFitWidth = YES;
        [self addSubview:lbCurValue];
    }
    
    return self;
}

- (CGFloat)lineLeftMargin {
    
    if (_isShowSmallAdjust) {
        
        return btnLeft.frame.size.width + OFFSET_X;
    }
    
    return OFFSET_X;
}

- (CGFloat)lineRightMargin {
    
    if (_isShowSmallAdjust) {
        
        return btnRight.frame.size.width + OFFSET_X;
    }
    
    return OFFSET_X;
}

- (CGFloat)lineWidth {
    
    return self.frame.size.width - [self lineLeftMargin] - [self lineRightMargin];
}

- (void)setIsShowSmallAdjust:(BOOL)isShowSmallAdjust {
    
    if (_isShowSmallAdjust != isShowSmallAdjust) {
        
        _isShowSmallAdjust = isShowSmallAdjust;
        
        [self updateSliderFrame];
    }
}

- (void)updateSliderFrame {
    
    if (_isShowSmallAdjust) {
        
        CGFloat btn_w = 35;
        
        if (!btnLeft) {
            btnLeft = [UIButton buttonWithType:UIButtonTypeSystem];
            btnLeft.frame = CGRectMake(0, (self.frame.size.height - btn_w)/2, btn_w, btn_w);
            [btnLeft setBackgroundImage:[UIImage imageNamed:@"H117Abutton_Reduce the button"] forState:UIControlStateNormal];
            [btnLeft addTarget:self action:@selector(minusValue) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:btnLeft];
        
        if (!btnRight) {
            btnRight = [UIButton buttonWithType:UIButtonTypeSystem];
            btnRight.frame = CGRectMake(self.frame.size.width - btn_w, (self.frame.size.height - btn_w)/2, btn_w, btn_w);
            [btnRight setBackgroundImage:[UIImage imageNamed:@"H117Abutton_add"] forState:UIControlStateNormal];
            [btnRight addTarget:self action:@selector(plusValue) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:btnRight];
    }
    else {
        [btnLeft removeFromSuperview];
        btnLeft = nil;
        
        [btnRight removeFromSuperview];
        btnRight = nil;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake([self lineLeftMargin], CENTER_Y - ENDPOINT_H)];
    [path addLineToPoint:CGPointMake([self lineLeftMargin], CENTER_Y)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - [self lineRightMargin], CENTER_Y)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - [self lineRightMargin], CENTER_Y - ENDPOINT_H)];
    
    shape.path = path.CGPath;
    
    ivTouch.center = CGPointMake([self lineLeftMargin], CENTER_Y);
    
    CGSize tSize = [lbTitle.text sizeWithAttributes:@{NSFontAttributeName:lbTitle.font}];
    if (tSize.width > [self lineWidth] * 0.5) {
        lbTitle.frame = CGRectMake([self lineLeftMargin] - OFFSET_X/2, 0, [self lineWidth] * 0.5 + 0.5, TITLE_H);
    }
    else {
        lbTitle.frame = CGRectMake([self lineLeftMargin] - OFFSET_X/2, 0, tSize.width + 0.5, TITLE_H);
    }
    
    lbTitleDes.frame = CGRectMake(CGRectGetMaxX(lbTitle.frame) + 3, 0,[self lineWidth]*0.6 - 30 - 5, TITLE_H);
    
    lbMinValue.frame = CGRectMake([self lineLeftMargin] - OFFSET_X/2, CENTER_Y + 10, 30, TITLE_H * 0.8);
    
    lbMaxValue.frame = CGRectMake(self.frame.size.width - [self lineRightMargin] - 30 + OFFSET_X/2, CENTER_Y + 10, 30, TITLE_H * 0.8);
    
    lbCurValue.frame = CGRectMake(self.frame.size.width - [self lineRightMargin] - 30 + OFFSET_X/2, CENTER_Y - 10 - TITLE_H, 30, TITLE_H);
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    lbTitle.text = _title;
    
    [self updateSliderFrame];
}

- (void)setTitleDescribe:(NSString *)titleDescribe {
    
    _titleDescribe = titleDescribe;
    
    lbTitleDes.text = titleDescribe;
    
    [self updateSliderFrame];
}

- (void)setMinValue:(int)minValue {
    
    _minValue = minValue;
    
    lbMinValue.text = [NSString stringWithFormat:@"%d%@",_minValue,_unit];
}

- (void)setMaxValue:(int)maxValue {
    
    _maxValue = maxValue;
    
    lbMaxValue.text = [NSString stringWithFormat:@"%d%@",_maxValue,_unit];
}

- (void)setCurValue:(int)curValue {
    
    _curValue = curValue;
    
    lbCurValue.text = [NSString stringWithFormat:@"%d%@",_curValue,_unit];
    
    ivTouch.center = CGPointMake([self lineLeftMargin] + [self lineWidth]*(_curValue - _minValue)/(_maxValue - _minValue), CENTER_Y);
}

- (void)minusValue {
    
    if (_curValue <= _minValue) {
        return;
    }
    
    self.curValue = _curValue - 1;
    
    if (_valueEnd) {
        self.valueEnd(_curValue);
    }
}

- (void)plusValue {
    
    if (_curValue >= _maxValue) {
        return;
    }
    
    self.curValue = _curValue + 1;
    
    if (_valueEnd) {
        self.valueEnd(_curValue);
    }
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    
    CGPoint p = [touch locationInView:self];
    
    if (p.x < ivTouch.center.x - 20 || p.x >  ivTouch.center.x + 20) {
        return;
    }
    
    ivTouch.center = CGPointMake(p.x, CENTER_Y);
    ivTouch.highlighted = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!ivTouch.isHighlighted) {
        return;
    }
    
    UITouch *touch = touches.anyObject;
    
    CGPoint p = [touch locationInView:self];
    
    if (p.x < [self lineLeftMargin]) {
        ivTouch.center = CGPointMake([self lineLeftMargin], CENTER_Y);
    }
    else if (p.x > self.frame.size.width - [self lineRightMargin]) {
        
        ivTouch.center = CGPointMake(self.frame.size.width - [self lineRightMargin], CENTER_Y);
    }
    else {
        ivTouch.center = CGPointMake(p.x, CENTER_Y);
    }
    
    float v = _minValue + (_maxValue - _minValue) * (ivTouch.center.x - [self lineLeftMargin]) / [self lineWidth];
    
    _curValue = roundf(v);
    
    lbCurValue.text = [NSString stringWithFormat:@"%d%@",_curValue,_unit];
    
    if (_valueChanged) {
        self.valueChanged(_curValue);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!ivTouch.isHighlighted) {
        return;
    }
    [self endMove];
    ivTouch.highlighted = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!ivTouch.isHighlighted) {
        return;
    }
    [self endMove];
    ivTouch.highlighted = NO;
}

- (void)endMove {
    
    if (ivTouch.center.x < [self lineLeftMargin]) {
        ivTouch.center = CGPointMake([self lineLeftMargin], CENTER_Y);
    }
    else if (ivTouch.center.x > self.frame.size.width - [self lineRightMargin]) {
        
        ivTouch.center = CGPointMake(self.frame.size.width - [self lineRightMargin], CENTER_Y);
    }
    else {
        ivTouch.center = CGPointMake([self lineLeftMargin] + [self lineWidth]*(_curValue - _minValue)/(_maxValue - _minValue), CENTER_Y);
    }
    
    lbCurValue.text = [NSString stringWithFormat:@"%d%@",_curValue,_unit];
    
    if (_valueEnd) {
        self.valueEnd(_curValue);
    }
}

@end
