//
//  UIButton+block.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/11/9.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (block)

- (void)setTouchHandle:(void (^)(UIButton *btn))handle;

@end
