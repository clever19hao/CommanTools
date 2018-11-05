//
//  SliderMenuView.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/21.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemView : UIView

@property (nonatomic,strong,readonly) UILabel *lbContent;

@end

@interface SliderMenuView : UIView

@property (nonatomic,assign,readonly) int currentIndex;
@property (nonatomic,assign,readonly) int numberOfData;
@property (nonatomic,strong,readonly) UILabel *titleLabel;
@property (nonatomic,strong) UIColor *selectColor;//default white color
@property (nonatomic,strong) UIColor *normalColor;//default gray color
@property (nonatomic,assign) CGSize itemViewSize;

@property (nonatomic,copy) void (^selectItem)(int index,id obj);

//刷新某一页视图
- (void)reloadItem:(int)index;

- (void)scrollToIndex:(int)index animate:(BOOL)animate;

- (void)reloadSliderWithItems:(NSArray *)items;

@end
