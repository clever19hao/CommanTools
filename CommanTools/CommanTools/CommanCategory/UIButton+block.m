//
//  UIButton+block.m
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/11/9.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "UIButton+block.h"
#import <objc/runtime.h>

static char act = 'a';

@implementation UIButton (block)

- (void)setTouchHandle:(void (^)(UIButton *btn))handle {
    
    [self addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(self, &act, handle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)press:(UIButton *)btn {
    
    void (^handle)(UIButton *btn) = objc_getAssociatedObject(self, &act);
    if (handle) {
        handle(btn);
    }
}


@end
