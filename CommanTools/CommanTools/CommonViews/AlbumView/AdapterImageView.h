//
//  AdapterImageView.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/21.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAdapter.h"

@interface AdapterImageView : UIImageView

- (void)loadData:(ImageAdapter *)data;

@end
