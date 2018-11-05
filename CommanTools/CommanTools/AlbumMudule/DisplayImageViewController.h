//
//  DisplayImageViewController.h
//  GoogFit
//
//  Created by 陈小青 on 16/4/30.
//  Copyright © 2016年 cxq. All rights reserved.
//

#import "BaseViewController.h"

@class ImageAdapter;

@interface DisplayImageViewController : BaseViewController

@property (nonatomic,strong) ImageAdapter *currentAdapter;
@property (nonatomic,strong) NSMutableArray *adapterArray;


@end
