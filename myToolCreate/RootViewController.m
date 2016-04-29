//
//  RootViewController.m
//  myToolCreate
//
//  Created by 郭春城 on 16/2/29.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "RootViewController.h"
#import "GCCScrollLoop.h"

@interface RootViewController ()<GCCScrollLoopClickedDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //本地图片数组示例
    NSArray * array = @[@"guide_1-4.7",@"guide_2-4.7",@"guide_3-4.7",@"guide_4-4.7",@"guide_5-4.7"];

    //网络图片数组示例
//    NSArray * array = @[@"http://img5.duitang.com/uploads/item/201401/21/20140121160054_Em4VL.jpeg",@"http://upload.520apk.com/news/20150204/14230286909787.jpg",@"http://b.zol-img.com.cn/sjbizhi/images/5/320x510/1373527673986.jpg",@"http://imgsrc.baidu.com/forum/w%3D580/sign=da42568eb3de9c82a665f9875c8080d2/fd039245d688d43fcf8e23457d1ed21b0ef43b65.jpg",@"http://img4.duitang.com/uploads/item/201401/21/20140121155622_5WMKd.thumb.700_0.jpeg"];
    
    //本地图片初始化scrollView对象
    GCCScrollLoop * scroll = [[GCCScrollLoop alloc] initWithFrame:[UIScreen mainScreen].bounds LocalImageNameArray:array Repeat:YES];
    
    //网络图片初始化scrollView对象
//    GCCScrollLoop * scroll = [[GCCScrollLoop alloc] initWithFrame:[UIScreen mainScreen].bounds NetWorkURLArray:array Repeat:YES];
    
    //设置代理
    scroll.clickedDelegate = self;
    
    [self.view addSubview:scroll];
    
    //创建pageControl
    [scroll createPageControl];
    
    //创建下方页数标签
    [scroll createIndexLabel];
    
    //创建计时器
    [scroll createDispatchTimerWithInterval:4.0f];
}

#pragma mark - GCCScrollLoopClickedDelegate
- (void)GCCScrollLoopDidClickedImage:(UIImageView *)imageView ofIndex:(NSInteger)index
{
    NSLog(@"点击的图片下标是%ld", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
