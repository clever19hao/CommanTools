//
//  GeocoderManager.m
//  HBSDrone
//
//  Created by Arvin on 2018/11/4.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "GeocoderManager.h"
#import <CoreLocation/CoreLocation.h>

NSErrorDomain const GeocoderErrorDomain = @"GeocoderErrorDomain";

@interface GeocodeObj : NSObject

@property (nonatomic,strong) CLLocation *location;
@property (nonatomic,copy) void (^complete)(CLPlacemark *place,NSError *error);

@end

@implementation GeocodeObj
@end

#pragma mark - GeocoderManager

@interface GeocoderManager ()

@property (nonatomic,strong) NSMutableArray <GeocodeObj *> *geocodeArray;
@property (nonatomic,strong) CLGeocoder *geocoder;
@property (nonatomic) dispatch_queue_t queue;

@property (nonatomic,strong) NSDate *lastGeocoderDate;
@property (nonatomic,strong) GeocodeObj *currentObj;
@property (nonatomic,strong) NSMutableArray <CLPlacemark *> *placemarkArray;

@end

@implementation GeocoderManager

+ (void)reverseGeocodeLocation:(CLLocation *)location complete:(void (^)(CLPlacemark *place,NSError *error))complete {
    
    GeocodeObj *obj = [[GeocodeObj alloc] init];
    obj.location = location;
    obj.complete = complete;
    
    [[GeocoderManager shareGeocode] reverseGeocode:obj];
}

+ (void)clear {
    
    [[GeocoderManager shareGeocode].placemarkArray removeAllObjects];
    [[GeocoderManager shareGeocode].geocodeArray removeAllObjects];
    [GeocoderManager shareGeocode].lastGeocoderDate = nil;
    [GeocoderManager shareGeocode].currentObj = nil;
}

+ (instancetype)shareGeocode {
    
    static id ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [self new];
    });
    return ins;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _placemarkArray = [NSMutableArray array];
        _geocodeArray = [NSMutableArray array];
        _geocoder = [CLGeocoder new];
        _queue = dispatch_queue_create("com.X-Hubsan.GeocoderQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)reverseGeocode:(GeocodeObj *)obj {
    
    dispatch_async(_queue, ^{
        [_geocodeArray addObject:obj];
        [self handleGeocodeQueue];
    });
}

- (void)handleGeocodeQueue {
    
    if (_currentObj) {
        return;
    }
    
    if (_geocoder.isGeocoding) {
        
        [_geocoder cancelGeocode];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), _queue, ^{
            [self handleGeocodeQueue];
        });
        
        return;
    }
    
    _currentObj = [_geocodeArray lastObject];
    if (!_currentObj) {
        return;
    }
    
    if (_lastGeocoderDate && [[NSDate date] timeIntervalSinceDate:_lastGeocoderDate] < 60) {//找缓存
        
        CLPlacemark *placemark = [self getMostSuitablePlacemark:YES];
        
        if (placemark) {
            [self handleResultWith:placemark error:[NSError errorWithDomain:GeocoderErrorDomain code:AppErrorCodeReusePlacemark userInfo:@{NSLocalizedDescriptionKey:@"Reuse last placemark!"}]];
            return;
        }
    }
    
    [_geocoder cancelGeocode];
    
    _lastGeocoderDate = [NSDate date];
    [_geocoder reverseGeocodeLocation:_currentObj.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        [self handleResultWith:placemarks.firstObject error:error];
    }];
}

- (CLPlacemark *)getMostSuitablePlacemark:(BOOL)canBeNil {
    
    CLPlacemark *placemark = nil;
    float lastDis = 2000;
    
    if (!canBeNil) {
        placemark = [_placemarkArray lastObject];
        lastDis = [placemark.location distanceFromLocation:_currentObj.location];
    }
    
    for (CLPlacemark *place in _placemarkArray) {
        
        float dis = [place.location distanceFromLocation:_currentObj.location];
        
        if (dis < lastDis) {
            placemark = place;
        }
    }
    
    return placemark;
}

- (void)handleResultWith:(CLPlacemark *)placemark error:(NSError *)error {
    
    dispatch_async(_queue, ^{
        
        if (placemark) {
            [_placemarkArray addObject:placemark];
            if ([_placemarkArray count] > 20) {
                [_placemarkArray removeObjectAtIndex:0];
            }
            if (_currentObj.complete) {
                _currentObj.complete(placemark, error);
            }
        }
        else {
            if (_currentObj.complete) {
                _currentObj.complete([self getMostSuitablePlacemark:NO], error);
            }
        }
        
        [_geocodeArray removeObject:_currentObj];
        _currentObj = nil;
        
        [self handleGeocodeQueue];
    });
}
@end
