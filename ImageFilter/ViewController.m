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

    [self showFilters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFilters {
    NSArray *filterNames = [CIFilter filterNamesInCategory:kCICategoryColorEffect];
    for (NSString *filterName in filterNames) {
        NSLog(@"%@", filterName);
//        CIFilter *filter = [CIFilter filterWithName:filterName];
//        NSDictionary *attributes = filter.attributes;
//        NSLog(@"%@", attributes);
    }
}

#pragma mark - photo effect

- (IBAction)photoEffectChrome {
    self.filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];

    // output
    CIImage *inputImage = self.filterlessImage.CIImage;
    [self.filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *outputImage = self.filter.outputImage;
//    self.imgView.image = [UIImage imageWithCIImage:outputImage];
    CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:outputImage.extent];
    self.imgView.image = [UIImage imageWithCGImage:cgImage];
}

- (IBAction)photoEffectFade {
    self.filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];

    // output
    CIImage *inputImage = self.filterlessImage.CIImage;
    [self.filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *outputImage = self.filter.outputImage;
    self.imgView.image = [UIImage imageWithCIImage:outputImage];
//    CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:outputImage.extent];
//    self.imgView.image = [UIImage imageWithCGImage:cgImage];
}

- (IBAction)photoEffectInstant {

}

- (IBAction)photoEffectMono {

}

- (IBAction)photoEffectNoir {

}

- (IBAction)photoEffectProgress {

}

- (IBAction)photoEffectTonal {

}

- (IBAction)photoEffectTransfer {

}

- (IBAction)photoEffectOriginal {

}

- (IBAction)photoEffectAutoAdjust {

}

@end
