//
//  VideoManager.m
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import "VideoManager.h"
#import "VideoModel.h"

@implementation VideoManager

+ (NSArray *)getVideoList
{
    NSMutableArray *modelsArr = [NSMutableArray array];
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    
    for (PHAsset *asset in result) {
        
        VideoModel *vm = [VideoModel modelWithAsset:asset];
        
        // 将模型 添加到模型数组
        [modelsArr addObject:vm];
    }
    
    return modelsArr;
}
@end
