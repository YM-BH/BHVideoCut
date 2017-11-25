//
//  ShowVideoCell.m
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import "ShowVideoCell.h"
#import "VideoModel.h"
#import "VideoManager.h"

@interface ShowVideoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;


@end


@implementation ShowVideoCell

- (void)setVideoModel:(VideoModel *)videoModel
{
    _videoModel = videoModel;
    
    CGFloat w = CGRectGetWidth(self.bounds);
    
    [VideoManager getVideoPhotoWithAsset:videoModel.asset size:CGSizeMake(w * 1.3, w * 1.3) completion:^(UIImage *videoImage) {
       
        self.videoImgView.image = videoImage;
        
    }];
}

@end
