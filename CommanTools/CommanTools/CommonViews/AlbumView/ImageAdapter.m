//
//  ImageAdapter.m
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/21.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "ImageAdapter.h"

@implementation ImageAdapter

- (instancetype)initWithData:(id)data {
    
    if (self = [super init]) {
        _data = data;
    }
    
    return self;
}

#pragma mark - ImageAdapterProtocol
- (UIImage *)thumbImage {
    
    return nil;
}

- (double)duration {
    
    return 0;
}

- (NSString *)createDate {
    return nil;
}

- (NSString *)location {
    return nil;
}


- (NSString *)name {
    return nil;
}


- (UIImage *)originImage {
    return nil;
}


- (NSString *)path {
    return nil;
}

- (BOOL)isShowDuration {
    return NO;
}

- (BOOL)isShowVideoFlag {
    return NO;
}

@end
