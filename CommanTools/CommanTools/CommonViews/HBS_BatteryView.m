//
//  HBS_BatteryView.m
//  Vividia
//
//  Created by Arvin on 2017/7/18.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "HBS_BatteryView.h"

@implementation HBS_BatteryView
{
    BatteryStyle _style;
    
    UIColor *fillColor;
    
    float lineWidth;
    float percent;
}

- (id)initWithFrame:(CGRect)frame style:(BatteryStyle)style {
    
    if (self = [super initWithFrame:frame]) {
        
        _style = style;
        
        self.backgroundColor = [UIColor clearColor];
        lineWidth = 1;
        
        fillColor = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:219/255.0 alpha:1];
    }
    
    return self;
}

- (void)setBatteryColor:(UIColor *)color {
    
    fillColor = color;
    
    [self setNeedsDisplay];
}

- (void)setBatteryPercent:(float)perc {
    
    percent = perc;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, fillColor.CGColor);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    
    if (_style == BatteryStyleHor) {
        
        if (percent > 0.9) {
            
            CGContextFillRect(ctx, CGRectMake(0, 0, rect.size.width * 0.9, rect.size.height));
            CGContextFillRect(ctx, CGRectMake(rect.size.width * 0.9, rect.size.height * 0.25, rect.size.width * 0.1 * (percent - 0.9), rect.size.height * 0.5));
        }
        else {
            CGContextFillRect(ctx, CGRectMake(0, 0, rect.size.width * percent, rect.size.height));
        }
        
        //会覆盖fill的重合区域
        CGContextMoveToPoint(ctx, lineWidth/2, lineWidth/2);
        CGContextAddLineToPoint(ctx, rect.size.width * 0.9, lineWidth/2);
        CGContextAddLineToPoint(ctx, rect.size.width * 0.9, rect.size.height * 0.25);
        CGContextAddLineToPoint(ctx, rect.size.width * 1.0 - lineWidth/2, rect.size.height * 0.25);
        CGContextAddLineToPoint(ctx, rect.size.width * 1.0 - lineWidth/2, rect.size.height * 0.75);
        CGContextAddLineToPoint(ctx, rect.size.width * 0.9, rect.size.height * 0.75);
        CGContextAddLineToPoint(ctx, rect.size.width * 0.9, rect.size.height * 1.0 - lineWidth/2);
        CGContextAddLineToPoint(ctx, lineWidth/2, rect.size.height * 1.0 - lineWidth/2);
        CGContextAddLineToPoint(ctx, lineWidth/2, lineWidth/2);
    }
    else {
        
        if (percent > 0.9) {
            
            CGContextFillRect(ctx, CGRectMake(0, rect.size.height * 0.1, rect.size.width, rect.size.height * 0.9));
            CGContextFillRect(ctx, CGRectMake(rect.size.width * 0.25, rect.size.height * (1 - percent), rect.size.width * 0.5, rect.size.height * (percent - 0.9)));
        }
        else {
            CGContextFillRect(ctx, CGRectMake(0, rect.size.height * (1 - percent), rect.size.width, rect.size.height * percent));
        }
        
        //会覆盖fill的重合区域
        CGContextMoveToPoint(ctx, lineWidth/2, rect.size.height - lineWidth/2);
        CGContextAddLineToPoint(ctx, lineWidth/2, rect.size.height * 0.1);
        CGContextAddLineToPoint(ctx, rect.size.width * 0.25, rect.size.height * 0.1);
        CGContextAddLineToPoint(ctx, rect.size.width * 0.25, lineWidth/2);
        CGContextAddLineToPoint(ctx, rect.size.width * 0.75, lineWidth/2);
        CGContextAddLineToPoint(ctx, rect.size.width * 0.75, rect.size.height * 0.1);
        CGContextAddLineToPoint(ctx, rect.size.width - lineWidth/2, rect.size.height * 0.1);
        CGContextAddLineToPoint(ctx, rect.size.width - lineWidth/2, rect.size.height - lineWidth/2);
        CGContextAddLineToPoint(ctx, lineWidth/2, rect.size.height - lineWidth/2);
    }
    
    CGContextStrokePath(ctx);
}

@end
