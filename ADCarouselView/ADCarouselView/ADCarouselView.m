//
//  ADCarouselView.m
//  ADCarouselView
//  
//  Created by andehang on 16/3/3.
//  Copyright © 2016年 andehang. All rights reserved.
//

#import "ADCarouselView.h"
#import "UIImageView+WebCache.h"

#define kADCarouselViewLeftMargin 10

#define kPageControlViewDefaultW 80
#define kPageControlViewDefaultH 44

#define kTitleLabelToTitleLabelMargin 10

#define kTitleLabelDefaultH kPageControlViewDefaultH

#define kPageControlViewDefaultFrame CGRectMake([UIScreen mainScreen].bounds.size.width - kPageControlViewDefaultW - kADCarouselViewLeftMargin, self.bounds.size.height - kPageControlViewDefaultH, kPageControlViewDefaultW, kPageControlViewDefaultH)

#define kTitleLabelDefaultFrame CGRectMake(kADCarouselViewLeftMargin, self.bounds.size.height - kTitleLabelDefaultH, [UIScreen mainScreen].bounds.size.width - kPageControlViewDefaultW - kADCarouselViewLeftMargin - kADCarouselViewLeftMargin - kTitleLabelToTitleLabelMargin, kTitleLabelDefaultH)

#define kTitleLabelDefaultTextColor [UIColor whiteColor]
#define kTitleLabelDefaultFont [UIFont systemFontOfSize:14]

@class ADCarouselViewCell;

#pragma mark - ADCarouselViewCell(轮播图子控件)

@interface ADCarouselViewCell : UICollectionViewCell

/**图片名称*/
@property (copy, nonatomic) NSString *imgName;

/**网络图片路径*/
@property (copy, nonatomic) NSString *imgUrl;

/**占位图片*/
@property (strong, nonatomic) UIImage *placeholderImage;

@end

@interface ADCarouselViewCell()

/**图片*/
@property (weak, nonatomic) UIImageView *imgView;

@end

@implementation ADCarouselViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpCarouselViewCell];
    }
    return self;
}

- (void)setUpCarouselViewCell
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeCenter;
    self.imgView = imgView;
    [self.contentView addSubview:self.imgView];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setImgName:(NSString *)imgName
{
    _imgName = imgName;
    UIImage *img = [UIImage imageNamed:_imgName];
    self.imgView.image = img ? img : self.placeholderImage;
}

- (void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:self.placeholderImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.frame = self.bounds;
}

@end

#pragma mark - ADCarouselView(轮播图控件)

@interface ADCarouselView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/**轮播控件*/
@property (weak, nonatomic) UICollectionView *carouselView;

/**布局*/
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

/**轮播图片数组*/
@property (nonatomic, strong) NSMutableArray *carouselImages;

/**自动轮播定时器*/
@property (nonatomic, strong) NSTimer *timer;

/**当前滚动的位置*/
@property (nonatomic, assign)  NSInteger currentIndex;

/**上次滚动的位置*/
@property (nonatomic, assign)  NSInteger lastIndex;

@end

@implementation ADCarouselView

+ (instancetype)carouselViewWithFrame:(CGRect)frame
{
    ADCarouselView *carouselView = [[self alloc] initWithFrame:frame];
    return carouselView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //1、添加collectionview
        //1.1设置collectionview布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout = layout;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        //设置滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //1.2初始化collectionview
        UICollectionView *carouselView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        carouselView.showsHorizontalScrollIndicator = NO;
        carouselView.pagingEnabled = YES;
        carouselView.delegate = self;
        carouselView.dataSource = self;
        //2、注册cell类型
        [carouselView registerClass:[ADCarouselViewCell class] forCellWithReuseIdentifier:@"carouselViewCell"];
        self.carouselView = carouselView;
        //3、添加为子控件
        [self addSubview:carouselView];
        //4、设置自动滚动时间间隔
        self.loop = NO;
        self.automaticallyScrollDuration = 0;
        
        //添加标题和分页
        self.titleLabel.frame = kTitleLabelDefaultFrame;
        self.pageControlView.frame = kPageControlViewDefaultFrame;
        self.titleLabel.textColor = kTitleLabelDefaultTextColor;
        self.titleLabel.font = kTitleLabelDefaultFont;
    }
    return self;
}

#pragma mark 自动滚动时间设置

