//
//  ViewController.m
//  ADCarouselViewExample
//
//  Created by andehang on 16/3/3.
//  Copyright © 2016年 andehang. All rights reserved.
//

#import "ViewController.h"
#import "ADCarouselView.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<ADCarouselViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADCarouselView *carouselView = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    carouselView.loop = YES;
    carouselView.delegate = self;
    carouselView.automaticallyScrollDuration = 1;
    carouselView.imgs = @[@"ad11",@"http://d.hiphotos.baidu.com/zhidao/pic/item/3b87e950352ac65c1b6a0042f9f2b21193138a97.jpg",@"ad3",@"ad4",@"ad5"];
    carouselView.placeholderImage = [UIImage imageNamed:@"zhanweifu"];
    carouselView.titles = @[@"地方",@"订单的",@"ddddd",@"费德勒方面",@"反对舒服的说"];
    [self.view addSubview:carouselView];
}

- (void)carouselView:(ADCarouselView *)carouselView didSelectItemAtIndex:(NSInteger)didSelectItemAtIndex
{
    NSLog(@"%zd",didSelectItemAtIndex);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
