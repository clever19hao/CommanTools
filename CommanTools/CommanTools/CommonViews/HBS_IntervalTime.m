//
//  HBS_IntervalTime.m
//  Vividia
//
//  Created by Arvin on 2017/7/24.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "HBS_IntervalTime.h"

#define NUM 9//两根长刻度之间的短刻度

@implementation HBS_IntervalTime
{
    int status;//0没有执行 1动画中 2暂停
    
    int curDetailNum;
    
    dispatch_source_t timer;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _number = 10;
        _duration = 10;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)startAnimate {
    
    if (status == 1) {
        return;
    }
    
    status = 1;
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, _duration / (NUM + 1) * NSEC_PER_SEC), _duration / (NUM + 1) * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        curDetailNum++;
        
        if (curDetailNum > _number * (NUM + 1)) {
            
            curDetailNum = 0;
        }
        
        [self setNeedsDisplay];
        
    });
    dispatch_resume(timer);
}

- (BOOL)isAnimating {
    
    return status == 1;
}

- (void)stopAnimate {
    
    status = 0;
    
    if (timer) {
        dispatch_source_cancel(timer);
    }
    
    [self removeFromSuperview];
}

- (void)drawRect:(CGRect)rect {
    
    //添加刻度
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 1);
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat radius = rect.size.width/2 > rect.size.height/2 ? rect.size.height/2 : rect.size.width/2;
    CGFloat angle = M_PI * 2 / _number;
    
    for (int i = 0; i < _number; i++) {
        
        CGContextMoveToPoint(ctx, center.x + radius * cosf(i*angle), center.y + radius * sinf(i*angle));
        CGContextAddLineToPoint(ctx, center.x + radius * 0.7 * cosf(i*angle), center.y + radius * 0.7 * sinf(i*angle));
    }
    
    CGContextStrokePath(ctx);
    
    CGFloat detailAngle = M_PI * 2 / ((NUM + 1)*_number);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    for (int i = 0; i < curDetailNum; i++) {
        
        if (i % (NUM + 1) == 0) {
            
            CGContextMoveToPoint(ctx, center.x + radius * cosf(i*detailAngle), center.y + radius * sinf(i*detailAngle));
            CGContextAddLineToPoint(ctx, center.x + radius * 0.7 * cosf(i*detailAngle), center.y + radius * 0.7 * sinf(i*detailAngle));
        }
        else {
            CGContextMoveToPoint(ctx, center.x + radius * cosf(i*detailAngle), center.y + radius * sinf(i*detailAngle));
            CGContextAddLineToPoint(ctx, center.x + radius * 0.8 * cosf(i*detailAngle), center.y + radius * 0.8 * sinf(i*detailAngle));
        }
        
    }
    
    CGContextStrokePath(ctx);
}

@end
