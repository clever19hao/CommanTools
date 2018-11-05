//
//  CE_LoopView.m
//  CommanApp
//
//  Created by cxq on 16/5/28.
//  Copyright © 2016年 cxq. All rights reserved.
//

#import "CE_LoopView.h"
#import "CE_ScrollCell.h"

#define NUM 3

@interface CE_LoopView () <UIScrollViewDelegate,scrollCellDelegate>

@property (nonatomic,strong) UIScrollView *scroll;

@property (nonatomic,assign) NSInteger number;

@property (nonatomic,assign) NSInteger loadStatus;//0未加载 1加载下一张 1<<1:加载这张 1<<2加载过上一张
@property (nonatomic, strong) NSMutableArray *scrollCells;
@end

@implementation CE_LoopView

- (id)initWithFrame:(CGRect)frame delegate:(id <CE_LoopViewDelegate>)delegate {
    
    if (self = [super initWithFrame:frame]) {
        
        _scrollCells = [NSMutableArray array];
        _delegate = delegate;
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _scroll.frame = self.bounds;
    _scroll.contentSize = CGSizeMake(NUM * _scroll.frame.size.width, _scroll.frame.size.height);
     [self preCell].frame = CGRectMake(0 * _scroll.frame.size.width, 0, _scroll.frame.size.width, _scroll.frame.size.height);
     [self currentCell].frame = CGRectMake(1 * _scroll.frame.size.width, 0, _scroll.frame.size.width, _scroll.frame.size.height);
     [self nextCell].frame = CGRectMake(2 * _scroll.frame.size.width, 0, _scroll.frame.size.width, _scroll.frame.size.height);

    [_scroll setContentOffset:CGPointMake(_scroll.frame.size.width, 0) animated:NO];
}

- (void)didSinglePress:(CE_ScrollCell *)cell {
    
    if ([_delegate respondsToSelector:@selector(didSingleTouchCell:loopView:)]) {
        [_delegate didSingleTouchCell:cell loopView:self];
    }
}

- (void)showPage:(NSInteger)pageIndex {
    
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scroll.backgroundColor = [UIColor clearColor];
        _scroll.delegate = self;
        _scroll.pagingEnabled = YES;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0,*)) {
            _scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:_scroll];
        
        _scroll.contentSize = CGSizeMake(NUM * _scroll.frame.size.width, _scroll.frame.size.height);
        [_scrollCells removeAllObjects];
        for (int i = 0; i < 3; i++) {
            
            CE_ScrollCell *cell = [[CE_ScrollCell alloc] initWithFrame:CGRectMake(i * _scroll.frame.size.width, 0, _scroll.frame.size.width, _scroll.frame.size.height)];
            cell.tag = 1000 + i;
            cell.cellDelegate = self;
            [_scroll addSubview:cell];
            [_scrollCells addObject:cell];
        }
    }
    
    _number = 0;
    
    if ([_delegate respondsToSelector:@selector(numberOfSource)]) {
        _number = [_delegate numberOfSource];
    }
    
    CE_ScrollCell *cell = [self currentCell];
    cell.index = pageIndex;
    
    [_scroll setContentOffset:CGPointMake(_scroll.frame.size.width, 0) animated:NO];
    
    [self reloadCurrent];
}

- (CE_ScrollCell *)currentCell {
    
    CE_ScrollCell *cell = (CE_ScrollCell *)[_scroll viewWithTag:1001];
    
    return cell;
}

- (CE_ScrollCell *)preCell {
    
    CE_ScrollCell *cell = (CE_ScrollCell *)[_scroll viewWithTag:1000];
    
    return cell;
}

- (CE_ScrollCell *)nextCell {
    
    CE_ScrollCell *cell = (CE_ScrollCell *)[_scroll viewWithTag:1002];
    
    return cell;
}

- (void)reloadPrev {
    
    CE_ScrollCell *cur = [self currentCell];
    CE_ScrollCell *pre = [self preCell];
    
    pre.index = (cur.index + _number - 1) % _number;
    
    [self showCell:pre];
    
    _loadStatus |= (1 << 2);
}

