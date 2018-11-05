//
//  AlumbImagePickerViewController.h
//  HBSDrone
//
//  Created by Arvin on 2018/9/5.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "BaseViewController.h"

@class PHAsset;

@protocol AlumbImagePickerDelegate <NSObject>

- (void)didPickerAlumbImage:(NSArray <PHAsset *> *)assets;

@end

@interface AlumbImagePickerViewController : BaseViewController

@property (nonatomic,weak) id <AlumbImagePickerDelegate> delegate;

- (id)initWithAlreadyAssets:(NSArray <PHAsset *> *)assets;

@end
