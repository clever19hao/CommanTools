//
//  NSObject+Safe.h
//  HY012_iOS
//
//  Created by Arvin on 2018/8/10.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Safe)

- (NSString *)safe_stringValue;

- (int)safe_intValue;

- (long long)safe_longLongValue;

- (float)safe_floatValue;

- (double)safe_doubleValue;

@end

@interface NSDictionary (Safe)

- (NSString *)safe_stringForKey:(NSString *)key;

- (int)safe_intForKey:(NSString *)key;

- (long long)safe_longLongForKey:(NSString *)key;

- (float)safe_floatForKey:(NSString *)key;

- (double)safe_doubleForKey:(NSString *)key;

@end
