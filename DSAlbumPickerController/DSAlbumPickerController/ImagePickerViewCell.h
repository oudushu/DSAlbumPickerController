//
//  ImagePickerViewCell.h
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/12/10.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImagePickerViewCell : UICollectionViewCell

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) BOOL isSelected;

- (void)configWithAsset:(ALAsset *)asset isSelected:(BOOL)seleted;

@end
