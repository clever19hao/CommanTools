//
//  UIButton+content.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/6.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 按钮大小和图片大小不一致，让图片不变形的同时适配2倍屏和3倍屏，当只提供一种图片的时候系统方法不会适配两种屏幕.
 当没有@2x或者@3x图时，可以使用该类别取巧
 */
@interface UIButton (content)

//图片是3倍图
- (void)setImage_3x:(UIImage *)normal highlighted:(UIImage *)highlightedImage;

//图片是2倍图
- (void)setImage_2x:(UIImage *)normal highlighted:(UIImage *)highlightedImage;

//图片是1倍图
- (void)setImage_1x:(UIImage *)normal highlighted:(UIImage *)highlightedImage;

//给按钮设置自定义图片和标题
- (void)setImageView:(UIImageView *)imageView title:(UILabel *)titleLabel;

- (UIImageView *)customImageView;
- (UILabel *)customTitleLabel;

- (void)setBtnSelected:(BOOL)selected;

@end