- (void)reloadCurrent {
    
    CE_ScrollCell *cur = [self currentCell];
    
    [self showCell:cur];
    
    _loadStatus |= (1 << 1);
}

- (void)reloadNext {
    
    CE_ScrollCell *cur = [self currentCell];
    CE_ScrollCell *next = [self nextCell];
    
    next.index = (cur.index + 1) % _number;
    
    [self showCell:next];
    
    _loadStatus |= (1 << 0);
}

- (void)showCell:(CE_ScrollCell *)cell {
    
    [_delegate loadScrollCell:cell loopView:self];
    
    [cell resetZoomScale];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x < (NUM/2)*scrollView.frame.size.width) {
        
        if (!(_loadStatus & (1 << 2))) {
            
            [self reloadPrev];
        }
        
    }
    else if (scrollView.contentOffset.x > (NUM/2)*scrollView.frame.size.width) {
        
        if (!(_loadStatus & (1 << 0))) {
            
            [self reloadNext];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    scrollView.scrollEnabled = YES;
    
    int index = floor(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    
    if (index == NUM/2) {
        
        if (!(_loadStatus & (1 << 0))) {
            
            [self reloadNext];
        }
        
        if (!(_loadStatus & (1 << 2))) {
            
            [self reloadPrev];
        }
        
        return;
    }
    
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, scrollView.contentOffset.y) animated:NO];

    if (index == NUM/2 + 1) {
        
        CE_ScrollCell *c0 = [self preCell];
        CE_ScrollCell *c1 = [self currentCell];
        CE_ScrollCell *c2 = [self nextCell];
        
        c0.frame = CGRectMake(scrollView.frame.size.width*2, 0, c0.frame.size.width, c0.frame.size.height);
        c0.tag = 1000 + 2;
        
        c1.frame = CGRectMake(0, 0, c1.frame.size.width, c1.frame.size.height);
        c1.tag = 1000 + 0;
        
        c2.frame = CGRectMake(scrollView.frame.size.width, 0, c2.frame.size.width, c2.frame.size.height);
        c2.tag = 1000 + 1;
        
        _loadStatus &= 0x0E;
        
        [self showCell:c1];
    }
    else if (index == NUM/2 - 1) {
        
        CE_ScrollCell *c0 = [self preCell];
        CE_ScrollCell *c1 = [self currentCell];
        CE_ScrollCell *c2 = [self nextCell];
        
        c0.frame = CGRectMake(scrollView.frame.size.width, 0, c0.frame.size.width, c0.frame.size.height);
        c0.tag = 1000 + 1;
        
        c1.frame = CGRectMake(scrollView.frame.size.width*2, 0, c1.frame.size.width, c1.frame.size.height);
        c1.tag = 1000 + 2;
        
        c2.frame = CGRectMake(0, 0, c2.frame.size.width, c2.frame.size.height);
        c2.tag = 1000 + 0;
        
        _loadStatus &= 0x0B;
        
        [self showCell:c1];
    }
    
    if (!(_loadStatus & (1 << 0))) {
        
        [self reloadNext];
    }
    
    if (!(_loadStatus & (1 << 2))) {
        
        [self reloadPrev];
    }
    
    if ([_delegate respondsToSelector:@selector(scrollToPage:loopView:)]) {
        
        CE_ScrollCell *cell = [self currentCell];
        [_delegate scrollToPage:cell.index loopView:self];
        
        //[cell resetZoomScale];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (decelerate) {
        //scrollView.scrollEnabled = NO;
    }
    else {
        //[self scrollViewDidEndDecelerating:scrollView];
    }
}

- (NSArray *)visibleCell {
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:1];
    if (_loadStatus & (1 << 0)) {
        [tmp addObject:[self nextCell]];
    }
    
    if (_loadStatus & (1 << 1)) {
        [tmp addObject:[self currentCell]];
    }
    
    if (_loadStatus & (1 << 2)) {
        [tmp addObject:[self preCell]];
    }
    
    return tmp;
}
@end
