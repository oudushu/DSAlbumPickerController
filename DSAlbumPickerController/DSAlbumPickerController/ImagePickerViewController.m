//
//  ImagePickerViewController.m
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/12/10.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "ImagePickerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ImagePickerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) ImagePickerView *imagePickerView;
@property (nonatomic, copy) SelectedPhotosBlock selectedPhotosBlock;
@property (nonatomic, assign) NSInteger maxCount;
@end

@implementation ImagePickerViewController

- (instancetype)initWithMaxCount:(NSInteger)maxCount
             selectedPhotosBlock:(SelectedPhotosBlock)selectedPhotosBlock {
    if (self = [super init]) {
        self.selectedPhotosBlock = selectedPhotosBlock;
        self.maxCount = maxCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleStr ? self.titleStr : @"选择相片";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    
    [self.view addSubview:self.imagePickerView];
}

- (void)leftBarButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  打开相机
 */
- (void)openCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
    } else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                ipc.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                ipc.delegate = self;
                [self presentViewController:ipc animated:YES completion:nil];
            } 
        }];
    }
}

#pragma mark - 图片选择控制器的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [UIImage imageWithData:UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 1)];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [self.imagePickerView addNewImage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (ImagePickerView *)imagePickerView {
    if (!_imagePickerView) {
        __weak typeof(self) weakSelf = self;
        _imagePickerView = [[ImagePickerView alloc] initWithFrame:self.view.bounds
                                                         maxcount:9
                                                   selectedPhotos:self.selectedPhotoArray
                                                  openCameraBlock:^{
                                                      if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                          [self openCamera];
                                                      }
                                                  } selectedPhotosBlock:^(NSMutableArray *photos) {
                                                      if (weakSelf.selectedPhotosBlock) {
                                                          weakSelf.selectedPhotosBlock(photos);
                                                      }
                                                      [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                  }];
    }
    return _imagePickerView;
}

- (void)setTitleStr:(NSString *)titleStr {
    if (_titleStr != titleStr) {
        _titleStr = titleStr;
        self.navigationItem.title = _titleStr;
    }
}

@end
