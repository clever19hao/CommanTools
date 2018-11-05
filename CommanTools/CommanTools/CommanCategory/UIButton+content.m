//
//  UIButton+content.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/6.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "UIButton+content.h"
#import <objc/runtime.h>

static char img_key;
static char alpha_key;
static char select_key;

static char imageView_key;
static char titleLabel_key;

@implementation UIButton (content)

- (void)setBtnSelected:(BOOL)selected {
    
    UIImageView *iv = objc_getAssociatedObject(self, &img_key);
    
    if (selected) {

        if (iv.highlightedImage) {
            iv.highlighted = YES;
        }
        
        [self customImageView].highlighted = YES;
        [self customTitleLabel].highlighted = YES;
    }
    else {
        
        if (iv.highlightedImage) {
            iv.highlighted = NO;
        }
        
        [self customImageView].highlighted = NO;
        [self customTitleLabel].highlighted = NO;
    }
    
    objc_setAssociatedObject(self, &select_key, [NSNumber numberWithBool:selected], OBJC_ASSOCIATION_RETAIN);
}

- (void)touchBegin {
    
    UIImageView *iv = objc_getAssociatedObject(self, &img_key);
    
    if (iv.highlightedImage) {
        iv.highlighted = YES;
    }
    else {
        NSNumber *n_alpha = objc_getAssociatedObject(self, &alpha_key);
        if (!n_alpha) {
            n_alpha = [NSNumber numberWithDouble:self.alpha];
            objc_setAssociatedObject(self, &alpha_key, n_alpha, OBJC_ASSOCIATION_RETAIN);
        }
        iv.alpha = 0.4 * [n_alpha doubleValue];
    }
    
    [self customImageView].highlighted = YES;
    [self customTitleLabel].highlighted = YES;
}

- (void)touchEnd {
    
    UIImageView *iv = objc_getAssociatedObject(self, &img_key);
    
    BOOL isSelect = [objc_getAssociatedObject(self, &select_key) boolValue];
    
    if (isSelect) {
        iv.highlighted = YES;
        
        [self customImageView].highlighted = YES;
        [self customTitleLabel].highlighted = YES;
    }
    else
    {
        iv.highlighted = NO;
        
        [self customImageView].highlighted = NO;
        [self customTitleLabel].highlighted = NO;
    }
    
    NSNumber *n_alpha = objc_getAssociatedObject(self, &alpha_key);
    if (n_alpha) {
        iv.alpha = [n_alpha doubleValue];
    }
}

//图片是3倍图
- (void)setImage_3x:(UIImage *)normal highlighted:(UIImage *)highlightedImage {
    
    UIImageView *iv = objc_getAssociatedObject(self, &img_key);
    if (!iv) {
        iv = [[UIImageView alloc] init];
        objc_setAssociatedObject(self, &img_key, iv, OBJC_ASSOCIATION_RETAIN);
        
        [self addTarget:self action:@selector(touchBegin) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchEnd) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(touchEnd) forControlEvents:UIControlEventTouchUpInside];
    }
    iv.image = normal;
    iv.highlightedImage = highlightedImage;
    [self addSubview:iv];
    CGSize size = normal.size;
    iv.frame = CGRectMake(0, 0, size.width*normal.scale/3, size.height*normal.scale/3);
    iv.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

//图片是2倍图
- (void)setImage_2x:(UIImage *)normal highlighted:(UIImage *)highlightedImage {
    
    UIImageView *iv = objc_getAssociatedObject(self, &img_key);
    if (!iv) {
        iv = [[UIImageView alloc] init];
        objc_setAssociatedObject(self, &img_key, iv, OBJC_ASSOCIATION_RETAIN);
        
        [self addTarget:self action:@selector(touchBegin) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchEnd) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(touchEnd) forControlEvents:UIControlEventTouchUpInside];
    }
    iv.image = normal;
    iv.highlightedImage = highlightedImage;
    [self addSubview:iv];
    CGSize size = normal.size;
    iv.frame = CGRectMake(0, 0, size.width*normal.scale/2, size.height*normal.scale/2);
    iv.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

//图片是1倍图
- (void)setImage_1x:(UIImage *)normal highlighted:(UIImage *)highlightedImage {
    
    UIImageView *iv = objc_getAssociatedObject(self, &img_key);
    if (!iv) {
        iv = [[UIImageView alloc] init];
        objc_setAssociatedObject(self, &img_key, iv, OBJC_ASSOCIATION_RETAIN);
        
        [self addTarget:self action:@selector(touchBegin) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchEnd) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(touchEnd) forControlEvents:UIControlEventTouchUpInside];
    }
    iv.image = normal;
    iv.highlightedImage = highlightedImage;
    [self addSubview:iv];
    CGSize size = normal.size;
    iv.frame = CGRectMake(0, 0, size.width*normal.scale/1, size.height*normal.scale/1);
    iv.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)setImageView:(UIImageView *)imageView title:(UILabel *)titleLabel {
    
    objc_setAssociatedObject(self, &imageView_key, imageView, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &titleLabel_key, titleLabel, OBJC_ASSOCIATION_RETAIN);
    
    [self removeTarget:self action:@selector(touchBegin) forControlEvents:UIControlEventTouchDown];
    [self removeTarget:self action:@selector(touchEnd) forControlEvents:UIControlEventTouchUpOutside];
    [self removeTarget:self action:@selector(touchEnd) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchBegin) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchEnd) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(touchEnd) forControlEvents:UIControlEventTouchUpInside];
}

- (UIImageView *)customImageView {
    
    return objc_getAssociatedObject(self, &imageView_key);
}

- (UILabel *)customTitleLabel {
    return objc_getAssociatedObject(self, &titleLabel_key);
}
@end
