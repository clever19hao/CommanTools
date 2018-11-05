//
//  HBS_ScaleSlider.m
//  Vividia
//
//  Created by Arvin on 2017/6/28.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "HBS_ScaleSlider.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation HBS_ScaleSlider
{
    NSString *unit;
    NSMutableArray <NSNumber *> *scalesValue;
    
    UIImageView *ivTouch;
    
    UILabel *lbSelectValue;
    
    CGFloat top;
    CGFloat left_x;
    CGFloat right_x;
    CGFloat scale_h;
}

- (id)initWithScaleWithValues:(NSArray <NSNumber *> *)values unitDes:(NSString *)unitDes frame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _isOnlyUseValueInArray = YES;
        _isShowChangeValue = YES;
        
        unit = unitDes;
        
        scalesValue = [NSMutableArray arrayWithArray:values];
        
        self.backgroundColor = [UIColor clearColor];
        
        ivTouch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        
        ivTouch.image = [UIImage imageNamed:@"HY003_slide switch_01"];
        ivTouch.highlightedImage = [UIImage imageNamed:@"HY003_slide switch_02"];
        [self addSubview:ivTouch];
        
        top = 10;
        right_x = frame.size.width * 0.5;
        left_x = right_x - 5;
        scale_h = (self.frame.size.height - 2 * top) / ([scalesValue count] - 1);
        
        ivTouch.center = CGPointMake(right_x, 10 + (scalesValue.count/2)*scale_h);
        
        lbSelectValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, right_x - 15, 20)];
        lbSelectValue.textAlignment = NSTextAlignmentRight;
        lbSelectValue.adjustsFontSizeToFitWidth = YES;
        lbSelectValue.textColor = [UIColor whiteColor];
        lbSelectValue.font = [UIFont systemFontOfSize:17];
        lbSelectValue.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        lbSelectValue.shadowOffset = CGSizeMake(1, 1);
        lbSelectValue.text = [NSString stringWithFormat:@"%@%@",[self valueAtPosition:ivTouch.center],unit];
        lbSelectValue.center = CGPointMake(lbSelectValue.frame.size.width/2, ivTouch.center.y);
        [self addSubview:lbSelectValue];
    }
    
    return self;
}

- (void)setIsShowChangeValue:(BOOL)isShowChangeValue {
    
    _isShowChangeValue = isShowChangeValue;
    
    if (_isShowChangeValue) {
        lbSelectValue.hidden = NO;
    }
    else {
        lbSelectValue.hidden = YES;
    }
}

- (void)setCurSelectValue:(NSNumber *)value {
    
    NSInteger index = -1;
    
    for (int i = 0; i < [scalesValue count]; i++) {
        
        if ([value floatValue] >= [scalesValue[i] floatValue]) {
            index = i;
            break;
        }
    }
    
    if (index == -1) {
        ivTouch.center = CGPointMake(right_x, top + ([scalesValue count] - 1)*scale_h);
    }
    else if (index == 0) {
        ivTouch.center = CGPointMake(right_x, top);
    }
    else {
        
        float dec = ([value floatValue] - [scalesValue[index] floatValue]) / ([scalesValue[index - 1] floatValue] - [scalesValue[index] floatValue]);
        
        if (_isOnlyUseValueInArray) {
            
            index -= roundf(dec);
            
            ivTouch.center = CGPointMake(right_x, top + index*scale_h);
        }
        else {
            ivTouch.center = CGPointMake(right_x, top + (index - dec)*scale_h);
        }
    }
    
    lbSelectValue.text = [NSString stringWithFormat:@"%@%@",[self valueAtPosition:ivTouch.center],unit];
    lbSelectValue.center = CGPointMake(lbSelectValue.frame.size.width/2, ivTouch.center.y);
}


- (NSNumber *)valueAtPosition:(CGPoint)point {
    
    if (point.y <= top + 1) {
        
        return [scalesValue firstObject];
    }
    else if (point.y >= self.frame.size.height - top - 1) {
        
        return [scalesValue lastObject];
    }
    
    float v_p = (point.y - top)/scale_h;
    int int_p = (int)v_p;
    if (int_p == [scalesValue count] - 1) {
        return [scalesValue lastObject];
    }
    
    float decimal = v_p - int_p;
    
    if (_isOnlyUseValueInArray) {
        
        int index = roundf(v_p);
        return scalesValue[index];
    }
    
    float v = [scalesValue[int_p] floatValue] - ([scalesValue[int_p] floatValue] - [scalesValue[int_p + 1] floatValue]) * decimal;
    
    return @(roundf(v));
}

- (void)drawRect:(CGRect)rect {
    
    if (rect.size.height < top * 2) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetShadowWithColor(ctx, CGSizeZero, 2, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor);
    
    CGContextMoveToPoint(ctx, right_x, top);
    CGContextAddLineToPoint(ctx, right_x, self.frame.size.height - top);
    
    for (int i = 0; i < [scalesValue count]; i++) {
        
        CGContextMoveToPoint(ctx, left_x, top + i * scale_h);
        CGContextAddLineToPoint(ctx, right_x + 1, top + i * scale_h);
    }
    
    CGContextStrokePath(ctx);
    
    NSDictionary *info = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};
    for (int i = 0; i < [scalesValue count]; i++) {
        
        NSString *str = [NSString stringWithFormat:@"%@%@",scalesValue[i],unit];
        CGSize tSize = [str sizeWithAttributes:info];
        
        [str drawAtPoint:CGPointMake(right_x + 5, top + i * scale_h - tSize.height/2) withAttributes:info];
    }
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    
    CGPoint p = [touch locationInView:self];
    
    ivTouch.center = CGPointMake(right_x, p.y);
    ivTouch.highlighted = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    
    CGPoint p = [touch locationInView:self];
    
    if (p.y < top) {
        
        ivTouch.center = CGPointMake(right_x, top);
    }
    else if (p.y > self.frame.size.height - top) {
        
        ivTouch.center = CGPointMake(right_x, self.frame.size.height - top);
    }
    else {
        ivTouch.center = CGPointMake(right_x, p.y);
    }
    
    lbSelectValue.text = [NSString stringWithFormat:@"%@%@",[self valueAtPosition:ivTouch.center],unit];
    lbSelectValue.center = CGPointMake(lbSelectValue.frame.size.width/2, ivTouch.center.y);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ivTouch.highlighted = NO;
    [self endMove];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ivTouch.highlighted = NO;
    [self endMove];
}

- (void)endMove {

    if (ivTouch.center.y < top) {
        
        ivTouch.center = CGPointMake(right_x, top);
    }
    else if (ivTouch.center.y > self.frame.size.height - top) {
        
        ivTouch.center = CGPointMake(right_x, self.frame.size.height - top);
    }
    
    float v_p = (ivTouch.center.y - top)/scale_h;
    
    if (_isOnlyUseValueInArray) {
        ivTouch.center = CGPointMake(right_x, top + scale_h * roundf(v_p));
    }
    
    NSNumber *number = [self valueAtPosition:ivTouch.center];
    
    lbSelectValue.text = [NSString stringWithFormat:@"%@%@",number,unit];
    lbSelectValue.center = CGPointMake(lbSelectValue.frame.size.width/2, ivTouch.center.y);
    
    if (_selectValue) {
        self.selectValue(number);
    }
}

@end
