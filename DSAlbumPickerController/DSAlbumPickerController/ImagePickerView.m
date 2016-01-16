//
//  ImagePickerView.m
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/12/10.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "ImagePickerView.h"
#import "ImagePickerViewCell.h"
#import "ImagePickerViewCameraCell.h"

@interface ImagePickerView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, copy) SelectedPhotosBlock selectedPhotoBlock;
@property (nonatomic, copy) OpenCameraBlock openCameraBlock;
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) NSMutableArray *selectedAssetsArray;
@property (nonatomic, strong) NSMutableArray *assetsURLArray;
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, assign) NSInteger maxCount;
@end

@implementation ImagePickerView
- (instancetype)initWithFrame:(CGRect)frame
                     maxcount:(NSInteger)maxcount
               selectedPhotos:(NSMutableArray *)array
              openCameraBlock:(OpenCameraBlock)openCameraBlock
          selectedPhotosBlock:(SelectedPhotosBlock)selectedPhotosBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.maxCount = maxcount;
        __weak typeof(self) weakSelf = self;
        if (array) {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.selectedAssetsArray addObject:obj];
            }];
        }
        self.selectedPhotoBlock = selectedPhotosBlock;
        self.openCameraBlock = openCameraBlock;
        [self setupViews];
        [weakSelf reloadCollectionData];
    }
    return self;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)setupViews {
    CGFloat kDefaultMargin = 8;
    CGFloat kImageHeight = (self.frame.size.width - 5 * kDefaultMargin) * 0.25;
    
    self.confirmButton = ({
        UIButton *confirmButton = [[UIButton alloc] init];
        [self addSubview:confirmButton];
        [confirmButton setTitle:[NSString stringWithFormat:@"%@ (%lu/%ld)", @"确定", (unsigned long)self.selectedAssetsArray.count, (long)self.maxCount] forState:UIControlStateNormal];
        confirmButton.clipsToBounds = YES;
        confirmButton.layer.cornerRadius = 22;
        confirmButton.layer.borderWidth = 1;
        confirmButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        confirmButton.frame = CGRectMake(0, self.frame.size.height - 49, self.frame.size.width, 44);
        [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        confirmButton;
    });
    
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(kImageHeight, kImageHeight);
        layout.minimumInteritemSpacing = kDefaultMargin;
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 2 * 5 - 44) collectionViewLayout:layout];
        [self addSubview:collectionView];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        collectionView.bounces = YES;
        collectionView.alwaysBounceVertical = YES;
        [collectionView registerClass:[ImagePickerViewCell class] forCellWithReuseIdentifier:@"ImagePickerViewCell"];
        [collectionView registerClass:[ImagePickerViewCameraCell class] forCellWithReuseIdentifier:@"ImagePickerViewCameraCell"];
        collectionView;
    });
}

- (void)confirmButtonClick {
    if (self.selectedPhotoBlock) {
        self.selectedPhotoBlock(self.selectedAssetsArray);
    }
}

- (void)reloadCollectionData {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[ImagePickerView defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                              if (assetsGroup) {
                                                  [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                                                  [assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                      if (result) {
                                                          [weakSelf.assetArray addObject:result];
                                                      }
                                                  }];
                                                  NSArray *tmpArray = [weakSelf.assetArray sortedArrayUsingComparator:^NSComparisonResult(ALAsset *obj1, ALAsset *obj2) {
                                                      if ([obj1 valueForProperty:ALAssetPropertyDate] && [obj2 valueForProperty:ALAssetPropertyDate]) {
                                                          return [[obj2 valueForProperty:ALAssetPropertyDate] compare:[obj1 valueForProperty:ALAssetPropertyDate]];
                                                      }
                                                      return NSOrderedSame;
                                                  }];
                                                  [tmpArray enumerateObjectsUsingBlock:^(ALAsset *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                      [weakSelf.assetsURLArray addObject:[obj valueForProperty:ALAssetPropertyAssetURL]];
                                                  }];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                          [weakSelf.collectionView reloadData];
                                                  });
                                              }
                                          }
                                        failureBlock:^(NSError *error) {
                                            NSLog(@"error %@", error);
                                        }];
        
    });
}

