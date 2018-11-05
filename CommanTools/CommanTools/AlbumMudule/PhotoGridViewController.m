//
//  PhotoGridViewController.m
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/11/6.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "PhotoGridViewController.h"
#import "ImageCollectionView.h"
#import "ImageAdapter.h"
#import "GridButtonMenu.h"
#import "SegButton.h"
#import "UIView+WaitView.h"
#import "VideoPlayerViewController.h"
#import "DownloadCache.h"
#import "AlbumManager.h"
#import "DisplayImageViewController.h"
#import "HBS_Tools.h"

typedef enum {
    FileTypeImage,
    FileTypeVideo,
    FileTypeAll
}FileType;

#define WAITCOLOR   [UIColor colorWithRed:117/255.0 green:251/255.0 blue:214/255.0 alpha:1]

@interface PhotoGridViewController () <ImageCollectionViewDelegate>
{
    
    SegButton *seg;
    NSArray <NSArray <ImageAdapter *> *> * selectArray;
    
    GridButtonMenu *menu;
}

@property (nonatomic,assign) FileType fileType;
@property (nonatomic,strong) ImageCollectionView *collectView;

@end

@implementation PhotoGridViewController
@synthesize collectView;

- (void)dealloc {
    
    [[AlbumManager shareManager] clearFileCache];
    
    [[DownloadCache defaultDownloadCache] drainAll];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = nil;//NSLocalizedString(@"相册",nil);
    self.view.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:55/255.0 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    collectView = [[ImageCollectionView alloc] initWithFrame:CGRectZero];
    collectView.delegate = self;
    [self.view addSubview:collectView];
    
    menu = [[GridButtonMenu alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    menu.itemSize = CGSizeMake(80, 44);
    [menu setMenuItemsWithTitles:@[@[NSLocalizedString(@"图片",nil),NSLocalizedString(@"视频",nil)]]];
    self.navigationItem.titleView = menu;
    menu.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    __weak PhotoGridViewController *tmpSelf = self;
    menu.selectHandle = ^(NSIndexPath *indexPath) {
        
        if (indexPath.row == 0) {
            tmpSelf.fileType = FileTypeImage;
        }
        else if (indexPath.row == 1) {
            tmpSelf.fileType = FileTypeVideo;
        }
    };
    
    seg = [[SegButton alloc] init];
    seg.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:55/255.0 alpha:1];
    seg.hidden = YES;
    [self.view addSubview:seg];
    seg.pressHandle = ^(NSInteger index) {
        [tmpSelf pressSegButton:index];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localFileChanged)
                                                 name:LocalFileChangedNotice
                                               object:nil];
    
    self.fileType = FileTypeImage;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:55/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回",nil) style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"选择",nil) style:UIBarButtonItemStylePlain target:self action:@selector(pressSelect)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} forState:UIControlStateNormal];

    [collectView reloadData];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self layoutSubViewsFrame];
}

