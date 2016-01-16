//
//  ImagePickerViewController.h
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/12/10.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePickerView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImagePickerViewController : UIViewController

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSMutableArray<NSURL *> *selectedPhotoArray;

- (instancetype)initWithMaxCount:(NSInteger)maxCount
             selectedPhotosBlock:(SelectedPhotosBlock)selectedPhotosBlock;

@end
