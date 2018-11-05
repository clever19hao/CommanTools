//
//  AlumbImagePickerViewController.m
//  HBSDrone
//
//  Created by Arvin on 2018/9/5.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "AlumbImagePickerViewController.h"
#import <Photos/Photos.h>
#import "HBS_Tools.h"

@interface AlumbImagePickerViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *assetArray;
@property (nonatomic,strong) NSMutableArray *selectArray;

@end

@implementation AlumbImagePickerViewController

- (id)initWithAlreadyAssets:(NSArray <PHAsset *> *)assets {
    
    if (self = [super init]) {
        
        _selectArray = [NSMutableArray arrayWithArray:assets];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = [NSString stringWithFormat:NSLocalizedString(@"photo_selectNumberItem", nil),_selectArray.count];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStyleDone target:self action:@selector(saveAssets)];
    
    _assetArray = [NSMutableArray arrayWithCapacity:1];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PHAssetImageCellId"];
    
    [self.view addSubview:_collectionView];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:1];
        
        NSMutableArray *allCollection = [NSMutableArray arrayWithCapacity:1];
        //[allCollection addObjectsFromArray:[self collectionWithType:PHAssetCollectionTypeAlbum subType:PHAssetCollectionSubtypeAlbumRegular]];
        //[allCollection addObjectsFromArray:[self collectionWithType:PHAssetCollectionTypeAlbum subType:PHAssetCollectionSubtypeAlbumImported]];
        
        //[allCollection addObjectsFromArray:[self collectionWithType:PHAssetCollectionTypeSmartAlbum subType:PHAssetCollectionSubtypeSmartAlbumGeneric]];
        [allCollection addObjectsFromArray:[self collectionWithType:PHAssetCollectionTypeSmartAlbum subType:PHAssetCollectionSubtypeSmartAlbumUserLibrary]];
        
        for (PHAssetCollection *collect in allCollection) {
            
            PHFetchOptions *opt = [[PHFetchOptions alloc] init];
            //opt.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d",PHAssetMediaTypeVideo];
            
            PHFetchResult <PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:collect options:opt];
            
            [assetResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                [tmp addObject:obj];
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_assetArray setArray:tmp];
            
            [_collectionView reloadData];
        });
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        edge = self.view.safeAreaInsets;
    }
    
    _collectionView.frame = CGRectMake(0 + edge.left, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.frame.size.width - edge.left - edge.right, self.view.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - edge.bottom);
    
    CGFloat one_w = ((self.view.frame.size.width - edge.left - edge.right) - 5*1) / 4;
    if (self.view.frame.size.width > self.view.frame.size.height) {
        one_w = ((self.view.frame.size.width - edge.left - edge.right) - 7*1) / 6;
    }
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    if([layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        layout.itemSize = CGSizeMake(one_w, one_w);
    }
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (NSArray <PHAssetCollection *> *)collectionWithType:(PHAssetCollectionType)type subType:(PHAssetCollectionSubtype)subType {
    
    NSMutableArray *collections = [NSMutableArray arrayWithCapacity:1];
    
    PHFetchResult <PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:type subtype:subType options:nil];
    
    [collectionResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [collections addObject:obj];
    }];
    
    return collections;
}

- (void)saveAssets {
    
    if ([_delegate respondsToSelector:@selector(didPickerAlumbImage:)]) {
        [_delegate didPickerAlumbImage:_selectArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString *)stringFromSeconds:(NSTimeInterval)duration {
    
    int seconds = (int)duration;
    
    int h = (int)(seconds / 3600);
    int m = (seconds % 3600)/60;
    int s = seconds%60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_assetArray count];
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PHAssetImageCellId" forIndexPath:indexPath];
    
    UIImageView *ivImage = (UIImageView *)[cell.contentView viewWithTag:8888];
    if (!ivImage) {
        ivImage = [[UIImageView alloc] initWithFrame:cell.bounds];
        ivImage.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        ivImage.tag = 8888;
        [cell.contentView addSubview:ivImage];
    }
    
    UIImageView *ivFlag = (UIImageView *)[cell.contentView viewWithTag:8889];
    if (!ivFlag) {
        ivFlag = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 16, cell.frame.size.height - 16, 15, 15)];
        ivFlag.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
        ivFlag.tag = 8889;
        [cell.contentView addSubview:ivFlag];
    }
    
    UIImageView *ivVideo = (UIImageView *)[cell.contentView viewWithTag:8890];
    if (!ivVideo) {
        ivVideo = [[UIImageView alloc] initWithFrame:CGRectMake(1, cell.frame.size.height - 9, 14, 8)];
        ivVideo.image = [UIImage imageNamed:@"video"];
        ivVideo.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
        ivVideo.tag = 8890;
        ivVideo.layer.shadowColor = [UIColor blackColor].CGColor;
        ivVideo.layer.shadowOpacity = 0.5;
        ivVideo.layer.shadowOffset = CGSizeMake(0, 0);
        [cell.contentView addSubview:ivVideo];
    }
    
    UILabel *lbDuration = (UILabel *)[cell.contentView viewWithTag:8891];
    if (!lbDuration) {
        lbDuration = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, cell.frame.size.width/2, 10)];
        lbDuration.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
        lbDuration.tag = 8891;
        lbDuration.adjustsFontSizeToFitWidth = YES;
        lbDuration.font = [UIFont systemFontOfSize:10];
        lbDuration.textColor = [UIColor whiteColor];
        lbDuration.layer.shadowColor = [UIColor blackColor].CGColor;
        lbDuration.layer.shadowOpacity = 0.5;
        lbDuration.layer.shadowOffset = CGSizeMake(0, 0);
        [cell.contentView addSubview:lbDuration];
    }
    
    PHAsset *asset = [_assetArray objectAtIndex:indexPath.row];
    
    if (asset.mediaType == PHAssetMediaTypeImage) {
        ivVideo.hidden = YES;
        lbDuration.hidden = YES;
    }
    else {
        ivVideo.hidden = NO;
        lbDuration.hidden = NO;
        lbDuration.text = [self stringFromSeconds:asset.duration];
    }
    
    if (![_selectArray containsObject:asset]) {
        ivFlag.image = [UIImage imageNamed:@"choose_01"];
    }
    else {
        ivFlag.image = [UIImage imageNamed:@"choose"];
    }
    
    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
    opt.resizeMode = PHImageRequestOptionsResizeModeFast;
    opt.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        ivImage.image = result;
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PHAsset *asset = [_assetArray objectAtIndex:indexPath.row];
    
    if ([_selectArray containsObject:asset]) {
        [_selectArray removeObject:asset];
    }
    else {
        if ([_selectArray count] >= 9) {
            [HBS_Tools showToast:@"选择图片达到最大值"];
        }
        else {
            [_selectArray addObject:asset];
        }
    }
    
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    self.title = [NSString stringWithFormat:NSLocalizedString(@"photo_selectNumberItem", nil),_selectArray.count];
}


@end
