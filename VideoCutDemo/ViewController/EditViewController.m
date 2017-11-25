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
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 方式 右滑返回 和 pan手势冲突
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.title = @"编辑视频";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.slider];
    [self.view addSubview:self.playerView];
    [VideoManager getURLAssetWithAsset:self.videoModel.asset completion:^(AVURLAsset *urlAsset) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.slider getMovieFrame:urlAsset.URL];
        });
        
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
