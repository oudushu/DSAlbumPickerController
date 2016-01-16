//
//  CollectionViewCell.m
//  DSAlbumPickerController
//
//  Created by 欧杜书 on 16/1/16.
//  Copyright © 2016年 DuShu. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
            [self.contentView addSubview:imageView];
            imageView;
        });
    }
    return self;
}

#pragma mark - setters
- (void)setCellImage:(UIImage *)cellImage {
    if (_cellImage != cellImage) {
        _cellImage = cellImage;
        self.imageView.image = cellImage;
    }
}
@end
