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

+ (instancetype)shareManager
{
    static VideoManager *videoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoManager = [[self alloc] init];
    });
    
    return videoManager;
}

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

+ (void)cutVideoWithAVAsset:(AVAsset *)avAsset startTime:(CGFloat)startTime endTime:(CGFloat)endTime completion:(outputBlock)completion
{
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        NSURL *videoPath = [self filePathWithFileName:@"cutVideo.mp4"];
        
        [self cutVideoWithAVAsset:avAsset startTime:startTime endTime:endTime filePath:videoPath completion:^(NSURL *outputURL) {
           
            if (completion) {
                completion(outputURL);
            }
        }];
        
    }
}

+ (void)cutVideoWithAVAsset:(AVAsset *)asset startTime:(CGFloat)startTime endTime:(CGFloat)endTime filePath:(NSURL *)filePath completion:(outputBlock)completion
{
    // 1.将素材拖入素材库
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject]; // 视频轨迹
    
    AVAssetTrack *audioAssetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject]; // 音轨
    
    // 2.将素材的视频插入视频轨道 ，音频插入音轨
    
    AVMutableComposition *composition = [[AVMutableComposition alloc] init]; // AVAsset的子类
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid]; // 视频轨道
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil]; // 在视频轨道插入一个时间段的视频
    
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid]; // 音轨
    
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil]; // 插入音频数据，否则没有声音
    
    // 3. 裁剪视频，就是要将所有的视频轨道进行裁剪，就需要得到所有的视频轨道，而得到一个视频轨道就需要得到它上面的所有素材
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    CMTime totalDuration = CMTimeAdd(kCMTimeZero, asset.duration);
    
    CGFloat videoAssetTrackNaturalWidth = videoAssetTrack.naturalSize.width;
    CGFloat videoAssetTrackNatutalHeight = videoAssetTrack.naturalSize.height;
    
    CGSize renderSize = CGSizeMake(videoAssetTrackNaturalWidth, videoAssetTrackNatutalHeight);
    
    CGFloat renderW = MAX(renderSize.width, renderSize.height);
    
    CGFloat rate;
    
    rate = renderW / MIN(videoAssetTrackNaturalWidth, videoAssetTrackNatutalHeight);
    
    CGAffineTransform layerTransform = CGAffineTransformMake(videoAssetTrack.preferredTransform.a, videoAssetTrack.preferredTransform.b, videoAssetTrack.preferredTransform.c, videoAssetTrack.preferredTransform.d, videoAssetTrack.preferredTransform.tx * rate, videoAssetTrack.preferredTransform.ty * rate);

    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);
    
    [layerInstruction setTransform:layerTransform atTime:kCMTimeZero]; // 得到视频素材
    [layerInstruction setOpacity:0.0 atTime:totalDuration];
    
    AVMutableVideoCompositionInstruction *instrucation = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instrucation.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    instrucation.layerInstructions = @[layerInstruction];
    
    AVMutableVideoComposition *mainComposition = [AVMutableVideoComposition videoComposition];
    mainComposition.instructions = @[instrucation];
    mainComposition.frameDuration = CMTimeMake(1, 30);
    mainComposition.renderSize = CGSizeMake(renderW, renderW); // 裁剪出对应大小
    
    // 4. 导出
    CMTime start = CMTimeMakeWithSeconds(startTime, totalDuration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(endTime - startTime, totalDuration.timescale);
    
    CMTimeRange range = CMTimeRangeMake(start, duration);
    
    // 导出视频
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    session.videoComposition = mainComposition;
    session.outputURL = filePath;
    session.shouldOptimizeForNetworkUse = YES;
    session.outputFileType = AVFileTypeMPEG4;
    session.timeRange = range;
    
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        if ([session status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"%@",[NSThread currentThread]);
            NSLog(@"%@",session.outputURL);
            NSLog(@"导出成功");
            if (completion) {
                completion(session.outputURL);
            }
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"导出失败");
            });
        }
    }];
    
}


+ (NSURL *)filePathWithFileName:(NSString *)fileName
{
    // 获取沙盒 temp 路径
    NSString *tempPath = NSTemporaryDirectory();
    tempPath = [tempPath stringByAppendingPathComponent:@"Video"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 判断文件夹是否存在 不存在创建
    BOOL exits = [manager fileExistsAtPath:tempPath isDirectory:nil];
    if (!exits) {
        
        // 创建文件夹
        [manager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 创建视频存放路径
    tempPath = [tempPath stringByAppendingPathComponent:fileName];
    
    // 判断文件是否存在
    if ([manager fileExistsAtPath:tempPath isDirectory:nil]) {
        // 存在 删除之前的视频
        [manager removeItemAtPath:tempPath error:nil];
    }
    
    return [NSURL fileURLWithPath:tempPath];
}

@end
