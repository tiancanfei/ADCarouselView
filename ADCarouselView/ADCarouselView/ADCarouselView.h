//
//  ADCarouselView.h
//  test
//
//  Created by andehang on 16/3/3.
//  Copyright © 2016年 andehang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADPageControlView.h"

@class ADCarouselView;

@protocol ADCarouselViewDelegate <NSObject>

@optional

- (void)carouselView:(ADCarouselView *)carouselView didSelectItemAtIndex:(NSInteger)didSelectItemAtIndex;

@end

@interface ADCarouselView : UIView

/**图片资源数组*/
@property (nonatomic, strong) NSArray *imgs;

/**标题数组*/
@property (nonatomic, strong) NSArray *titles;

/**是否无限循环轮播*/
@property (nonatomic, assign)  BOOL loop;

/**自动轮播时间间隔，默认为0，0表示不开启自动轮播*/
@property (nonatomic, assign)  NSTimeInterval automaticallyScrollDuration;

/**图片的展开方式*/
@property (nonatomic, assign)  UIViewContentMode imageContentMode;

/**占位图片*/
@property (strong, nonatomic) UIImage *placeholderImage;

+ (instancetype)carouselViewWithFrame:(CGRect)frame;

/**分页控制(相关属性自行设置，不设置使用默认属性)*/
@property (strong, nonatomic) ADPageControlView *pageControlView;
/**标题*/
@property (nonatomic, strong) UILabel *titleLabel;

/**代理*/
@property (weak, nonatomic) id<ADCarouselViewDelegate> delegate;

@end
