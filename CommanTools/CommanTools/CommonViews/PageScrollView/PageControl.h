//
//  PageControl.h
//  HBSDrone
//
//  Created by Arvin on 2018/3/17.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControl : UIView

@property (nonatomic,assign) int count;
@property (nonatomic,assign,readonly) int selectIndex;

@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *selectColor;

- (void)setSelectIndex:(int)selectIndex animte:(BOOL)animate;


@end
