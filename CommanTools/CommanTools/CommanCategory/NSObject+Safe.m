//
//  NSObject+Safe.m
//  HY012_iOS
//
//  Created by Arvin on 2018/8/10.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "NSObject+Safe.h"

@implementation NSObject (Safe)

- (NSString *)safe_stringValue {
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self stringValue];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return self ? (NSString *)self : @"";
    }
    
    return @"";
}

- (int)safe_intValue {
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self intValue];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self intValue];
    }
    
    return 0;
}

- (long long)safe_longLongValue {
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self longLongValue];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self longLongValue];
    }
    
    return 0;
}

- (float)safe_floatValue {
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self floatValue];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self floatValue];
    }
    
    return 0.0;
}

- (double)safe_doubleValue {
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self doubleValue];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self doubleValue];
    }
    
    return 0.0;
}

@end

@implementation NSDictionary (Safe)

- (NSString *)safe_stringForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    
    return [value safe_stringValue];
}

- (int)safe_intForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    
    return [value safe_intValue];
}

- (long long)safe_longLongForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    
    return [value safe_longLongValue];
}

- (float)safe_floatForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    
    return [value safe_floatValue];
}

- (double)safe_doubleForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    
    return [value safe_doubleValue];
}

@end
