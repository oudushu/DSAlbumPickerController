//
//  ImagePickerView.h
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/12/10.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedPhotosBlock)(NSMutableArray *photos);
typedef void(^OpenCameraBlock)();

@interface ImagePickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     maxcount:(NSInteger)maxcount
               selectedPhotos:(NSMutableArray *)array
              openCameraBlock:(OpenCameraBlock)openCameraBlock
          selectedPhotosBlock:(SelectedPhotosBlock)selectedPhotosBlock;

- (void)reloadCollectionData;
- (void)addNewImage;
@end
