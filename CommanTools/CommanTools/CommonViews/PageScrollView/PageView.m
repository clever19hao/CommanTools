//
//  PageView.m
//  HBSDrone
//
//  Created by Arvin on 2018/3/20.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "PageView.h"

@implementation PageView
@synthesize imageView = _imageView;

- (void)layoutSubviews {
    
    _imageView.frame = self.bounds;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

@end
