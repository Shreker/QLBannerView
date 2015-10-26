//
//  QLCyclicADPlayer.m
//  QLCyclicADPlayer
//
//  Created by 闫庆龙 on 15/4/13.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

/** QLPureLog : Without NSLog's TimeStamp */
#ifdef DEBUG
#define QLPureLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define QLPureLog(...)
#endif

/** DEBUG Print */
#ifdef DEBUG
#define QLLog(...) NSLog(__VA_ARGS__)
#else
#define QLLog(...)
#endif

#import "QLCyclicADPlayer.h"


@interface QLCyclicADPlayer () <UIScrollViewDelegate>
{
    // 滚动视图
    __weak UIScrollView *_scrollView;
    
    // 页指示器
    __weak UIPageControl *_pageCtrl;
    
    // 标题
    UILabel *_lblTitle;
    
    //循环滚动的三个视图
    UIImageView *_imvLeft;
    UIImageView *_imvCenter;
    UIImageView *_imvRight;
    
    // 计时器
    NSTimer *_timer;
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    BOOL _isTimerMakeScroll;
    
    NSArray *_arrUrls;
    NSArray *_arrTitles;
    
    NSUInteger _numberOfPages;
    
    NSUInteger _indexCurrent;
    
    BOOL _isCyclicAnimating;
}

@end

@implementation QLCyclicADPlayer

- (instancetype)init {
    if (self = [super init]) {
        [self loadDefaultSetting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

- (void)loadDefaultSetting {
    // _scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    scrollView.backgroundColor = [UIColor orangeColor];
    
    // 重复利用的3张UIImageView
    _imvLeft = [[UIImageView alloc]init];
    [_scrollView addSubview:_imvLeft];
    _imvCenter = [[UIImageView alloc]init];
    [_scrollView addSubview:_imvCenter];
    _imvRight = [[UIImageView alloc]init];
    [_scrollView addSubview:_imvRight];
    
    // _pageCtrl
    UIPageControl *pageCtrl = [[UIPageControl alloc] init];
    [self addSubview:pageCtrl];
    _pageCtrl = pageCtrl;
    
    // 时间间隔
    _timeInterval = 3.0f;
    _animationInterval = 0.25f;
    
    _indexCurrent = 1;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)]];
}

- (void)tapGRAction:(UITapGestureRecognizer *)grTap {
    if ([_actionDelegate respondsToSelector:@selector(cyclicADPlayer:DidClickAtIndex:)]) {
        [_actionDelegate cyclicADPlayer:self DidClickAtIndex:_indexCurrent];
    }
}

- (void)layoutSubviews {
    // _scrollView
    CGSize sizeSelf = self.frame.size;
    CGFloat fWidthSelf = sizeSelf.width;
    CGFloat fHeightSelf = sizeSelf.height;
    _scrollView.contentOffset = CGPointMake(fWidthSelf, 0);
    _scrollView.contentSize = CGSizeMake(fWidthSelf * 3, fHeightSelf);
    
    // 重复利用的3张UIImageView
    CGRect rectImvLeft = CGRectMake(0, 0, fWidthSelf, fHeightSelf);
    _imvLeft.frame = rectImvLeft;
    CGRect rectImvCenter = CGRectMake(fWidthSelf, 0, fWidthSelf, fHeightSelf);
    _imvCenter.frame = rectImvCenter;
    CGRect rectImvRight = CGRectMake(fWidthSelf*2, 0, fWidthSelf, fHeightSelf);
    _imvRight.frame = rectImvRight;
    
    // _pageCtrl
    CGFloat fHeightPageCtrl = 30;
    CGRect rectPageCtrl = CGRectMake(0, fHeightSelf-fHeightPageCtrl, fWidthSelf, fHeightPageCtrl);
    _pageCtrl.frame = rectPageCtrl;
}

