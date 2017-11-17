//
//  VideoModel.h
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface VideoModel : NSObject

@property (strong, nonatomic) PHAsset *asset;

+ (instancetype)modelWithAsset:(PHAsset *)asset;

@end
