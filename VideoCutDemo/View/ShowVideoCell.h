//
//  ShowVideoCell.h
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoModel;

@interface ShowVideoCell : UICollectionViewCell

/**
 视频模型
 */
@property (strong, nonatomic) VideoModel *videoModel;

@end
