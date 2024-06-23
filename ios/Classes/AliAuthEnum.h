//
//  AliAuthEnum.好的.h
//  Pods
//
//  Created by Yau的MacBook on 2022/5/19.
//  Copyright © 2022 Yau的MacBook. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface AliAuthEnum : NSObject
+ (NSDictionary *)initData;
+ (NSDictionary *)keyPair;
@end
// FOUNDATION_EXPORT NSString * const StatusAll;

typedef NS_ENUM(NSUInteger, PNSBuildModelStyle) {
    //全屏
    PNSBuildModelStylePortrait,
    PNSBuildModelStyleLandscape,
    //PNSBuildModelStyleAutorotate,
    
    //弹窗
    PNSBuildModelStyleAlertPortrait,
    PNSBuildModelStyleAlertLandscape,
    // PNSBuildModelStyleAlertAutorotate,
    
    //底部弹窗
    PNSBuildModelStyleSheetPortrait,
    
    //DIY 动画
    PNSDIYAlertPortraitFade,
    PNSDIYAlertPortraitDropDown,
    // PNSDIYAlertPortraitBounce,
//    PNSDIYPortraitFade,
//    PNSDIYPortraitScale,
  
    PNSBuildModelStyleGifBackground,
    //other
    PNSBuildModelStyleVideoBackground,
    PNSBuildModelStylePicBackground,
};

