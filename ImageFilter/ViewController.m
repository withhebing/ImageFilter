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

- (void)outputImageWithFilterName:(NSString *)filterName {
    //将UIImage转换成CIImage
//    CIImage *ciImage = self.filterlessImage.CIImage; // 无效, 不显示; 为什么要新建一个呢
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.filterlessImage];
    //创建滤镜
    self.filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    //已有的值不改变，其他的设为默认值
    [self.filter setDefaults];

    //渲染并输出CIImage
    CIImage *outputImage = [self.filter outputImage];
    //获取绘制上下文
    self.context = [CIContext contextWithOptions:nil];


    //创建CGImage句柄
    CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    //获取图片
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    //释放CGImage句柄
    CGImageRelease(cgImage);
    
    self.imgView.image = image;
}

- (IBAction)photoEffectChrome {
    self.filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];

    // output
//    CIImage *inputImage = self.filterlessImage.CIImage;
    CIImage *inputImage = [[CIImage alloc] initWithImage:self.filterlessImage];
    [self.filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *outputImage = self.filter.outputImage;

    self.context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:outputImage.extent];
    self.imgView.image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);   // cgImage后释放
}

- (IBAction)photoEffectFade {
    self.filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];

    // output
//    CIImage *inputImage = self.filterlessImage.CIImage;
    CIImage *inputImage = [[CIImage alloc] initWithImage:self.filterlessImage];
    [self.filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *outputImage = self.filter.outputImage;

    self.imgView.image = [UIImage imageWithCIImage:outputImage];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;     // 大小有变化, 且调整不了
}

- (IBAction)photoEffectInstant {
    [self outputImageWithFilterName:@"CIPhotoEffectInstant"];
}

- (IBAction)photoEffectMono {
    [self outputImageWithFilterName:@"CIPhotoEffectMono"];
}

- (IBAction)photoEffectNoir {
    [self outputImageWithFilterName:@"CIPhotoEffectNoir"];
}

- (IBAction)photoEffectProgress {
    [self outputImageWithFilterName:@"CIPhotoEffectProcess"];
}

- (IBAction)photoEffectTonal {
    [self outputImageWithFilterName:@"CIPhotoEffectTonal"];
}

- (IBAction)photoEffectTransfer {
    [self outputImageWithFilterName:@"CIPhotoEffectTransfer"];
}

- (IBAction)photoEffectOriginal {
    self.imgView.image = self.filterlessImage;
}

- (IBAction)photoEffectAutoAdjust {

}

@end
