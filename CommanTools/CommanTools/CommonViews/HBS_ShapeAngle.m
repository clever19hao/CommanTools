//
//  HBS_ShapeAngle.m
//  Vividia
//
//  Created by Arvin on 2017/4/24.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "HBS_ShapeAngle.h"

@implementation HBS_ShapeAngle

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _anglePosition = CGPointMake(30, 0);
        _fillColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    }
    
    return self;
}

- (id)init {
    
    return [[HBS_ShapeAngle alloc] initWithFrame:CGRectZero];
}

- (void)drawRect:(CGRect)rect {
    
    // 默认圆角角度
    float r = 4;
    // 居中偏移量(箭头高度)
    float offset = 5;
    
    // 设置 箭头位置
    float positionNum = _anglePosition.x;
    
    // 定义坐标点 移动量
    float changeNum = r + offset;
    // 设置画线 长 宽
    float w = self.frame.size.width ;
    float h = self.frame.size.height;
    
    
    // 获取文本
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置 边线宽度
    CGContextSetLineWidth(context, 0.2);
    //边框颜色
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    //矩形填充颜色
    if (self.fillColor) {
        
        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    }else{
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    }
    
    if (_anglePosition.y == 0) {
        
        CGContextMoveToPoint(context, r, offset); // 开始坐标左边开始
        CGContextAddLineToPoint(context, positionNum - 5, offset); // 向左划线
        CGContextAddLineToPoint(context, positionNum, 0); // 向左划线
        CGContextAddLineToPoint(context, positionNum + 5, offset); // 向下斜线
        
        CGContextAddArcToPoint(context, w, offset, w, changeNum, r); // 右上角角度
        CGContextAddArcToPoint(context, w , h, w - r, h, r); // 右下角角度
        CGContextAddArcToPoint(context, 0, h, 0, h - r, r); // 左下角角度
        CGContextAddArcToPoint(context, 0, offset, r, offset, r); // 左上角角度
    }
    else {
       
        CGContextMoveToPoint(context, r, offset); // 开始坐标左边开始
        CGContextAddArcToPoint(context, w, offset, w, changeNum, r); // 右上角角度
        CGContextAddArcToPoint(context, w , h - offset, w - changeNum, h - offset, r); // 右下角角度
        
        CGContextAddLineToPoint(context, positionNum + 5, h - offset); // 向左划线
        CGContextAddLineToPoint(context, positionNum + 0, h); // 向下斜线
        CGContextAddLineToPoint(context, positionNum - 5, h - offset); // 向上斜线
        
        CGContextAddArcToPoint(context, 0, h - offset, 0, h - changeNum, r); // 左下角角度
        CGContextAddArcToPoint(context, 0, offset, r, offset, r); // 左上角角度
    }
    
    
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    /** 父类调用 放在画完边线 后. 不然 设置的文字会被覆盖 */
    [super drawRect:rect];
}

- (void)setAnglePosition:(CGPoint)anglePosition {
    
    _anglePosition = anglePosition;
    
    [self setNeedsDisplay];
}

// 当 要改变填充颜色 可以进行调用改变
-(void)setFillColor:(UIColor *)fillColorStr{
    
    _fillColor = fillColorStr;
    
    // 调用- (void)drawRect:(CGRect)rect; 重绘填充颜色
    [self setNeedsDisplay];
}

@end
