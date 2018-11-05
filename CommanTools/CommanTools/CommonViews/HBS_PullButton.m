//
//  HBS_PullButton.m
//  Vividia
//
//  Created by Arvin on 2017/6/26.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "HBS_PullButton.h"

@implementation HBS_PullButton
{
    NSArray *btnTitles;
    NSArray *btnImages;
    
    NSUInteger allCount;
    
    CGSize itemSize;
}

- (id)initWithItems:(NSArray <NSString *>*)titles images:(NSArray <NSString *> *)imgNames frame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        btnTitles = titles;
        btnImages = imgNames;
        
        itemSize = frame.size;
        
        allCount = MAX([titles count], [imgNames count]);
        
        [self showWithSelect:0 itemCount:1];
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    
    [self showWithSelect:selectIndex itemCount:1];
}

- (void)showWithSelect:(NSInteger)index itemCount:(NSInteger)itemCount {
    
    _selectIndex = index;
    
    CGFloat btn_w = itemSize.width;
    
    for (NSInteger i = index,n = 1; i < index + allCount; i++,n++) {
        
        UIButton *btn = [self viewWithTag:1000 + i % allCount];
        
        if (n <= itemCount) {
            
            if (!btn) {
                btn = [[UIButton alloc] init];
                btn.tag = 1000 + i % allCount;
                [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            btn.frame = CGRectMake((i - index) * btn_w, 0, btn_w, itemSize.height);
            
            if ([btnTitles count] > i % allCount) {
                
                [btn setTitle:btnTitles[i % allCount] forState:UIControlStateNormal];
            }
            
            if ([btnImages count] > i % allCount) {
                
                [btn setImage:[UIImage imageNamed:btnImages[i % allCount]] forState:UIControlStateNormal];
            }
            
            [self addSubview:btn];
        }
        else {
            
            [btn removeFromSuperview];
        }
    }
}

- (void)pressBtn:(UIButton *)btn {
    
    NSInteger count = MAX([btnTitles count], [btnImages count]);
    
    if (self.frame.size.width <= itemSize.width + 1) {//展开
        
        [self showWithSelect:_selectIndex itemCount:count];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            //self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, itemSize.width*count, itemSize.height);
        }];
    }
    else {
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self showWithSelect:btn.tag - 1000 itemCount:1];
        
        [UIView animateWithDuration:0.2 animations:^{
            //self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, itemSize.width, itemSize.height);
        }];
        
        if (self.pressHandle) {
            self.pressHandle(_selectIndex);
        }
    }
}

@end
