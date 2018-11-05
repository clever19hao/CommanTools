//
//  GridButtonMenu.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/11/6.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 类似九宫格一样的按钮菜单
 */
@interface GridButtonMenu : UIView

@property (nonatomic,assign) CGSize itemSize;
@property (nonatomic,assign) CGFloat itemSpace;
@property (nonatomic,strong) UIColor *selectColor;
@property (nonatomic,strong) UIColor *normalColor;//default white color

@property (nonatomic,strong) NSIndexPath *selectIndexPath;

@property (nonatomic,copy) void (^selectHandle)(NSIndexPath *indexPath);

- (void)setMenuItemsWithTitles:(NSArray <NSArray <NSString *> *> *)titles;

@end
