//
//  VideoModel.m
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
+ (instancetype)modelWithAsset:(PHAsset *)asset
{
    VideoModel *vm = [[VideoModel alloc] init];
    vm.asset = asset;
    return vm;
}
@end
