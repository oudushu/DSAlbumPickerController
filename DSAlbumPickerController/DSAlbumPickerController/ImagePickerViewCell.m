//
//  ImagePickerViewCell.m
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/12/10.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "ImagePickerViewCell.h"

@interface ImagePickerViewCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong) UIImageView *checkView;

@end

@implementation ImagePickerViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
            [self.contentView addSubview:imageView];
            imageView;
        });
        
        self.checkImageView = ({
            UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
            [self.imageView addSubview:checkImageView];
            checkImageView.backgroundColor = [UIColor whiteColor];
            checkImageView.alpha = 0.0f;
            checkImageView.hidden = YES;
           
            checkImageView;
        });
        
        self.checkView = ({
            UIImageView *checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_radio_selected"]];
            [self.imageView addSubview:checkView];
            checkView.frame = CGRectMake(self.contentView.frame.size.width - 21, 6, 15, 15);
            checkView.hidden = YES;
            checkView;
        });
    }
    return self;
}

- (void)configWithAsset:(ALAsset *)asset isSelected:(BOOL)seleted {
    self.isSelected = seleted;
    self.asset = asset;
}

#pragma mark - setters && getters
- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        
        if (isSelected) {
            self.checkImageView.hidden = NO;
            self.checkView.hidden = NO;
            [UIView animateWithDuration:0.1 animations:^{
                self.checkImageView.alpha = 0.4f;
                self.checkView.transform = CGAffineTransformMakeScale(1.4, 1.4);
            }
                             completion:^(BOOL finished){
                             }];
        } else {
            [UIView animateWithDuration:0.1 animations:^{
                self.checkImageView.alpha = 0.0f;
                self.checkView.transform = CGAffineTransformMakeScale(0, 0);
            }
                             completion:^(BOOL finished){
                                 self.checkImageView.hidden = YES;
                                 self.checkView.hidden = YES;
                             }];
        }
    }
}

- (void)setAsset:(ALAsset *)asset {
    if (_asset != asset) {
        _asset = asset;
        
        CGImageRef thumbnailImageRef = [asset thumbnail];
        if (thumbnailImageRef) {
            self.imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
        } else {
            self.imageView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
        }
    }
}

@end
