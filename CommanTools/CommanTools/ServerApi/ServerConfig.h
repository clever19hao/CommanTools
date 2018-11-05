//
//  ServerConfig.h
//  HY012_iOS
//
//  Created by Arvin on 2018/8/10.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConfig : NSObject

@property (class, readonly, strong) ServerConfig *defaultConfig;

@property (nonatomic,strong,readonly) NSString *ostype;
@property (nonatomic,strong,readonly) NSString *versioncode;
@property (nonatomic,strong,readonly) NSString *deviceid;
@property (nonatomic,strong,readonly) NSString *token;

- (void)updateWithToken:(NSString *)encrypt_token;

//每次获取可能都不一样
- (NSMutableDictionary *)configParam;

-(NSString*)createUuid;

@end
