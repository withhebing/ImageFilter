# ImageFilter
this is a brief demo of filters about photo effect

思路: originalUIImage -> inputCIImage -> (CIFilter) -> outputCIImage -> (CIContext) -> CGImage -> UIImage

```objc
/// 传入滤镜名称(e.g. @"CIPhotoEffectFade"), 输出处理后的图片
- (UIImage *)outputImageWithFilterName:(NSString *)filterName {
    // 1.
    // 将UIImage转换成CIImage
//    CIImage *ciImage = self.originalImage.CIImage; // 未分配内存空间
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.originalImage];
    // 创建滤镜
    self.filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];

    // 2.
    // 渲染并输出CIImage
    CIImage *outputImage = [self.filter outputImage];

    // 3.
    // 获取绘制上下文
    self.context = [CIContext contextWithOptions:nil];
    // 创建CGImage
    CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    // 获取图片 (不要直接`imageWithCIImage:`, CIContext重复, 性能)
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    // 释放CGImage
    CGImageRelease(cgImage);

    return image;
}
```

### 效果图如下:

###### original image 原图

![OriginalImage](http://upload-images.jianshu.io/upload_images/1964880-9501a6111539b2c8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### photoe ffect 效果图
对应滤镜 |  |  
:----: | :----: | :----:
AutoAdjust 自动 | Instant 怀旧 | Process  冲印
Chrome     铬黄 | Mono    单色 | Tonal    色调
Fade       褪色 | Noir    黑白 | Transfer 岁月

![FilteredImage](http://upload-images.jianshu.io/upload_images/1964880-425febe0176fb7ec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
