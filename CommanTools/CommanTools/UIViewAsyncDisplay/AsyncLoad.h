//
//  AsyncLoad.h
//  HBSDrone
//
//  Created by Arvin on 2018/11/3.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSErrorDomain const AsyncLoadErrorDomain;

@protocol AsyncLoad <NSObject>

- (NSString *)asyncObjKey;

- (void)asyncLoadDataWithKey:(NSString *)keys complete:(void (^)(id result,NSError *error))complete;

@end
