//
//  EditViewController.m
//  VideoCutDemo
//
//  Created by bh on 2017/11/25.
//  Copyright © 2017年 bh. All rights reserved.
//

#import "EditViewController.h"
#import "SAVideoRangeSlider.h"
#import "VideoManager.h"
#import "VideoModel.h"
#import "SCVideoPlayerView.h"

#define ScreenW         [UIScreen mainScreen].bounds.size.width
#define ScreenH         [UIScreen mainScreen].bounds.size.height


@interface EditViewController () <SAVideoRangeSliderDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) SAVideoRangeSlider *slider;
@property (strong, nonatomic) SCVideoPlayerView *playerView;
@property (strong, nonatomic) AVAsset *avAsset;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat endTime;


@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 方式 右滑返回 和 pan手势冲突

    [self setupUI];
    
    // 设置开始和结束时间的初始值
    self.startTime = 0.0;
    self.endTime = self.videoModel.asset.duration;
    
    [VideoManager getURLAssetWithAsset:self.videoModel.asset completion:^(AVURLAsset *urlAsset) {
        
        self.avAsset = urlAsset;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.slider getMovieFrame:urlAsset.URL];
            
            [self.playerView.player setItemByAsset:urlAsset];
            [self.playerView.player setLoopEnabled:NO];
            [self.playerView.player play];
        });
        
    }];
    
}

- (void)setupUI
{
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.title = @"编辑视频";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.slider];
    [self.view addSubview:self.playerView];
    
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cutBtn setTitle:@"cut" forState:UIControlStateNormal];
    [cutBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cutBtn.bounds = CGRectMake(0, 0, 100, 30);
    cutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cutBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cutBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)cutBtnClick
{
    NSLog(@"裁剪视频中。。。。");
    [VideoManager cutVideoWithAVAsset:self.avAsset startTime:self.startTime endTime:self.endTime completion:^(NSURL *outputURL) {
        
        NSLog(@"裁剪成功");
        NSLog(@"output --- %@",outputURL);
        // 导出成功
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma mark - SAVideoRangeSliderDelegate
- (void)videoRange:(SAVideoRangeSlider *)videoRange isLeft:(BOOL)isLeft didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition
{
    NSLog(@"%f ---- %f",leftPosition,rightPosition);
    
    float f = 0;
    if (isLeft) {
        f = leftPosition;
    }else {
        f = rightPosition;
    }
    
    self.startTime = leftPosition;
    self.endTime = rightPosition;
    
    // 快进 / 快退
    CMTime time = CMTimeMakeWithSeconds(f, self.playerView.player.currentTime.timescale);
    [self.playerView.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark - lazy

- (SAVideoRangeSlider *)slider
{
    if (!_slider) {
        _slider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, ScreenH * 0.6, ScreenW, 44)];
        _slider.delegate = self;
    }
    return _slider;
}

- (SCVideoPlayerView *)playerView
{
    if (!_playerView) {
        
        _playerView = [[SCVideoPlayerView alloc] init];
        _playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _playerView.backgroundColor = [UIColor orangeColor];
        _playerView.frame = CGRectMake(0, 0, ScreenW, 0.5 * ScreenH);
        
    }
    
    return _playerView;
    
}

@end
