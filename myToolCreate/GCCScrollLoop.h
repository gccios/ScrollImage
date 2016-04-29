//
//  GCCScrollLoop.h
//  myToolCreate
//
//  Created by 郭春城 on 16/2/29.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击scrollView的代理，可在点击的时候对不同的图片做出不同的响应
@protocol GCCScrollLoopClickedDelegate <NSObject>

/**
 *  点击scrollView触发的代理函数
 *
 *  @param imageView 被点击的imageView对象
 *  @param index     被点击的imageView下标
 */
- (void)GCCScrollLoopDidClickedImage:(UIImageView *)imageView ofIndex:(NSInteger)index;

@end

@interface GCCScrollLoop : UIScrollView

@property (nonatomic, assign) id<GCCScrollLoopClickedDelegate> clickedDelegate;

/**
 *  网络图片初始化scrollView
 *
 *  @param frame  scrollView视图大小
 *  @param array  网络图片URL数组
 *  @param repeat 是否需要轮播
 *
 *  @return scrollView对象
 */
- (instancetype)initWithFrame:(CGRect)frame NetWorkURLArray:(NSArray *)array Repeat:(BOOL)repeat;

/**
 *  本地图片初始化scrollView
 *
 *  @param frame  scrollView视图大小
 *  @param array  本地图片name数组
 *  @param repeat 是否需要轮播
 *
 *  @return scrollView对象
 */
- (instancetype)initWithFrame:(CGRect)frame LocalImageNameArray:(NSArray *)array Repeat:(BOOL)repeat;

//创建pageControl对象，若需要，则调用此函数即可
- (void)createPageControl;

//创建下方页数标签
- (void)createIndexLabel;

/**
 *  创建定时器
 *
 *  @param interval scrollView页面切换间隔时间
 */
- (void)createDispatchTimerWithInterval:(CGFloat)interval;

@end
