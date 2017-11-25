//
//  VideoManager.h
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^videoImgBlock)(UIImage *videoImage);
typedef void(^urlAssetBlock)(AVURLAsset *urlAsset);

typedef NS_ENUM(NSInteger, VidepAuthorizeStatus) {
    
    VidepAuthorizeStatusAuthorize = 0,
    VidepAuthorizeStatusRejected,
    VidepAuthorizeStatusNotDetertmined,
    VidepAuthorizeStatusUnkowned
    
};


@interface VideoManager : NSObject

/**
 获取视频列表

 @return 模型数组
 */
+ (NSArray *)getVideoList;


/**
 获取授权状态

 @return 授权状态
 */
+ (VidepAuthorizeStatus)getAuthorizeStaus;

+ (void)getVideoPhotoWithAsset:(PHAsset *)asset size:(CGSize)size completion:(videoImgBlock)completion;


/**
 获取 AVURLAsset

 @param asset PHAsset
 @param completion 回调urlAsset
 */
+ (void)getURLAssetWithAsset:(PHAsset *)asset completion:(urlAssetBlock)completion;

@end
