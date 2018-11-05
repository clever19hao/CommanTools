//
//  PlanePageScrollView.m
//  HBSDrone
//
//  Created by Arvin on 2018/3/17.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "PageScrollView.h"

#define nsnull [NSNull null]

@interface PageScrollView () <UIScrollViewDelegate>
@end

@implementation PageScrollView
{
    UIScrollView *scroll;
    
    NSMutableArray *cacheViews;
    NSMutableDictionary <NSNumber *,PageView *> *usedViewsInfo;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        cacheViews = [NSMutableArray arrayWithCapacity:1];
        usedViewsInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        
        scroll = [[UIScrollView alloc] init];
        scroll.delegate = self;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.pagingEnabled = YES;
        if (@available(iOS 11.0,*)) {
            scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:scroll];
    }
    return self;
}

- (id)init {
    
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    scroll.frame = self.bounds;
    scroll.contentSize = CGSizeMake(scroll.frame.size.width * _numberOfData, scroll.frame.size.height);
    for (NSNumber *indexKey in usedViewsInfo.allKeys) {
        int index = [indexKey intValue];
        PageView *page = [usedViewsInfo objectForKey:indexKey];
        page.frame = CGRectMake(index * scroll.frame.size.width, 0, page.frame.size.width, page.frame.size.height);
    }
}

- (PageView *)dequeueReusablePageView {
    
    NSArray *usedPages = [usedViewsInfo allValues];
    
    for (PageView *v in cacheViews) {
        
        if (![usedPages containsObject:v]) {
            return v;
        }
    }
    
    return nil;
}

- (void)reloadPageView:(int)index {
    
    if (index < 0 || index >= _numberOfData) {
        return;
    }
    
    //先删除该位置的旧视图
    PageView *old = usedViewsInfo[@(index)];
    if (old) {
        [old removeFromSuperview];
    }
    
    //找到复用视图并在外部添加子视图
    PageView *page = [_delegate pageScrollView:self pageViewAtIndex:index];
    if (!page) {
        return;
    }
    
    //将复用视图摆在index位置上
    page.frame = CGRectMake(index * scroll.frame.size.width, 0, page.frame.size.width, page.frame.size.height);
    [scroll addSubview:page];
    
    if (![cacheViews containsObject:page]) {
        [cacheViews addObject:page];
    }
    [usedViewsInfo setObject:page forKey:@(index)];
}

- (void)clearInvalidPageViews {//只保留3页视图，多的就清理，作为复用视图使用
    
    for (int index = 0; index < _numberOfData; index++) {
        
        if (index < _currentIndex - 1 || index > _currentIndex + 1) {
            
            PageView *page = usedViewsInfo[@(index)];
            [page removeFromSuperview];
            
            [usedViewsInfo removeObjectForKey:@(index)];
        }
    }
}

- (void)reloadData {
    
    _numberOfData = [_delegate pageScrollViewNumberOfData];
    
    for (PageView *v in usedViewsInfo.allValues) {
        [v removeFromSuperview];
    }
    [usedViewsInfo removeAllObjects];
    
    scroll.contentSize = CGSizeMake(scroll.frame.size.width * _numberOfData, scroll.frame.size.height);
    
    if (_currentIndex < 0) {
        _currentIndex = 0;
    }
    else if (_currentIndex >= _numberOfData) {
        _currentIndex = _numberOfData - 1;
    }
    
    scroll.contentOffset = CGPointMake(_currentIndex * scroll.frame.size.width, 0);
    
    [self clearInvalidPageViews];

    [self reloadPageView:_currentIndex - 1];
    [self reloadPageView:_currentIndex];
    [self reloadPageView:_currentIndex + 1];
}

- (void)scrollToIndex:(int)index animate:(BOOL)animate {
    
    _currentIndex = index;
    
    [self clearInvalidPageViews];
    
    if (!usedViewsInfo[@(_currentIndex - 1)]) {
        [self reloadPageView:_currentIndex - 1];
    }
    
    if (!usedViewsInfo[@(_currentIndex)]) {
        [self reloadPageView:_currentIndex];
    }
    
    if (!usedViewsInfo[@(_currentIndex + 1)]) {
        [self reloadPageView:_currentIndex + 1];
    }
    
    [scroll setContentOffset:CGPointMake(_currentIndex * scroll.frame.size.width, 0) animated:animate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / scrollView.frame.size.width + 0.5;
    
    if (_currentIndex == index) {
        return;
    }
    
    _currentIndex = index;
    
    [self clearInvalidPageViews];
    
    if (!usedViewsInfo[@(_currentIndex - 1)]) {
        [self reloadPageView:_currentIndex - 1];
    }
    
    if (!usedViewsInfo[@(_currentIndex)]) {
        [self reloadPageView:_currentIndex];
    }
    
    if (!usedViewsInfo[@(_currentIndex + 1)]) {
        [self reloadPageView:_currentIndex + 1];
    }
    
    if ([_delegate respondsToSelector:@selector(pageScrollView:didEndScrollToIndex:)]) {
        [_delegate pageScrollView:self didEndScrollToIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / scrollView.frame.size.width + 0.5;
    
    if (_currentIndex == index) {
        return;
    }
    
    _currentIndex = index;
    
    [self clearInvalidPageViews];
    
    if (!usedViewsInfo[@(_currentIndex - 1)]) {
        [self reloadPageView:_currentIndex - 1];
    }
    
    if (!usedViewsInfo[@(_currentIndex)]) {
        [self reloadPageView:_currentIndex];
    }
    
    if (!usedViewsInfo[@(_currentIndex + 1)]) {
        [self reloadPageView:_currentIndex + 1];
    }
    
    if ([_delegate respondsToSelector:@selector(pageScrollView:didEndScrollToIndex:)]) {
        [_delegate pageScrollView:self didEndScrollToIndex:index];
    }
}
@end