- (void)reloadData {
    NSUInteger numberOfPages = 0; // 总页数
    if ([_dataSourceDelegate respondsToSelector:@selector(numberOfPagesInCyclicADPlayer:)]) {
        numberOfPages = [_dataSourceDelegate numberOfPagesInCyclicADPlayer:self];
    }
    if (numberOfPages <= 0) {
        // 在这里可以显示一张默认的图片,并设置不可滑动
        _scrollView.scrollEnabled = NO;
        return;
    } else {
        if (numberOfPages > 1) {
            _pageCtrl.hidden = NO;
            _pageCtrl.numberOfPages = numberOfPages;
            _scrollView.scrollEnabled = YES;
        } else {
            _pageCtrl.hidden = YES;
            _scrollView.scrollEnabled = NO;
        }
    }
    _numberOfPages = numberOfPages;
    
    NSMutableArray *arrMUrls = [NSMutableArray arrayWithCapacity:numberOfPages];
    NSMutableArray *arrMTitles = [NSMutableArray arrayWithCapacity:numberOfPages];
    for (NSUInteger index = 0; index < numberOfPages; index ++) {
        // 添加Urls数组
        NSURL *url = [_dataSourceDelegate cyclicADPlayer:self UrlAtIndex:index];
        [arrMUrls insertObject:url atIndex:index];
        
        // 添加标题
        if ([_dataSourceDelegate respondsToSelector:@selector(cyclicADPlayer:TitleAtIndex:)]) {
            NSString *strTitle = [_dataSourceDelegate cyclicADPlayer:self TitleAtIndex:index];
            [arrMTitles insertObject:strTitle atIndex:index];
        } else {
            [arrMTitles insertObject:@"" atIndex:index];
        }
    }
    _arrUrls = [arrMUrls copy];
    _arrTitles = [arrMTitles copy];
    
    NSURL *urlLeft = _arrUrls[(_indexCurrent-1)%numberOfPages];
    NSURL *urlCenter = _arrUrls[_indexCurrent%numberOfPages];
    NSURL *urlRight = _arrUrls[(_indexCurrent+1)%numberOfPages];
    _imvLeft.image = [UIImage imageNamed:urlLeft.lastPathComponent];
    _imvCenter.image = [UIImage imageNamed:urlCenter.lastPathComponent];
    _imvRight.image = [UIImage imageNamed:urlRight.lastPathComponent];
    
    // 启动循环播放
    if (numberOfPages > 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(scrollTheScrollView) userInfo:nil repeats:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger count = _arrUrls.count;
    if (_scrollView.contentOffset.x == 0) {  // 左划处理
        _indexCurrent = (_indexCurrent - 1)%count;
        _pageCtrl.currentPage = (_pageCtrl.currentPage - 1)%count;
    } else if (_scrollView.contentOffset.x == scrollView.frame.size.width * 2) { // 右划处理
        _indexCurrent = (_indexCurrent + 1)%count;
        _pageCtrl.currentPage = (_pageCtrl.currentPage + 1)%count;
    } else {
        return;
    }
    
    // 后面使用GCD队列实现图片的下载
    NSURL *urlLeft = _arrUrls[(_indexCurrent-1)%count];
    NSURL *urlCenter = _arrUrls[_indexCurrent%count];
    NSURL *urlRight = _arrUrls[(_indexCurrent+1)%count];
    _imvLeft.image = [UIImage imageNamed:urlLeft.lastPathComponent];
    _imvCenter.image = [UIImage imageNamed:urlCenter.lastPathComponent];
    _imvRight.image = [UIImage imageNamed:urlRight.lastPathComponent];

    _scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimerMakeScroll) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
    }
    _isTimerMakeScroll = NO;
}

- (void)scrollTheScrollView {
    [UIView animateWithDuration:_animationInterval animations:^{
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * 2, 0);
    }];
    _isTimerMakeScroll = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndDecelerating:_scrollView];
    });
}

- (void)setDataSourceDelegate:(id<QLCyclicADPlayerDataSourceDelegate>)dataSourceDelegate {
    _dataSourceDelegate = dataSourceDelegate;
    [self reloadData];
}


- (void)pauseCyclicADPlayer {
    [_timer setFireDate:[NSDate distantFuture]];
    _isCyclicAnimating = NO;
}
- (void)resumeCyclicADPlayer {
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
    _isCyclicAnimating = YES;
}

- (void)didMoveToWindow {
    if (self.window) {
        if (!_isCyclicAnimating) {
            [self resumeCyclicADPlayer];
        }
    } else {
        [self pauseCyclicADPlayer];
    }
}

@end
