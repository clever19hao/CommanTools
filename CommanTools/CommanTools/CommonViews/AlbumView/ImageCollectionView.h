//
//  ImageCollectionView.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/31.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageAdapter;
@class ImageCollectionView;

/**
 图片选择变更协议
 */
@protocol ImageCollectionViewDelegate <NSObject>
@optional
- (void)imageCollectionView:(ImageCollectionView *)imageCollectionView didSelectImage:(NSArray <NSArray <ImageAdapter *> *> *)images;

- (void)imageCollectionView:(ImageCollectionView *)imageCollectionView didPressItem:(ImageAdapter *)adapter;

@end

@interface ImageCollectionView : UIView

@property (nonatomic,weak) id <ImageCollectionViewDelegate> delegate;

@property (nonatomic,assign,readonly) BOOL isEditing;

@property (nonatomic,strong,readonly) NSMutableArray <NSMutableArray <ImageAdapter *> *>* dataArray;

- (void)reloadViewWithData:(NSArray <NSArray <ImageAdapter *> *>* )dataArray;

- (void)reloadData;

- (void)setIsEditing:(BOOL)isEditing isSelectAll:(BOOL)selectAll;

- (BOOL)isSelectAll;

@end
