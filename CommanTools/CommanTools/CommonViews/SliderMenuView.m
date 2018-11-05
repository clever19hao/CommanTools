//
//  SliderMenuView.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/21.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "SliderMenuView.h"
@implementation MenuItemView
@synthesize lbContent = _lbContent;
- (UILabel *)lbContent {
    if (!_lbContent) {
        _lbContent = [[UILabel alloc] initWithFrame:self.bounds];
        _lbContent.textAlignment = NSTextAlignmentCenter;
        _lbContent.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_lbContent];
    }
    return _lbContent;
}

- (void)layoutSubviews {
    
    _lbContent.frame = self.bounds;
}
@end

@interface SliderMenuView () <UIScrollViewDelegate>
@end

@implementation SliderMenuView
{
    UIScrollView *scroll;
    UIImageView *ivFlag;
    NSArray *menuItems;
    
    NSMutableArray *cacheViews;
    NSMutableDictionary <NSNumber *,MenuItemView *> *usedViewsInfo;
}

@synthesize titleLabel = _titleLabel;

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        cacheViews = [NSMutableArray arrayWithCapacity:1];
        usedViewsInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        
        scroll = [[UIScrollView alloc] init];
        scroll.delegate = self;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0,*)) {
            scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:scroll];
        
        ivFlag = [[UIImageView alloc] init];
        ivFlag.contentMode = UIViewContentModeScaleAspectFit;
        ivFlag.image = [UIImage imageNamed:@"HY012_Camera_param_triangle"];
        [self addSubview:ivFlag];
    }
    return self;
}

- (id)init {
    
    return [self initWithFrame:CGRectZero];
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0, 5, self.frame.size.width, 20);
    ivFlag.frame = CGRectMake((self.frame.size.width - 7)/2, self.frame.size.height - 6, 7, 6);
    
    scroll.frame = self.bounds;
    scroll.contentSize = CGSizeMake(_itemViewSize.width * _numberOfData + scroll.frame.size.width - _itemViewSize.width, scroll.frame.size.height);
    
    [self reloadItemViews];
    [scroll setContentOffset:CGPointMake(_currentIndex * _itemViewSize.width, 0) animated:NO];
}

//刷新某一页视图
- (void)reloadItem:(int)index {
    
    if (index < 0 || index >= _numberOfData) {
        return;
    }
    
    //先删除该位置的旧视图
    MenuItemView *itemView = usedViewsInfo[@(index)];
    if (!itemView) {
        
        itemView = [[MenuItemView alloc] init];
        itemView.lbContent.font = [UIFont boldSystemFontOfSize:10];
        [scroll addSubview:itemView];
        
        if (![cacheViews containsObject:itemView]) {
            [cacheViews addObject:itemView];
        }
        
        [usedViewsInfo setObject:itemView forKey:@(index)];
    }
    
    //将复用视图摆在index位置上
    itemView.frame = CGRectMake([self itemStartX] + index * _itemViewSize.width, scroll.frame.size.height * 0.45, _itemViewSize.width, _itemViewSize.height);
    itemView.lbContent.text = menuItems[index];
    if (index == _currentIndex) {
        itemView.lbContent.textColor = [UIColor whiteColor];
    }
    else {
        itemView.lbContent.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
    }
}

- (void)scrollToIndex:(int)index animate:(BOOL)animate {
    
    if (index < 0 || index >= _numberOfData) {
        return;
    }
    
    _currentIndex = index;
    
    if (scroll.frame.size.width < 1) {
        return;
    }
    
    [self reloadItemViews];
    
    [scroll setContentOffset:CGPointMake(_currentIndex * _itemViewSize.width, 0) animated:animate];
}

- (void)reloadSliderWithItems:(NSArray *)items {
    
    menuItems = items;
    _numberOfData = (int)[items count];
    
    for (MenuItemView *v in usedViewsInfo.allValues) {
        [v removeFromSuperview];
    }
    [usedViewsInfo removeAllObjects];
    
    scroll.contentSize = CGSizeMake(_itemViewSize.width * _numberOfData + scroll.frame.size.width - _itemViewSize.width, scroll.frame.size.height);
    
    if (_currentIndex < 0) {
        _currentIndex = 0;
    }
    else if (_currentIndex >= _numberOfData) {
        _currentIndex = _numberOfData - 1;
    }
    
    scroll.contentOffset = CGPointMake(_currentIndex * _itemViewSize.width, 0);
    
    [self reloadItemViews];
}


#pragma mark -
- (CGFloat)itemStartX {
    return (scroll.frame.size.width - _itemViewSize.width)/2;
}

- (void)reloadItemViews {
    
    int visibleCount = (scroll.frame.size.width/2 - _itemViewSize.width/2)/_itemViewSize.width + 1;//前后只保留visibleCount页视图，多的就清理，作为复用视图使用
    
    for (int index = 0; index < _numberOfData; index++) {
        
        if (index < _currentIndex - visibleCount || index > _currentIndex + visibleCount) {
            
            MenuItemView *itemView = usedViewsInfo[@(index)];
            [itemView removeFromSuperview];
            
            [usedViewsInfo removeObjectForKey:@(index)];
        }
    }
    
    for (int i = _currentIndex; i >= 0 && i >= _currentIndex - visibleCount; i--) {
        [self reloadItem:i];
    }
    
    for (int i = _currentIndex; i < _numberOfData && i <= _currentIndex + visibleCount; i++) {
        [self reloadItem:i];
    }
}
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / _itemViewSize.width + 0.5;
        
    if (_currentIndex == index || index < 0 || index >= _numberOfData) {
        
        return;
    }
    
    _currentIndex = index;
    
    [self reloadItemViews];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        
        [scroll setContentOffset:CGPointMake(_currentIndex * _itemViewSize.width, 0) animated:YES];
        
        if (self.selectItem) {
            self.selectItem(_currentIndex, menuItems[_currentIndex]);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / _itemViewSize.width + 0.5;
    
    if (index < 0 || index >= _numberOfData) {
        
        return;
    }
    
    _currentIndex = index;
    
    [scroll setContentOffset:CGPointMake(_currentIndex * _itemViewSize.width, 0) animated:YES];
    
    if (self.selectItem) {
        self.selectItem(_currentIndex, menuItems[_currentIndex]);
    }
}
@end
