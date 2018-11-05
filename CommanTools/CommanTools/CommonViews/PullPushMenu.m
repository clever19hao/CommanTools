//
//  PullPushMenu.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/6.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "PullPushMenu.h"

@implementation PullPushMenu
{
    CGSize itemSize;
    CGRect shrinkFrame;
    
    NSArray *menuTitles;
    NSArray *menuImgNames;
}

- (id)initWithShrinkFrame:(CGRect)rect itemSize:(CGSize)size {
    
    if (self = [super initWithFrame:rect]) {
        
        itemSize = size;
        shrinkFrame = rect;
        
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.8];
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)setTitles:(NSArray *)titles pairImages:(NSArray *)imgNames {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    menuTitles = [titles copy];
    menuImgNames = [imgNames copy];
    
    [self freshMenu];
}

- (void)expand {
    
    _isExpand = YES;
    
    [self freshMenu];
}

- (void)shrink {
    
    _isExpand = NO;
    
    [self freshMenu];
}

- (void)setSelectIndex:(int)selectIndex {
    
    _selectIndex = selectIndex;
    
    [self freshMenu];
}

- (void)freshMenu {
    
    UIButton *btn = [self viewWithTag:100];
    if (!btn) {
        btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = 100;
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    UIImageView *ivFlag = [btn viewWithTag:1001];
    if (!ivFlag) {
        ivFlag = [[UIImageView alloc] init];
        ivFlag.tag = 1001;
        [btn addSubview:ivFlag];
    }
    
    ivFlag.image = [UIImage imageNamed:menuImgNames[_selectIndex]];
    
    if (_isExpand) {
        
        CGRect rect = shrinkFrame;
        rect.origin.x -= [menuTitles count] * itemSize.width;
        rect.size.width += [menuTitles count] * itemSize.width;
        if (shrinkFrame.size.height < itemSize.height) {
            rect.origin.y -= (itemSize.height - shrinkFrame.size.height)/2;
            rect.size.height += itemSize.height - shrinkFrame.size.height;
        }
        self.frame = rect;
        btn.frame = CGRectMake(self.frame.size.width - shrinkFrame.size.width, 0, shrinkFrame.size.width, shrinkFrame.size.height);
        ivFlag.frame = CGRectMake((btn.frame.size.width - 19)/2, (btn.frame.size.width - 26)/2, 19, 26);
        
        for (int i = 0; i < menuTitles.count; i++) {
            
            UIButton *btn = [self viewWithTag:101 + i];
            if (!btn) {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(itemSize.width*i, (self.frame.size.height - itemSize.height)/2, itemSize.width, itemSize.height);
                btn.tag = 101 + i;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithRed:117/255.0 green:251/255.0 blue:222/255.0 alpha:1] forState:UIControlStateSelected];
                [btn setTitle:menuTitles[i] forState:UIControlStateNormal];
//                btn.titleLabel.adjustsFontSizeToFitWidth = YES;
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                [btn addTarget:self action:@selector(pressMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
            if (i == _selectIndex) {
                btn.selected = YES;
            }
            else {
                btn.selected = NO;
            }
        }
    }
    else {
        self.frame = shrinkFrame;
        btn.frame = CGRectMake(0, 0, shrinkFrame.size.width, shrinkFrame.size.height);
        ivFlag.frame = CGRectMake((btn.frame.size.width - 19)/2, (btn.frame.size.width - 26)/2, 19, 26);
        
        for (int i = 0; i < menuTitles.count; i++) {
            
            UIButton *btn = [self viewWithTag:101 + i];
            [btn removeFromSuperview];
        }
    }
}

- (void)pressBtn:(UIButton *)sender {
    
    if (sender.tag == 100) {
        
        if (_isExpand) {
            [self shrink];
        }
        else {
            [self expand];
        }
    }
}

- (void)pressMenuBtn:(UIButton *)sender {
    
    int index = (int)sender.tag - 101;
    
    _selectIndex = index;
    
    [self freshMenu];
    
    [self shrink];
    
    if (self.didSelectMenu) {
        self.didSelectMenu(_selectIndex);
    }
}

@end
