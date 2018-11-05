//
//  CE_LoopView.h
//  CommanApp
//
//  Created by cxq on 16/5/28.
//  Copyright © 2016年 cxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CE_LoopView;
@class CE_ScrollCell;

@protocol  CE_LoopViewDelegate <NSObject>

@optional
- (NSInteger)numberOfSource;

- (void)loadScrollCell:(CE_ScrollCell *)cell loopView:(CE_LoopView *)loopView;

- (void)scrollToPage:(NSInteger)pageIndex loopView:(CE_LoopView *)loopView;

- (void)didSingleTouchCell:(CE_ScrollCell *)cell loopView:(CE_LoopView *)loopView;

@end

@interface CE_LoopView : UIView

@property (nonatomic,weak,readonly) id <CE_LoopViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id <CE_LoopViewDelegate>)delegate;

- (void)showPage:(NSInteger)pageIndex;

- (NSArray *)visibleCell;

@end