- (void)addNewImage {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[ImagePickerView defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                              if (assetsGroup) {
                                                  [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                                                  __block NSMutableArray<ALAsset *> *array = [NSMutableArray array];
                                                  [assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                      if (result) {
                                                          [array addObject:result];
                                                      }
                                                  }];
                                                  NSArray *tmpArray = [array sortedArrayUsingComparator:^NSComparisonResult(ALAsset *obj1, ALAsset *obj2) {
                                                      if ([obj1 valueForProperty:ALAssetPropertyDate] && [obj2 valueForProperty:ALAssetPropertyDate]) {
                                                          return [[obj2 valueForProperty:ALAssetPropertyDate] compare:[obj1 valueForProperty:ALAssetPropertyDate]];
                                                      }
                                                      return NSOrderedSame;
                                                  }];
                                                  NSURL *url = [tmpArray[0] valueForProperty:ALAssetPropertyAssetURL];
                                                  [weakSelf.assetsURLArray insertObject:url atIndex:0];
                                                  if (weakSelf.selectedAssetsArray.count < 6) {
                                                      [weakSelf.selectedAssetsArray addObject:url];
                                                  }
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [weakSelf.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
                                                      [weakSelf setConfirmButtonTitle];
                                                  });
                                              }
                                          }
                                        failureBlock:^(NSError *error) {
                                            NSLog(@"error %@", error);
                                        }];
        
    });
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsURLArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cameraIdentifier = @"ImagePickerViewCameraCell";
    static NSString *identifier = @"ImagePickerViewCell";
    ImagePickerViewCameraCell *cameraCell = [collectionView dequeueReusableCellWithReuseIdentifier:cameraIdentifier forIndexPath:indexPath];
    ImagePickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.item == 0) {
        return cameraCell;
    }
    __weak typeof(self) weakSelf = self;
    [[ImagePickerView defaultAssetsLibrary] assetForURL:self.assetsURLArray[indexPath.item - 1] resultBlock:^(ALAsset *asset) {
        [cell configWithAsset:asset isSelected:[weakSelf.selectedAssetsArray containsObject:weakSelf.assetsURLArray[indexPath.item - 1]]];
    } failureBlock:^(NSError *error) {
        NSLog(@"error %@", error);
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        if (self.openCameraBlock) {
            self.openCameraBlock();
        }
    } else {
        ImagePickerViewCell *cell = (ImagePickerViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (!(self.selectedAssetsArray.count < self.maxCount) && cell.isSelected == NO) {
            return;
        }
        cell.isSelected = !cell.isSelected;
        if (cell.isSelected) {
            [self.selectedAssetsArray addObject:self.assetsURLArray[indexPath.item - 1]];
        } else {
            if ([self.selectedAssetsArray containsObject:self.assetsURLArray[indexPath.item - 1]]) {
                [self.selectedAssetsArray removeObject:self.assetsURLArray[indexPath.item - 1]];
            }
        }
        [self setConfirmButtonTitle];
    }
}

- (void)setConfirmButtonTitle {
    [self.confirmButton setTitle:[NSString stringWithFormat:@"%@ (%lu/%ld)",@"确定", (unsigned long)self.selectedAssetsArray.count, (long)self.maxCount] forState:UIControlStateNormal];
}

#pragma mark - setters & getters
- (NSMutableArray *)selectedAssetsArray {
    if (!_selectedAssetsArray) {
        _selectedAssetsArray = [NSMutableArray array];
    }
    return _selectedAssetsArray;
}

- (NSMutableArray *)assetsURLArray {
    if (!_assetsURLArray) {
        _assetsURLArray = [NSMutableArray array];
    }
    return _assetsURLArray;
}

- (NSMutableArray *)assetArray {
    if (!_assetArray) {
        _assetArray = [NSMutableArray array];
    }
    return _assetArray;
}

@end