- (void)setAutomaticallyScrollDuration:(NSTimeInterval)automaticallyScrollDuration
{
    _automaticallyScrollDuration = automaticallyScrollDuration;
    if (_automaticallyScrollDuration > 0)
    {
        [self.timer invalidate];
        self.timer = nil;
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.automaticallyScrollDuration target:self selector:@selector(startScrollAutomtically) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        self.timer = timer;
    }
    else
    {
        [self.timer invalidate];
    }
}

#pragma mark 构造新的图片数组

- (NSMutableArray *)carouselImages
{
    if (!_carouselImages) {
        _carouselImages = [NSMutableArray arrayWithArray:self.imgs];
        if (self.loop && self.imgs.count > 0)
        {
            [_carouselImages insertObject:[self.imgs lastObject] atIndex:0];
            [_carouselImages addObject:self.imgs[0]];
        }
    }
    return _carouselImages;
}

#pragma mark 自动滚动
- (void)startScrollAutomtically
{
    NSInteger currentIndex = self.currentIndex + 1;
    currentIndex = (currentIndex == self.carouselImages.count) ? 1 : currentIndex;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    BOOL isNeedAnim = self.automaticallyScrollDuration <= 0.3 ? NO : YES;
    [self scrollToIndexPath:indexPath animated:isNeedAnim];
}

- (void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    if (self.carouselImages.count > indexPath.row)
    {
        [self.carouselView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.carouselView.frame = self.bounds;
    
    //默认滚动到第一张图片
    if (self.loop && self.carouselView.contentOffset.x == 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self scrollToIndexPath:indexPath animated:NO];
        self.currentIndex = 1;
    }
}

#pragma mark 代理方法

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"carouselViewCell" forIndexPath:indexPath];
    cell.imgView.contentMode = self.imageContentMode;
    cell.placeholderImage = self.placeholderImage;
    NSString *imgName = self.carouselImages[indexPath.row];
    if ([imgName hasPrefix:@"http://"] || [imgName hasPrefix:@"https://"])
    {
        cell.imgUrl = imgName;
    }
    else
    {
        cell.imgName = imgName;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.carouselImages.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.frame.size.width;
    NSInteger index = (scrollView.contentOffset.x + width * 0.5) / width;
    if (self.loop)
    {
        //当滚动到最后一张图片时，继续滚向后动跳到第一张
        if (index == self.imgs.count + 1)
        {
            self.currentIndex = 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
            [self scrollToIndexPath:indexPath animated:NO];
            return;
        }
        
        //当滚动到第一张图片时，继续向前滚动跳到最后一张
        if (scrollView.contentOffset.x < width * 0.5)
        {
            self.currentIndex = self.imgs.count;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
            [self scrollToIndexPath:indexPath animated:NO];
            return;
        }
    }
    
    //避免多次调用currentIndex的setter方法
    if (self.currentIndex != self.lastIndex)
    {
        self.currentIndex = index;
    }
    self.lastIndex = index;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(carouselView:didSelectItemAtIndex:)])
    {
        [self.delegate carouselView:self didSelectItemAtIndex:self.currentIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //关闭自动滚动
    [self.timer invalidate];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.automaticallyScrollDuration > 0)
    {        
        [self.timer invalidate];
        self.timer = nil;
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.automaticallyScrollDuration target:self selector:@selector(startScrollAutomtically) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        self.timer = timer;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    if (_currentIndex < self.imgs.count + 1)
    {
//        NSLog(@"%zd",currentIndex);
        NSInteger index = _currentIndex > 0 ? _currentIndex - 1 : 0;
        self.pageControlView.currentPage = index;
        
        self.titleLabel.hidden = !self.titles.count;
        if (self.titles.count > index)
        {
            self.titleLabel.text = self.titles[index];
        }
        
        return;
    }
    
}

- (void)setImgs:(NSArray *)imgs
{
    _imgs = imgs;
    
    [self.carouselView reloadData];
    self.pageControlView.hidden = !_imgs.count;
    self.pageControlView.numberOfPages = _imgs.count;
}

- (ADPageControlView *)pageControlView
{
    if (!_pageControlView) {
        _pageControlView = [ADPageControlView pageControlViewWithFrame:CGRectZero];
        [self addSubview:_pageControlView];
    }
    return _pageControlView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


@end

