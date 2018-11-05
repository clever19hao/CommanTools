//
//  AsyncLoadId.h
//  HBSDrone
//
//  Created by Arvin on 2018/11/3.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AsyncLoad;

@interface AsyncLoadId : NSObject

@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) id subId;

- (BOOL)isEqualKeyWithObj:(id <AsyncLoad>)obj key:(NSString *)loadKey;

@end
