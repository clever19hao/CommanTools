//
//  PresentAnimation.h
//  HBSDrone
//
//  Created by Arvin on 2018/9/3.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PresentAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) BOOL isPresent;

@end
