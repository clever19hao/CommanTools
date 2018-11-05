//
//  HBSDownloadImageOperation.m
//  HBSDrone
//
//  Created by Arvin on 2018/9/25.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "HBSDownloadImageOperation.h"

@implementation HBSDownloadImageOperation

- (id (^)(NSData *responseData,NSURL *url))downloadCompleteHandle {
    
    return ^id(NSData *responseData,NSURL *url) {
        
        UIImage *img = [UIImage imageWithData:responseData];
        
        return img;
    };
}

@end
