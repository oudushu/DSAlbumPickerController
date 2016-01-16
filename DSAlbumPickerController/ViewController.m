//
//  ViewController.m
//  DSAlbumPickerController
//
//  Created by 欧杜书 on 16/1/12.
//  Copyright © 2016年 DuShu. All rights reserved.
//

#import "ViewController.h"
#import "ImagePickerViewController.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) ImagePickerViewController *imagePickerViewController;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *selectedAssets;
@property (nonatomic, strong) UIButton *selectedButton;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    CGFloat kDefaultMargin = 8;
    CGFloat kImageHeight = (self.view.frame.size.width - 5 * kDefaultMargin) * 0.25;
    
    self.selectedButton = ({
        UIButton *selectedButton = [[UIButton alloc] init];
        [self.view addSubview:selectedButton];
        [selectedButton setTitle:@"选择图片" forState:UIControlStateNormal];
        selectedButton.clipsToBounds = YES;
        selectedButton.layer.cornerRadius = 22;
        selectedButton.layer.borderWidth = 1;
        selectedButton.layer.borderColor = [UIColor blueColor].CGColor;
        [selectedButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        selectedButton.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 44);
        [selectedButton addTarget:self action:@selector(selectedButtonClick) forControlEvents:UIControlEventTouchUpInside];
        selectedButton;
    });
    
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(kImageHeight, kImageHeight);
        layout.minimumInteritemSpacing = kDefaultMargin;
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 2 * 5 - 44) collectionViewLayout:layout];
        [self.view addSubview:collectionView];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        collectionView.bounces = YES;
        collectionView.alwaysBounceVertical = YES;
        [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        collectionView;
    });
}

- (void)selectedButtonClick {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.imagePickerViewController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - UICollectionView delegate && datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.selectedAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CollectionViewCell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    // [assetForURL:filureBlock] is a is asynchronous method
    [[ViewController defaultAssetsLibrary] assetForURL:self.selectedAssets[indexPath.item] resultBlock:^(ALAsset *asset) {
        CGImageRef thumbnailImageRef = [asset thumbnail];
        cell.cellImage = [UIImage imageWithCGImage:thumbnailImageRef];
    } failureBlock:^(NSError *error) {
        NSLog(@"error %@", error);
    }];
    return cell;
}

#pragma mark - setters && getters
- (NSArray *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [NSArray array];
    }
    return _selectedAssets;
}

- (ImagePickerViewController *)imagePickerViewController {
    if (!_imagePickerViewController) {
        __weak typeof(self) weakSelf = self;
        _imagePickerViewController = [[ImagePickerViewController alloc] initWithMaxCount:9 selectedPhotosBlock:^(NSMutableArray *photos) {
            weakSelf.selectedAssets = photos;
            [weakSelf.collectionView reloadData];
        }];
    }
    return _imagePickerViewController;
}

@end
