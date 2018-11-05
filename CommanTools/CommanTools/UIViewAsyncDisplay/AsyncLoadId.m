//
//  AsyncLoadId.m
//  HBSDrone
//
//  Created by Arvin on 2018/11/3.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "AsyncLoadId.h"
#import "AsyncLoad.h"

@implementation AsyncLoadId

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (BOOL)isEqualKeyWithObj:(id <AsyncLoad>)obj key:(NSString *)loadKey {
    
    NSString *fullKey = [NSString stringWithFormat:@"%@_%@_%@",NSStringFromClass([obj class]),[obj asyncObjKey],loadKey];
    
    return [_key isEqualToString:fullKey];
}

@end
