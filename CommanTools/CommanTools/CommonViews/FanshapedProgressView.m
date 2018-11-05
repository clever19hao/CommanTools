//
//  FanshapedProgressView.m
//  HBSDrone
//
//  Created by Arvin on 2018/1/3.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "FanshapedProgressView.h"

@implementation FanshapedProgressView
{
    float proValue;
    BOOL ispause;
    
    UIView *pauseMaskView;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.clipsToBounds = YES;
        
        _coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        //_coverColor = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:214/255.0 alpha:0.8];
        
        pauseMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        pauseMaskView.backgroundColor = _coverColor;
        pauseMaskView.hidden = YES;
        [self addSubview:pauseMaskView];
        
    }
    
    return self;
}

- (id)init {
    
    return [self initWithFrame:CGRectZero];
}

- (void)setCoverColor:(UIColor *)coverColor {
    
    _coverColor = coverColor;
    
    pauseMaskView.backgroundColor = _coverColor;
}

- (void)setProgress:(float)progress ispaused:(BOOL)ispaused {
    
    proValue = progress;
    ispause = ispaused;
    
    pauseMaskView.hidden = !ispaused;
    
    [self setNeedsDisplay];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    
    float v = 1 - proValue;
    
    if (v <= 0) {
        return;
    }
    
    if (ispause) {
        
        float r_max = rect.size.width * sinf(M_PI_4);
        float r = rect.size.width * 0.2;
        
        float line_w = r_max - r;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, line_w);
        CGContextSetStrokeColorWithColor(ctx, _coverColor.CGColor);
        
        CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, r + line_w/2, -M_PI_2, -M_PI_2 - v * 2 * M_PI, 1);
        
        CGContextStrokePath(ctx);
        
        pauseMaskView.frame = CGRectMake((self.frame.size.width - (r - 2)*2)/2, (self.frame.size.height - (r - 2)*2)/2, (r - 2)*2, (r - 2)*2);
        
        //贝塞尔曲线 画一个带有圆角的矩形
        // UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.size.width/2 - 25, rect.size.height/2 - 25, 50, 50) cornerRadius:25];
        UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:pauseMaskView.bounds cornerRadius:pauseMaskView.frame.size.width/2];

        //贝塞尔曲线 画一个圆形
        [bpath appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(pauseMaskView.frame.size.width/2 - 5, pauseMaskView.frame.size.height/2 - 6, 3, 12)] bezierPathByReversingPath]];
        [bpath appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(pauseMaskView.frame.size.width/2 + 2, pauseMaskView.frame.size.height/2 - 6, 3, 12)] bezierPathByReversingPath]];
        
        //创建一个CAShapeLayer 图层
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bpath.CGPath;
        
        //添加图层蒙板
        pauseMaskView.layer.mask = shapeLayer;
    }
    else {
        
        float r = rect.size.width * sinf(M_PI_4);
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, r);
        CGContextSetStrokeColorWithColor(ctx, _coverColor.CGColor);
        
        CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, r/2, -M_PI_2, -M_PI_2 - v * 2 * M_PI, 1);
        
        CGContextStrokePath(ctx);
    }
}

@end
