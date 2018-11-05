//
//  PageScrollView.h
//  HBSDrone
//
//  Created by Arvin on 2018/3/17.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageView.h"

@class PageScrollView;

@protocol PageScrollViewDelegate <NSObject>

@required
- (int)pageScrollViewNumberOfData;
- (PageView *)pageScrollView:(PageScrollView *)pageScroll pageViewAtIndex:(int)index;

@optional
- (void)pageScrollView:(PageScrollView *)pageScroll didEndScrollToIndex:(int)index;

@end

@interface PageScrollView : UIView

@property (nonatomic,assign,readonly) int numberOfData;
@property (nonatomic,assign,readonly) int currentIndex; 
@property (nonatomic,weak) id <PageScrollViewDelegate> delegate;

//获取可复用的PageView
- (PageView *)dequeueReusablePageView;

- (void)reloadData;

//刷新某一页视图
- (void)reloadPageView:(int)index;

- (void)scrollToIndex:(int)index animate:(BOOL)animate;
@end
