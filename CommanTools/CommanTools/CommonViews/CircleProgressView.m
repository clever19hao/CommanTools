//
//  CircleProgressView.m
//  HBSDrone
//
//  Created by Arvin on 2018/1/8.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "CircleProgressView.h"

@implementation CircleProgressView
{
    float progress;
    int status;
    UILabel *lbPercent;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.clipsToBounds = YES;
        
        _progressColor = [UIColor colorWithRed:102/255.0 green:250/255.0 blue:213/255.0 alpha:1];
        
        lbPercent = [[UILabel alloc] init];
        lbPercent.font = [UIFont systemFontOfSize:10];
        lbPercent.adjustsFontSizeToFitWidth = YES;
        lbPercent.textColor = _progressColor;
        lbPercent.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbPercent];
    }
    
    return self;
}

- (id)init {
    
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    
    lbPercent.frame = CGRectMake(self.frame.size.width * 0.15, self.frame.size.height * 0.3, self.frame.size.width * 0.7, self.frame.size.height * 0.4);
}

- (void)setProgress:(float)pro status:(int)st {
    
    progress = pro;
    status = st;
    
    if (st == 1) {
        lbPercent.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"%d%%",(int)(progress*100)];
        lbPercent.text = str;
    }
    else {
        lbPercent.hidden = YES;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    float line_w = 2;
    float r = rect.size.width/2 - line_w/2;
    
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    [bgPath addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:r startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [[UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1] setStroke];
    bgPath.lineWidth = line_w;
    [bgPath stroke];
    
    if (status == 0) {
        
        float l_w = rect.size.width * 0.2;
        UIBezierPath *stopPath = [UIBezierPath bezierPath];
        [stopPath moveToPoint:CGPointMake(rect.size.width/2, rect.size.height/2 - l_w/2)];
        [stopPath addLineToPoint:CGPointMake(rect.size.width/2, rect.size.height/2 + l_w/2)];
        [[UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1] setStroke];
        stopPath.lineWidth = l_w;
        [stopPath stroke];
    }
    else {
        
        UIBezierPath *progressPath = [UIBezierPath bezierPath];
        [progressPath addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:r startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI*2*progress clockwise:YES];
        [_progressColor setStroke];
        progressPath.lineWidth = line_w;
        [progressPath stroke];
        
        if (status == 1) {
            
        }
        else {
            
            float p_w = 2;
            
            UIBezierPath *pausePath = [UIBezierPath bezierPath];
            pausePath.lineWidth = p_w;
            
            [[UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1] setStroke];
            
            [pausePath moveToPoint:CGPointMake(rect.size.width/2 - 2 - p_w/2, rect.size.height * 0.3)];
            [pausePath addLineToPoint:CGPointMake(rect.size.width/2 - 2 - p_w/2, rect.size.height * 0.7)];
            
            [pausePath stroke];
            
            [pausePath moveToPoint:CGPointMake(rect.size.width/2 + 2 + p_w/2, rect.size.height * 0.3)];
            [pausePath addLineToPoint:CGPointMake(rect.size.width/2 + 2 + p_w/2, rect.size.height * 0.7)];

            [pausePath stroke];
        }
    }
}

@end
