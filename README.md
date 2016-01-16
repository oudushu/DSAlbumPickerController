# DSAlbumPickerController
==========================
一个本地相册图片选择器, 简单易用.
-------------------------------
### 使用
        直接把DSAlbumPickerController文件夹拉到项目中即可使用
        
### 注意
        1.DSAlbumPickerController是用presentViewController的方式present出来的
        2.选择好的图片是以图片的URL的方式传出来的, URL转成UIImage的方式请看示例代码.
        
### 示例代码
        [_assetsLibrary assetForURL:self.selectedAssets[indexPath.item] resultBlock:^(ALAsset *asset) {
          	CGImageRef thumbnailImageRef = [asset thumbnail];
          	cell.cellImage = [UIImage imageWithCGImage:thumbnailImageRef];
         } failureBlock:^(NSError *error) {
          	 NSLog(@"error %@", error);
          }];
### 
          __weak typeof(self) weakSelf = self;
          _imagePickerViewController = [[ImagePickerViewController alloc] initWithMaxCount:9 selectedPhotosBlock:^(NSMutableArray *photos) {
            weakSelf.selectedAssets = photos;
            [weakSelf.collectionView reloadData];
        }];

###  详细的代码请看Demo

![](https://github.com/OuDuShu/DSAlbumPickerController/raw/master/DSAlbumPickerController/DSAlbumPickerControllerDemo.gif) 
