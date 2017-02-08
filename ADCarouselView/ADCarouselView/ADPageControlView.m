//
//  ADPageControlView.m
//  ADCarouselViewExample
//
//  Created by andehang on 16/9/27.
//  Copyright © 2016年 andehang. All rights reserved.
//

#import "ADPageControlView.h"

#define ADPageControlViewDotViewDefaultWH 10
#define ADPageControlViewDotViewDefaultColor [UIColor grayColor]
#define ADPageControlViewCurrentDotViewColor [UIColor whiteColor]


@interface ADPageControlView()

/**小圆点*/
@property (nonatomic, strong) NSMutableArray *dots;
/**小圆点大小*/
@property (nonatomic, assign)  CGSize dotsSize;
/**小圆点之间的间距*/
@property (nonatomic, assign)  CGFloat dotsMargin;
/**是否完全自定义*/
@property (nonatomic, assign)  BOOL is_custom;

@end

@implementation ADPageControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.numberOfPages = 0;
        self.currentPage = 0;
    }
    return self;
}

+ (instancetype)pageControlViewWithFrame:(CGRect)frame
{
    return [self pageControlViewWithFrame:frame dotsSize:CGSizeZero dotsMargin:0];
}

+ (instancetype)pageControlViewWithFrame:(CGRect)frame dotsSize:(CGSize)dotsSize dotsMargin:(CGFloat)dotsMargin
{
    ADPageControlView *pageControlView = [[ADPageControlView alloc] initWithFrame:frame];
    pageControlView.dotsSize = dotsSize;
    pageControlView.dotsMargin = dotsMargin;
    pageControlView.is_custom = YES;
    return pageControlView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat dotViewW = 0;
    CGFloat dotViewMargin = 0;
    CGFloat dotViewY = 0;
    CGFloat dotViewH = 0;
    CGFloat dotViewMarginLeft = 0;
    
    dotViewW = self.dotsSize.width > 0 ? self.dotsSize.width : ADPageControlViewDotViewDefaultWH;
    dotViewH = self.dotsSize.height > 0 ? self.dotsSize.height : ADPageControlViewDotViewDefaultWH;
    dotViewMargin = self.dotsMargin > 0 ? self.dotsMargin : (self.bounds.size.width - self.numberOfPages * dotViewW) / (self.numberOfPages - 1);
    dotViewY = (self.bounds.size.height - dotViewH) * 0.5;
    dotViewMarginLeft = (self.bounds.size.width - self.numberOfPages * dotViewW - (self.numberOfPages - 1) * dotViewMargin) * 0.5;
    
    [self.dots enumerateObjectsUsingBlock:^(UIImageView *dotView, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat dotViewX = dotViewMarginLeft + idx * (dotViewW + dotViewMargin);
        dotView.frame = CGRectMake(dotViewX, dotViewY, dotViewW, dotViewH);
        
        CGFloat cornerRadius = self.dotCorner > 0 ? self.dotCorner : dotViewH * 0.5;
        dotView.layer.cornerRadius = cornerRadius;
    }];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    [self.dots enumerateObjectsUsingBlock:^(UIView *dotView, NSUInteger idx, BOOL * _Nonnull stop) {
        [dotView removeFromSuperview];
    }];
    
    [self.dots removeAllObjects];
    
    for (NSInteger i = 0; i < _numberOfPages; i++)
    {
        UIImageView *dotView = [[UIImageView alloc] init];
        
        dotView.backgroundColor = self.allPageDotBackgroundColor ? self.allPageDotBackgroundColor : ADPageControlViewDotViewDefaultColor;
        
        dotView.image = self.allPageDotImage;
        [self.dots addObject:dotView];
        
        [self addSubview:dotView];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self.dots enumerateObjectsUsingBlock:^(UIImageView *dotView, NSUInteger idx, BOOL * _Nonnull stop)
    {
        dotView.backgroundColor = self.allPageDotBackgroundColor ? self.allPageDotBackgroundColor : ADPageControlViewDotViewDefaultColor;
        dotView.image = self.allPageDotImage;
        if (idx == _currentPage)
        {
            dotView.backgroundColor = ADPageControlViewCurrentDotViewColor;
            dotView.image = self.currentPageDotImage;
            
        }
    }];
}

- (NSMutableArray *)dots
{
    if (!_dots) {
        _dots = [NSMutableArray array];
    }
    return _dots;
}

@end
