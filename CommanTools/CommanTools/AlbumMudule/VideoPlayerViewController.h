//
//  VideoPlayerViewController.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/11/15.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@class ImageAdapter;

@interface VideoPlayerViewController : AVPlayerViewController

@property (nonatomic,strong) ImageAdapter *adapter;

@end
