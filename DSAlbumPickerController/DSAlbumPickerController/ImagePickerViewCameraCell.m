//
//  ImagePickerViewCameraCell.m
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/12/10.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "ImagePickerViewCameraCell.h"

@interface ImagePickerViewCameraCell()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ImagePickerViewCameraCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = ({
            UIImage *image = [UIImage imageNamed:@"user_center_no-photo-right"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [self.contentView addSubview:imageView];
            imageView.frame = self.contentView.frame;
            imageView;
        });
    }
    return self;
}
@end
