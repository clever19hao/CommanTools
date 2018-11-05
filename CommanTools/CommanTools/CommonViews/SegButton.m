//
//  SegButton.m
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/11/8.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "SegButton.h"

@implementation SegButton
{
    NSArray *titleArray;
    NSArray *imageArray;
    NSArray *selectImageArray;
    
    UIView *line;
}

- (void)layoutSubviews {

    [super layoutSubviews];

    [self layoutSubViewsFrames];
}

- (void)layoutSubViewsFrames {
    
    NSInteger count = MAX([titleArray count], [imageArray count]);
    CGFloat btn_w = self.frame.size.width / count;
    
    for (int i = 0; i < count; i++) {
        
        UIButton *btn = [self viewWithTag:1000 + i];
        btn.frame = CGRectMake(i * btn_w, 0, btn_w, self.frame.size.height - _safeEdgeInsets.bottom);
    }
    
    line.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
}

- (void)setItem:(NSInteger)index selected:(BOOL)selected {
    
    UIButton *btn = [self viewWithTag:1000 + index];
    btn.selected = selected;
}

- (void)setItem:(NSInteger)index enabled:(BOOL)enabled {
    
    UIButton *btn = [self viewWithTag:1000 + index];
    btn.enabled = enabled;
}

- (void)setItems:(NSArray <UIImage *> *)normalImages selectImages:(NSArray <UIImage *> *)selectImages {
    
    NSInteger count = MAX([selectImageArray count], [imageArray count]);
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = [self viewWithTag:1000 + i];
        [btn removeFromSuperview];
    }
    
    imageArray = normalImages;
    selectImageArray = selectImages;
    
    count = MAX([selectImageArray count], [imageArray count]);
    CGFloat btn_w = self.frame.size.width / count;
    
    for (int i = 0; i < count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * btn_w, 0, btn_w, self.frame.size.height - _safeEdgeInsets.bottom)];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        if ([imageArray count] > i) {
            
            [btn setImage:imageArray[i] forState:UIControlStateNormal];
        }
        
        if ([selectImageArray count] > i) {
            [btn setImage:selectImageArray[i] forState:UIControlStateSelected];
            [btn setImage:selectImageArray[i] forState:UIControlStateHighlighted];
        }
        
        [self addSubview:btn];
    }
}

- (void)setItems:(NSArray <NSString *> *)titles imgs:(NSArray <UIImage *> *)imgs {
    
    NSInteger count = MAX([titleArray count], [imageArray count]);
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = [self viewWithTag:1000 + i];
        [btn removeFromSuperview];
    }
    
    titleArray = titles;
    imageArray = imgs;
    
    count = MAX([titleArray count], [imageArray count]);
    CGFloat btn_w = self.frame.size.width / count;
    
    for (int i = 0; i < count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * btn_w, 0, btn_w, self.frame.size.height - _safeEdgeInsets.bottom)];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        if ([titleArray count] > i) {
            
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        }
        
        if ([imageArray count] > i) {
            
            [btn setImage:imageArray[i] forState:UIControlStateNormal];
        }
        
        [self addSubview:btn];
    }
    
    if (!line) {
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
        //[self addSubview:line];
    }
}

- (void)pressBtn:(UIButton *)btn {
    
    if (self.pressHandle) {
        self.pressHandle(btn.tag - 1000);
    }
}

@end
