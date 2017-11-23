//
//  ChooseVideoController.m
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import "ChooseVideoController.h"
#import "ShowVideoController.h"
#import "VideoManager.h"

@interface ChooseVideoController ()

@end

@implementation ChooseVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)chooseVideo:(id)sender {
    VidepAuthorizeStatus status = [VideoManager getAuthorizeStaus];
    
    switch (status) {
        case VidepAuthorizeStatusAuthorize: {
            // 第二次进入时候，如果已经授权，走这里
            NSLog(@"授权");
            [self jumpToShowVideoVC];
        }
            break;
        case VidepAuthorizeStatusNotDetertmined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
               // 弹出授权窗口，选择授权，回调这里,子线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self jumpToShowVideoVC];
                    }
                });
                
            }];
        }
            break;
            
        case VidepAuthorizeStatusRejected: {
            NSLog(@"未授权,引导去授权界面");
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
            break;
        default:
            NSLog(@"未知情况");
            break;
    }
    
}

- (void)jumpToShowVideoVC
{
    ShowVideoController *showVc = [[ShowVideoController alloc] init];
    [self.navigationController pushViewController:showVc animated:YES];
}



@end
