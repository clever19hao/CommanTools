//
//  AlumbPreview.h
//  HBSDrone
//
//  Created by Arvin on 2018/8/28.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 层叠显示图片,左右滑动会切换图片显示
 */
@interface AlumbPreview : UIView

@property (nonatomic,copy) void (^selectIndex)(NSInteger index);//选中第几张
@property (nonatomic,assign,readonly) NSInteger currentIndex;//当前显示的图片

@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,assign) NSTimeInterval duration;

/**
 显示图片或视频缩略图

 @param items
 */
- (void)displayWithItems:(NSArray *)items;

@end
