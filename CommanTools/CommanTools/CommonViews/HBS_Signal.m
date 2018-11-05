//
//  HBS_Signal.m
//  HBSDrone
//
//  Created by Arvin on 2017/8/1.
//  Copyright © 2017年 钟发军. All rights reserved.
//

#import "HBS_Signal.h"

@implementation HBS_Signal
{
    int totalSignal;
    
    int curSignal;
}

- (id)initWithFrame:(CGRect)frame maxSignal:(int)signal {
    
    if (self = [super initWithFrame:frame]) {
        
        totalSignal = signal;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSignal:(int)cur {
    
    curSignal = cur;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat line_w = rect.size.width / (2 * totalSignal - 1);
    CGFloat min_h = rect.size.height / totalSignal;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, line_w);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:116/255.0 green:123/255.0 blue:126/255.0 alpha:1].CGColor);
    
    for (int i = 0; i < totalSignal; i++) {
        
        CGContextMoveToPoint(ctx, line_w/2 + line_w * i * 2, rect.size.height);
        CGContextAddLineToPoint(ctx, line_w/2 + line_w * i * 2, rect.size.height - min_h * (i + 1));
        CGContextStrokePath(ctx);
    }
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1].CGColor);
    for (int i = 1; i <= curSignal; i++) {
        
        CGContextMoveToPoint(ctx, line_w/2 + line_w * (i - 1) * 2, rect.size.height);
        CGContextAddLineToPoint(ctx, line_w/2 + line_w * (i - 1) * 2, rect.size.height - min_h * i);
        CGContextStrokePath(ctx);
    }
}

@end
