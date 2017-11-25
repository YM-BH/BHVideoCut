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

+ (VidepAuthorizeStatus)getAuthorizeStaus
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
//        NSLog(@"拒绝");
        
        return VidepAuthorizeStatusRejected;
    }else if (status == PHAuthorizationStatusNotDetermined) {
//        NSLog(@"未决定");
        return VidepAuthorizeStatusNotDetertmined;
    }else if (status == PHAuthorizationStatusAuthorized) {
//        NSLog(@"授权");
        return VidepAuthorizeStatusAuthorize;
    }else {
        return VidepAuthorizeStatusUnkowned;
    }
    
}

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

+ (void)getVideoPhotoWithAsset:(PHAsset *)asset size:(CGSize)size completion:(videoImgBlock)completion 
{
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
       
        BOOL downloadFinished = ![info objectForKey:PHImageCancelledKey] && ![info objectForKey:PHImageErrorKey];
        
        // 加上这个key 会不返回缩略图 
        // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        
        if (downloadFinished) {
//            NSLog(@"%@",result);
            if (completion) {
                completion(result);
            }
        }
        
        
    }];
}

+ (void)getURLAssetWithAsset:(PHAsset *)asset completion:(urlAssetBlock)completion
{
    // 保证其他格式（比如慢动作）视频为正常视频
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    
    [[PHCachingImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
       
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        
        if (completion) {
            completion(urlAsset);
        }
        
    }];
}

@end
