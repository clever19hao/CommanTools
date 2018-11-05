//
//  ServerConfig.m
//  HY012_iOS
//
//  Created by Arvin on 2018/8/10.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "ServerConfig.h"
#import <UIKit/UIKit.h>
#import "RSA.h"
#import "NSObject_property.h"

@implementation ServerConfig
{
    NSString *rsa_public_key;
    NSString *clientWillDecryptToken;
    NSString *clientDidEncryptToken;
}

+ (ServerConfig *)defaultConfig {
    static ServerConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!config) {
            config = [[ServerConfig alloc] init];
        }
    });
    
    return config;
}

- (id)init {
    
    if (self = [super init]) {
        
        _deviceid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        _ostype = @"ios";
        _versioncode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        rsa_public_key = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rsa_public_key" ofType:@"pem"] encoding:NSUTF8StringEncoding error:nil];        
    }
    
    return self;
}

- (void)updateWithToken:(NSString *)encrypt_token {
    
    clientWillDecryptToken = [encrypt_token copy];
    _token = [RSA decryptString:[clientWillDecryptToken substringFromIndex:20] publicKey:rsa_public_key];
    clientDidEncryptToken = [RSA encryptString:_token publicKey:rsa_public_key];
}

- (NSMutableDictionary *)configParam {
    
    NSMutableDictionary *propertyInfo = [self get_propertyInfo];
    
    if (propertyInfo[@"token"]) {
        propertyInfo[@"token"] = [NSString stringWithFormat:@"%@%@",[self createUuid],clientDidEncryptToken];
    }
    
    return propertyInfo;
}

-(NSString*)createUuid
{
    char data[20];
    for (int x=0;x<20;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:20 encoding:NSUTF8StringEncoding];
}
@end
