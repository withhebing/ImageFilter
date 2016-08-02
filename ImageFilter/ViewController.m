//
//  ViewController.m
//  ImageFilter
//
//  Created by Beans on 16/8/1.
//  Copyright © 2016年 iceWorks. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) UIImage *filterlessImage;
/// filter
@property (nonatomic, strong) CIFilter *filter;
/// context
@property (nonatomic, strong) CIContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.filterlessImage = [UIImage imageNamed:@"ivy_chen"];

    self.imgView.image = self.filterlessImage;
    self.imgView.layer.opaque = 0.8;
    self.imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imgView.layer.shadowOffset = CGSizeMake(1, 1);

//    [self showFilters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFilters {
    NSArray *filterNames = [CIFilter filterNamesInCategory:kCICategoryColorEffect];
    for (NSString *filterName in filterNames) {
        NSLog(@"%@", filterName);
        CIFilter *filter = [CIFilter filterWithName:filterName];
        NSDictionary *attributes = filter.attributes;
        NSLog(@"%@", attributes);
    }
}

#pragma mark - photo effect

/// 传入滤镜名称, 输出处理后的图片
- (UIImage *)outputImageWithFilterName:(NSString *)filterName {

    // 1.
    // 将UIImage转换成CIImage
//    CIImage *ciImage = self.filterlessImage.CIImage; // 无效, 不显示; 为什么要新建一个呢? -- 未分配内存空间
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.filterlessImage];
    // 创建滤镜
    self.filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    // 已有的值不改变, 其他的设为默认值
    [self.filter setDefaults];

    // 2.
    // 渲染并输出CIImage
    CIImage *outputImage = [self.filter outputImage];

    // 3.
    // 获取绘制上下文
    self.context = [CIContext contextWithOptions:nil];
    // 创建CGImage句柄
    CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    // 获取图片
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    // 释放CGImage句柄
    CGImageRelease(cgImage);
    
    return image;
}

// CGImage, context
- (IBAction)photoEffectChrome {
    self.filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];

    CIImage *inputImage = [[CIImage alloc] initWithImage:self.filterlessImage];
    [self.filter setValue:inputImage forKey:kCIInputImageKey];

    CIImage *outputImage = self.filter.outputImage;

    self.context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:outputImage.extent];
    self.imgView.image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);   // cgImage后释放
}

// CIImage, 尺寸有点小问题
- (IBAction)photoEffectFade {
//    self.filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
//
//    CIImage *inputImage = [[CIImage alloc] initWithImage:self.filterlessImage];
//    [self.filter setValue:inputImage forKey:kCIInputImageKey];
//    CIImage *outputImage = self.filter.outputImage;
//
//    self.imgView.image = [UIImage imageWithCIImage:outputImage];
//    self.imgView.contentMode = UIViewContentModeScaleAspectFit;     // 大小有变化, 调整不了?

    self.imgView.image = [self outputImageWithFilterName:@"CIPhotoEffectFade"];
}

- (IBAction)photoEffectInstant {
    self.imgView.image = [self outputImageWithFilterName:@"CIPhotoEffectInstant"];
}

- (IBAction)photoEffectMono {
    self.imgView.image = [self outputImageWithFilterName:@"CIPhotoEffectMono"];
}

- (IBAction)photoEffectNoir {
    self.imgView.image = [self outputImageWithFilterName:@"CIPhotoEffectNoir"];
}

- (IBAction)photoEffectProgress {
    self.imgView.image = [self outputImageWithFilterName:@"CIPhotoEffectProcess"];
}

- (IBAction)photoEffectTonal {
    self.imgView.image = [self outputImageWithFilterName:@"CIPhotoEffectTonal"];
}

- (IBAction)photoEffectTransfer {
    self.imgView.image = [self outputImageWithFilterName:@"CIPhotoEffectTransfer"];
}

- (IBAction)photoEffectOriginal {
    self.imgView.image = self.filterlessImage;
}

- (IBAction)photoEffectAutoAdjust {

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

    self.imgView.image = image;
}

@end
