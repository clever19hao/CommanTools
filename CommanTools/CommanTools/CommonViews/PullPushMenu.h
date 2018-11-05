//
//  PullPushMenu.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/6.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullPushMenu : UIView

@property (nonatomic,assign) int selectIndex;
@property (nonatomic,assign,readonly) BOOL isExpand;
@property (nonatomic,copy) void (^didSelectMenu)(int index);

- (id)initWithShrinkFrame:(CGRect)rect itemSize:(CGSize)size;

- (void)setTitles:(NSArray *)titles pairImages:(NSArray *)imgNames;

- (void)shrink;

@end
