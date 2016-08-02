# ImageFilter
this is a brief demo of filters with "photo effect"

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

Core Image 提供的滤镜很多, 不便记忆. 可通过`打印`或`po filter.attributes`方式查看相应信息.
```objc
// 打印滤镜名称
- (void)showFilters {
    NSArray *filterNames = [CIFilter filterNamesInCategory:kCICategoryColorEffect];
    for (NSString *filterName in filterNames) {
        NSLog(@"%@", filterName);
        // CIFilter *filter = [CIFilter filterWithName:filterName];
        // NSDictionary *attributes = filter.attributes;
        // NSLog(@"%@", attributes); // 查看属性
    }
}
```

```objc
// 自动调整样式
- (UIImage *)photoEffectAutoAdjust {
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.filterlessImage];
    NSArray *filters = [ciImage autoAdjustmentFiltersWithOptions:nil];
    CIImage *outputImage;
    for (CIFilter *filter in filters) {
        [filter setValue:ciImage forKey:kCIInputImageKey];
        [filter setDefaults];
        outputImage = filter.outputImage;
    }

    self.context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
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