- (void)layoutSubViewsFrame {
    
    menu.itemSize = CGSizeMake(80, self.navigationController.navigationBar.frame.size.height);
    [menu layoutSubviews];
    
    CGFloat edge_bottom = 0;
    CGFloat edge_left = 0;
    CGFloat edge_right = 0;
    
    if (@available(iOS 11.0, *)) {
        edge_bottom = self.view.safeAreaInsets.bottom;
        edge_left = self.view.safeAreaInsets.left;
        edge_right = self.view.safeAreaInsets.right;
    }
    
    if (edge_bottom == 0) {
        seg.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    }
    else {
        seg.frame = CGRectMake(0, self.view.frame.size.height - 20 - 44, self.view.frame.size.width, 44);
    }
    
    [self.view setWaitPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];

    if (collectView.isEditing) {
        collectView.frame = CGRectMake(edge_left, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.frame.size.width - edge_right - edge_left, seg.frame.origin.y - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    }
    else {
        collectView.frame = CGRectMake(edge_left, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.frame.size.width - edge_right - edge_left, CGRectGetMaxY(seg.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark - UI Action
- (void)pressBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pressSelect {
    
    [collectView setIsEditing:YES isSelectAll:NO];
}

- (void)pressClear {
    
    [collectView setIsEditing:YES isSelectAll:NO];
}

- (void)pressSelectAll {
    
    [collectView setIsEditing:YES isSelectAll:YES];
}

- (void)pressCancel {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回",nil) style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    [collectView setIsEditing:NO isSelectAll:NO];
}

- (void)pressSegButton:(NSInteger)index {
    
    if (collectView.isEditing) {
        
        if (index == 0) {//删除
            
            __weak PhotoGridViewController *tmpSelf = self;
            __weak NSArray *weakSelect = selectArray;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"photo_deleteSelectedAsk",@"是否删除已选文件？") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:1];
                
                for (int i = 0; i < [weakSelect count]; i++) {
                    
                    ImageAdapter *adapter = [weakSelect[i] firstObject];
                    
                    if (adapter.groupKey) {
                        
                        NSMutableArray *removeArray = [NSMutableArray arrayWithCapacity:1];
                        
                        for (ImageAdapter *tmpAdapter in weakSelect[i]) {
                            
                            [removeArray addObject:tmpAdapter];
                        }
                        
                        [info setObject:removeArray forKey:adapter.groupKey];
                    }
                }
                
                [tmpSelf.view setWaitColor:WAITCOLOR];
                [tmpSelf.view showWait];
                
                [[AlbumManager shareManager] removeLocalDatas:info isVideo:[self isVideo]];
                [tmpSelf.collectView setIsEditing:NO isSelectAll:NO];
                
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:cancel];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (index == 1) {
            
            int count = 0;
            ImageAdapter *adapter = nil;
            
            for (NSArray *tmp in selectArray) {

                if (!adapter && tmp.count) {
                    adapter = tmp.firstObject;
                }
                count += tmp.count;
            }
            
            if (count > 1) {
                [HBS_Tools msgBoxWithTitle:nil message:@"只能上传单个文件"];
                return;
            }
            else if (!adapter) {
                [HBS_Tools msgBoxWithTitle:nil message:@"请选择文件上传"];
                return;
            }
            
            [HBS_Tools showWaitBox:@"上传..."];
            
            NSString *filepath = [adapter path];
            NSString *fileName = [filepath lastPathComponent];
            
            if ([fileName hasSuffix:@"mov"] || [fileName hasSuffix:@"mp4"]) {
                
            }
            else {
            }
        }
    }
}

#pragma mark - view display

- (void)freshControllerView {
    
    CGFloat edge_bottom = 0;
    CGFloat edge_left = 0;
    CGFloat edge_right = 0;
    
    if (@available(iOS 11.0, *)) {
        edge_bottom = self.view.safeAreaInsets.bottom;
        edge_left = self.view.safeAreaInsets.left;
        edge_right = self.view.safeAreaInsets.right;
    }
    
    if (edge_bottom == 0) {
        seg.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    }
    else {
        seg.frame = CGRectMake(0, self.view.frame.size.height - 20 - 44, self.view.frame.size.width, 44);
    }
    
    if (collectView.isEditing) {
        collectView.frame = CGRectMake(edge_left, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.frame.size.width - edge_right - edge_left, seg.frame.origin.y - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    }
    else {
        collectView.frame = CGRectMake(edge_left, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.frame.size.width - edge_right - edge_left, CGRectGetMaxY(seg.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    }
    
    if (collectView.isEditing) {

        seg.hidden = NO;
        [seg setItems:nil imgs:@[[UIImage imageNamed:@"delete"],[UIImage imageNamed:@"share_01"]]];
        
        int count = 0;
        for (NSArray *imgs in selectArray) {
            count += [imgs count];
        }
        
        if (count > 0) {
            [seg setItem:0 enabled:YES];
            [seg setItem:1 enabled:YES];
        }
        else {
            [seg setItem:0 enabled:NO];
            [seg setItem:1 enabled:NO];
        }
    }
    else {
        
        seg.hidden = YES;
    }
}

#pragma mark - ImageCollectionViewDelegate
- (void)imageCollectionView:(ImageCollectionView *)imageCollectionView didSelectImage:(NSArray <NSArray <ImageAdapter *> *> *)selectImages {
    
    selectArray = selectImages;
    
    if (imageCollectionView.isEditing) {
        self.navigationItem.titleView = nil;
        if (imageCollectionView.isSelectAll) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"photo_allSelect",@"全选") style:UIBarButtonItemStylePlain target:self action:@selector(pressSelectAll)];
        }
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消",nil) style:UIBarButtonItemStylePlain target:self action:@selector(pressCancel)];
        
        int count = 0;
        for (NSArray *tmp in selectImages) {
            count += [tmp count];
        }
        self.title = [NSString stringWithFormat:NSLocalizedString(@"photo_selectNumberItem",@"已选中%d项"),count];
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回",nil) style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"选择",nil) style:UIBarButtonItemStylePlain target:self action:@selector(pressSelect)];
        self.title = nil;
        self.navigationItem.titleView = menu;
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} forState:UIControlStateNormal];
    
    [self freshControllerView];
}

- (void)imageCollectionView:(ImageCollectionView *)imageCollectionView didPressItem:(ImageAdapter *)adapter {
    
    if (_fileType == FileTypeVideo) {
        
        VideoPlayerViewController *playVc = [[VideoPlayerViewController alloc] init];
        playVc.adapter = adapter;
        
        [self presentViewController:playVc animated:YES completion:nil];
    }
    else {
        
        DisplayImageViewController *c = [[DisplayImageViewController alloc] init];
        c.currentAdapter = adapter;
        
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:1];
        for (NSArray *arr in collectView.dataArray) {
            [tmp addObjectsFromArray:arr];
        }
        c.adapterArray = tmp;
        
        [self.navigationController pushViewController:c animated:YES];
    }
    
}

#pragma mark - notice action
- (BOOL)isVideo {
    
    return _fileType == FileTypeVideo ? YES : NO;
}

- (void)setFileType:(FileType)fileType {
    
    _fileType = fileType;
    
    [self reloadFiles];
    
    if (_fileType == FileTypeImage) {
        
        [[AlbumManager shareManager] asyncRequestLocalFile:NO];
    }
    else if (_fileType == FileTypeVideo) {
        
        [[AlbumManager shareManager] asyncRequestLocalFile:YES];
    }
    
    [self.view setWaitColor:WAITCOLOR];
    [self.view showWait];
}

- (void)localFileChanged {
    
    [self.view hideWait];
    
    [self reloadFiles];
}

- (void)reloadFiles {
    
    NSDictionary<NSString *,NSArray <LocalFile *> *> *all = [[AlbumManager shareManager] localFile:[self isVideo]];
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:1];
    
    NSArray *sortKeys = [[all allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    for (int i = (int)[sortKeys count] - 1; i >= 0; i--) {
        
        NSString *key = [sortKeys objectAtIndex:i];
        NSArray *values = [all objectForKey:key];
        
        if (values.count) {
            
            [tmp addObject:[NSMutableArray arrayWithArray:values]];
        }
    }
    
    [collectView reloadViewWithData:tmp];
}
@end
