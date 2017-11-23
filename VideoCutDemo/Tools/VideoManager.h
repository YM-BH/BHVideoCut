//
//  VideoManager.h
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

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

+ (VidepAuthorizeStatus)getAuthorizeStaus;

@end
