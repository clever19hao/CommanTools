//
//  AsyncLoadOperation.h
//  HBSDrone
//
//  Created by Arvin on 2018/11/3.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
  AppErrorCodeObjIsNil = -1
};

@protocol AsyncLoad;
@class AsyncLoadId;

typedef void (^loadComplete)(id obj,NSError *error);

@interface AsyncLoadOperation : NSOperation

@property (nonatomic,strong,readonly) id <AsyncLoad> asyncObj;
@property (nonatomic,copy,readonly) NSString *loadKey;

- (instancetype)initWithObj:(id <AsyncLoad>)obj key:(NSString *)keys;

- (AsyncLoadId *)addLoadComplete:(loadComplete)complete;

- (BOOL)removeLoadComplete:(id)addId;

@end
