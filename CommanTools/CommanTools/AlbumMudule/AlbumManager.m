//
//  AlbumManager.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/15.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "AlbumManager.h"
#import "LocalFile.h"

NSString *LocalFileChangedNotice = @"LocalFileChangedNotice";

#define IMG_DIR [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"HY012/image"]

#define VIDEO_DIR [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"HY012/video"]

@implementation AlbumManager
{
    dispatch_queue_t loadQueue;
    NSMutableDictionary <NSString *,NSMutableArray <LocalFile *> *> *imageInfo;
    NSMutableDictionary <NSString *,NSMutableArray <LocalFile *> *> *videoInfo;
}

+ (AlbumManager *)shareManager {
    
    static AlbumManager *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!ins) {
            ins = [[AlbumManager alloc] init];
        }
    });
    return ins;
}

- (id)init {
    
    if (self = [super init]) {
        loadQueue = dispatch_queue_create("com.HY012_iOS.AlbumQueue", DISPATCH_QUEUE_SERIAL);
        imageInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        videoInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return self;
}

- (LocalFile *)localFileWithPath:(NSString *)path group:(NSString *)group {
    
    LocalFile *local = nil;
    NSArray *groups = nil;
    
    BOOL isVideo = [LocalFile isVideoFile:path.lastPathComponent];
    if (isVideo) {
        groups = [videoInfo objectForKey:group];
    }
    else {
        groups = [imageInfo objectForKey:group];
    }
    
    for (LocalFile *d in groups) {//从缓存中取
        
        if ([d.name isEqualToString:path.lastPathComponent]) {
            
            local = d;
            
            break;
        }
    }
    
    if (!local) {
        local = [[LocalFile alloc] initWithFilePath:path];
    }
    
    return local;
}

- (void)asyncRequestLocalFile:(BOOL)isVideo {
    
    dispatch_async(loadQueue, ^{
        
        NSMutableDictionary *tmpInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        
        NSString *dir = IMG_DIR;
        if (isVideo) {
            dir = VIDEO_DIR;
        }
        
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
        
        for (NSString *filename in files) {
            
            if (![LocalFile isImageFile:filename] && ![LocalFile isVideoFile:filename]) {
                continue;
            }
            
            NSString *path = [dir stringByAppendingPathComponent:filename];
            
            NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            
            NSDate *create = [attr fileCreationDate];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [format stringFromDate:create];
            
            NSMutableArray *tmp = [tmpInfo objectForKey:dateStr];
            if (!tmp) {
                tmp = [NSMutableArray arrayWithCapacity:1];
                [tmpInfo setObject:tmp forKey:dateStr];
            }
            
            LocalFile *d = [self localFileWithPath:path group:dateStr];
            d.groupKey = dateStr;
            d.fileCreateDate = create;
            [tmp addObject:d];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (isVideo) {
                [self->videoInfo setDictionary:tmpInfo];
            }
            else
            {
                [self->imageInfo setDictionary:tmpInfo];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LocalFileChangedNotice object:nil];
        });
    });
}

- (NSDictionary<NSString *,NSArray<LocalFile *> *> *)localFile:(BOOL)isVideo {
    
    if (isVideo) {
        return videoInfo;
    }
    return imageInfo;
}

- (void)removeLocalDatas:(NSDictionary<NSString *,NSArray <LocalFile *> *> *)removeDataInfo isVideo:(BOOL)isVideo {
    
    dispatch_async(loadQueue, ^{
        
        for (NSArray *deletes in [removeDataInfo allValues]) {
            
            for (LocalFile *local in deletes) {
                
                [[NSFileManager defaultManager] removeItemAtPath:local.path error:nil];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (NSString *key in [removeDataInfo allKeys]) {
                
                NSArray *removeArray = [removeDataInfo objectForKey:key];
                
                if (isVideo) {
                    NSMutableArray *tmp = [self->videoInfo objectForKey:key];
                    [tmp removeObjectsInArray:removeArray];
                }
                else {
                    NSMutableArray *tmp = [self->imageInfo objectForKey:key];
                    [tmp removeObjectsInArray:removeArray];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LocalFileChangedNotice object:nil];
        });
    });
}

- (void)clearFileCache {
    
    dispatch_async(loadQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self->videoInfo removeAllObjects];
            [self->imageInfo removeAllObjects];
        });
    });
}
@end
