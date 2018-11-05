//
//  GridButtonMenu.m
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/11/6.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "GridButtonMenu.h"

#define BASE_TAG        1000

@implementation GridButtonMenu
{
    UIScrollView *scroll;
    UIView *selectLine;
    
    NSArray *itemTitles;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        scroll = [[UIScrollView alloc] initWithFrame:frame];
        scroll.alwaysBounceVertical = NO;
        scroll.alwaysBounceHorizontal = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        
        [self addSubview:scroll];
        
        _selectColor = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:214/255.0 alpha:1];
        _normalColor = [UIColor whiteColor];
    }
    
    return self;
}

- (id)init {

    return [self initWithFrame:CGRectZero];
}

- (void)setSelectColor:(UIColor *)selectColor {
    
    _selectColor = selectColor;
    
    for (int row = 0; row < [itemTitles count]; row++) {
        
        for (int col = 0; col < [itemTitles[row] count]; col++) {
            
            UIButton *btn = [scroll viewWithTag:((row << 16) | col) + BASE_TAG];
            
            [btn setTitleColor:_selectColor forState:UIControlStateSelected];
            
            selectLine.backgroundColor = _selectColor;
        }
    }
}

- (void)setNormalColor:(UIColor *)normalColor {
    
    _normalColor = normalColor;
    
    for (int row = 0; row < [itemTitles count]; row++) {
        
        for (int col = 0; col < [itemTitles[row] count]; col++) {
            
            UIButton *btn = [scroll viewWithTag:((row << 16) | col) + BASE_TAG];
            
            [btn setTitleColor:_normalColor forState:UIControlStateNormal];
        }
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    scroll.frame = self.bounds;
    
    CGFloat start_x = 0;
    CGFloat start_y = 0;
    
    CGFloat max_w = 0;
    
    for (int row = 0; row < [itemTitles count]; row++) {
        
        start_x = 0;
        
        for (int col = 0; col < [itemTitles[row] count]; col++) {
            
            UIButton *btn = [scroll viewWithTag:((row << 16) | col) + BASE_TAG];
            btn.frame = CGRectMake(start_x, start_y, _itemSize.width, _itemSize.height);
            
            start_x += _itemSize.width + _itemSpace;
            
            if (max_w < start_x) {
                max_w = start_x;
            }
            
            if (row == _selectIndexPath.section && col == _selectIndexPath.row) {
                
                selectLine.frame = CGRectMake(0, btn.frame.size.height - 5, btn.frame.size.width, 5);
            }
        }
        
        start_y += _itemSpace + _itemSize.height;
    }
    scroll.contentSize = CGSizeMake(max_w - _itemSpace, start_y - _itemSpace);
}

- (void)setMenuItemsWithTitles:(NSArray <NSArray <NSString *> *> *)titles {
    
    itemTitles = titles;
    
    CGFloat start_x = 0;
    CGFloat start_y = 0;
    
    CGFloat max_w = 0;
    
    for (int row = 0; row < [titles count]; row++) {
        
        start_x = 0;
        
        for (int col = 0; col < [titles[row] count]; col++) {
            
            NSString *title = titles[row][col];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(start_x, start_y, _itemSize.width, _itemSize.height);
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:_normalColor forState:UIControlStateNormal];
            [btn setTitleColor:_selectColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = ((row << 16) | col) + BASE_TAG;
            
            [scroll addSubview:btn];
            
            start_x += _itemSize.width + _itemSpace;
            
            if (max_w < start_x) {
                max_w = start_x;
            }
        }
        
        start_y += _itemSpace + _itemSize.height;
    }
    
    scroll.contentSize = CGSizeMake(max_w - _itemSpace, start_y - _itemSpace);
}

- (void)setSelectIndexPath:(NSIndexPath *)selectIndexPath {
    
    UIButton *selectBtn = [scroll viewWithTag:((_selectIndexPath.section << 16) | _selectIndexPath.row) + BASE_TAG];
    selectBtn.selected = NO;
    
    if (!selectLine) {
        selectLine = [[UIView alloc] initWithFrame:CGRectZero];
        selectLine.backgroundColor = _selectColor;
    }
    
    UIButton *pressBtn = [scroll viewWithTag:((selectIndexPath.section << 16) | selectIndexPath.row) + BASE_TAG];
    pressBtn.selected = YES;
    selectLine.frame = CGRectMake(0, pressBtn.frame.size.height - 5, pressBtn.frame.size.width, 5);
    [pressBtn addSubview:selectLine];
    
    _selectIndexPath = selectIndexPath;
}

- (void)press:(UIButton *)btn {
    
    int row = (int)(btn.tag - BASE_TAG) >> 16;
    int col = (int)(btn.tag - BASE_TAG) & 0x0000FFFF;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:col inSection:row];
    
    self.selectIndexPath = indexPath;
    
    if (_selectHandle) {
        self.selectHandle(indexPath);
    }
}

@end
