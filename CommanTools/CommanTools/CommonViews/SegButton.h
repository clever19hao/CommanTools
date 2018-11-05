//
//  SegButton.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/11/8.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegButton : UIView

@property (nonatomic,copy) void (^pressHandle)(NSInteger index);

@property (nonatomic,assign) UIEdgeInsets safeEdgeInsets;

- (void)setItems:(NSArray <NSString *> *)titles imgs:(NSArray <UIImage *> *)imgs;

- (void)setItems:(NSArray <UIImage *> *)normalImages selectImages:(NSArray <UIImage *> *)selectImages;

- (void)setItem:(NSInteger)index enabled:(BOOL)enabled;

- (void)setItem:(NSInteger)index selected:(BOOL)selected;

@end
