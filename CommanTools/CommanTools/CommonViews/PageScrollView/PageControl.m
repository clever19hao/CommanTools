//
//  PageControl.m
//  HBSDrone
//
//  Created by Arvin on 2018/3/17.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "PageControl.h"

@implementation PageControl
{
    NSMutableArray *linesArray;
}

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _normalColor = [UIColor grayColor];
        _selectColor = [UIColor darkGrayColor];
        linesArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (id)init {
    
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat per = self.frame.size.width / (_count * 3 + (_count - 1) * 2);
    CGFloat w = 3 * per;
    CGFloat space = 2 * per;
    
    for (int i = 0; i < [linesArray count]; i++) {
        
        UIView *v = linesArray[i];
        v.frame = CGRectMake(i * (w + space), 0, w, self.frame.size.height);
        v.layer.cornerRadius = v.frame.size.height/2;
    }
}

- (void)setCount:(int)count {
    
    if (_count != count) {
        
        _count = count;
        
        [linesArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [linesArray removeAllObjects];

        CGFloat per = self.frame.size.width / (_count * 3 + (_count - 1) * 2);
        CGFloat w = 3 * per;
        CGFloat space = 2 * per;
        for (int i = 0; i < _count; i++) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i * (w + space), 0, w, self.frame.size.height)];
            v.layer.cornerRadius = self.frame.size.height/2;
            v.backgroundColor = _normalColor;
            [self addSubview:v];
            [linesArray addObject:v];
        }
    }
}

- (void)setSelectIndex:(int)selectIndex animte:(BOOL)animate {
    
    if (selectIndex < 0 || selectIndex >= [linesArray count]) {
        return;
    }
    
    UIView *old = linesArray[_selectIndex];
    
    _selectIndex = selectIndex;
    
    UIView *new = linesArray[_selectIndex];
    
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            old.backgroundColor = _normalColor;
            new.backgroundColor = _selectColor;
        }];
    }
    else {
        old.backgroundColor = _normalColor;
        new.backgroundColor = _selectColor;
    }
}

@end
