//
//  GCCScrollLoop.m
//  myToolCreate
//
//  Created by 郭春城 on 16/2/29.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "GCCScrollLoop.h"

@interface GCCScrollLoop ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) BOOL repeat;
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) dispatch_source_t dispatchTimer;
@property (nonatomic, assign) CGFloat repeatTime;

@end

@implementation GCCScrollLoop

#pragma mark - 通过本地图片初始化所需ScrollView
- (instancetype)initWithFrame:(CGRect)frame LocalImageNameArray:(NSArray *)array Repeat:(BOOL)repeat
{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = frame.size.width;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        if (array) {
            self.pageNum = array.count;
            self.repeat = repeat;
            if (repeat) {
                NSMutableArray * dataArray = [[NSMutableArray alloc] initWithArray:array];
                [dataArray addObject:[array firstObject]];
                [dataArray insertObject:[array lastObject] atIndex:0];
                [self createMyScrollViewWithLoaclImageName:dataArray];
                self.contentOffset = CGPointMake(width, 0);
            }else{
                [self createMyScrollViewWithLoaclImageName:array];
                self.contentOffset = CGPointMake(0, 0);
            }
        }
    }
    self.delegate = self;
    return self;
}

#pragma mark - 通过网络图片初始化所需ScrollView
- (instancetype)initWithFrame:(CGRect)frame NetWorkURLArray:(NSArray *)array Repeat:(BOOL)repeat
{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = frame.size.width;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        if (array) {
            self.pageNum = array.count;
            self.repeat = repeat;
            if (repeat) {
                NSMutableArray * dataArray = [[NSMutableArray alloc] initWithArray:array];
                [dataArray addObject:[array firstObject]];
                [dataArray insertObject:[array lastObject] atIndex:0];
                [self createMyScrollViewWithNetWorkURL:dataArray];
                self.contentOffset = CGPointMake(width, 0);
            }else{
                [self createMyScrollViewWithNetWorkURL:array];
                self.contentOffset = CGPointMake(0, 0);
            }
        }
    }
    self.delegate = self;
    return self;
}

#pragma mark - 通过网络图片循环创建scrollView中的ImageView
- (void)createMyScrollViewWithNetWorkURL:(NSArray *)array
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.contentSize = CGSizeMake(array.count * width, height);
    if (self.repeat) {
        for (int i = 0; i < array.count; i++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
            imageView.tag = i - 1;
            imageView.userInteractionEnabled = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:array[i]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageView setImage:[UIImage imageWithData:data]];
                });
            });
            [self addTapGesture:imageView];
            [self addSubview:imageView];
        }
    }else{
        for (int i = 0; i < array.count; i++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:array[i]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageView setImage:[UIImage imageWithData:data]];
                });
            });
            [self addTapGesture:imageView];
            [self addSubview:imageView];
        }
    }
}

#pragma mark - 通过本地图片循环创建scrollView中的ImageView
- (void)createMyScrollViewWithLoaclImageName:(NSArray *)array
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.contentSize = CGSizeMake(array.count * width, height);
    if (self.repeat) {
        for (int i = 0; i < array.count; i++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
            imageView.tag = i - 1;
            imageView.userInteractionEnabled = YES;
            [imageView setImage:[UIImage imageNamed:array[i]]];
            [self addTapGesture:imageView];
            [self addSubview:imageView];
        }
    }else{
        for (int i = 0; i < array.count; i++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView setImage:[UIImage imageNamed:array[i]]];
            [self addTapGesture:imageView];
            [self addSubview:imageView];
        }
    }
}

#pragma mark - 创建pageControl
- (void)createPageControl
{
    if (nil == self.pageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.pageNum * 15, 20)];
        self.pageControl.numberOfPages = self.pageNum;
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 30);
        [self.superview addSubview:self.pageControl];
    }
}

#pragma mark - 创建下方页数标签
- (void)createIndexLabel
{
    if (nil == self.label) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x + self.frame.size.width - 50, self.frame.origin.y + self.frame.size.height - 30, 30, 15)];
        self.label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.label.text = [NSString stringWithFormat:@"1/%ld", self.pageNum];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:12];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.superview addSubview:self.label];
    }
}

#pragma mark - 创建计时器
- (void)createDispatchTimerWithInterval:(CGFloat)interval
{
    self.repeatTime = interval;
    if (nil == self.dispatchTimer) {
        CGFloat width = self.frame.size.width;
        self.dispatchTimer = CreateDispatchTimer(interval, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5f animations:^{
                self.contentOffset = CGPointMake(self.contentOffset.x + width, 0);
            }];
            if (self.repeat) {
                if (self.contentOffset.x == 0) {
                    self.contentOffset = CGPointMake(width * self.pageNum, 0);
                }else if (self.contentOffset.x == width * (self.pageNum + 1)){
                    self.contentOffset = CGPointMake(width, 0);
                }
                self.pageControl.currentPage = self.contentOffset.x / width - 1;
                if (self.label) {
                    self.label.text = [NSString stringWithFormat:@"%ld/%ld", self.pageControl.currentPage + 1, self.pageNum];
                }
                return;
            }
            self.pageControl.currentPage = self.contentOffset.x / width;
            if (self.label) {
                self.label.text = [NSString stringWithFormat:@"%ld/%ld", self.pageControl.currentPage + 1, self.pageNum];
            }
        });
    }
}

#pragma mark - CreateDispatchTimer
dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

#pragma mark - 为ImageView添加单机手势
- (void)addTapGesture:(UIImageView *)imageView;
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClicked:)];
    tap.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:tap];
}

- (void)imageViewDidClicked:(UITapGestureRecognizer *)tap
{
    if ([_clickedDelegate respondsToSelector:@selector(GCCScrollLoopDidClickedImage:ofIndex:)]) {
        UIImageView * imageView = (UIImageView *)tap.view;
        [_clickedDelegate GCCScrollLoopDidClickedImage:imageView ofIndex:imageView.tag];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = self.frame.size.width;
    if (self.repeat) {
        if (self.contentOffset.x == 0) {
            self.contentOffset = CGPointMake(width * self.pageNum, 0);
        }else if (self.contentOffset.x == width * (self.pageNum + 1)){
            self.contentOffset = CGPointMake(width, 0);
        }
        self.pageControl.currentPage = self.contentOffset.x / width - 1;
        if (self.label) {
            self.label.text = [NSString stringWithFormat:@"%ld/%ld", self.pageControl.currentPage + 1, self.pageNum];
        }
        return;
    }
    self.pageControl.currentPage = self.contentOffset.x / width;
    if (self.label) {
        self.label.text = [NSString stringWithFormat:@"%ld/%ld", self.pageControl.currentPage + 1, self.pageNum];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dispatch_cancel(self.dispatchTimer);
    self.dispatchTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self createDispatchTimerWithInterval:self.repeatTime];
}

@end
