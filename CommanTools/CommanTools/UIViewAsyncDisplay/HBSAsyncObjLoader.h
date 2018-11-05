//
//  HBSAsyncObjLoader.h
//  HBSDrone
//
//  Created by Arvin on 2018/11/1.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AsyncLoad;
@class AsyncLoadId;

@interface HBSAsyncObjLoader : NSObject

+ (instancetype)shareLoader;

- (void)setConcurrentOperationCount:(NSInteger)count;

- (void)cancelLoadId:(AsyncLoadId *)loadId;

- (id)startLoadWithObj:(id <AsyncLoad>)obj key:(NSString *)key complete:(void (^)(id obj,NSError *error))complete;

@end
