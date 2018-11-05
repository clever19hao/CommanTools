//
//  AlbumManager.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/15.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *LocalFileChangedNotice;
@class LocalFile;

@interface AlbumManager : NSObject

+ (AlbumManager *)shareManager;

- (void)asyncRequestLocalFile:(BOOL)isVideo;

- (NSDictionary<NSString *,NSArray<LocalFile *> *> *)localFile:(BOOL)isVideo;

- (void)removeLocalDatas:(NSDictionary<NSString *,NSArray <LocalFile *> *> *)removeDataInfo isVideo:(BOOL)isVideo;

- (void)clearFileCache;

@end
