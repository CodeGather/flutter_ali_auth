//
//  PNSBuildModelUtils.h
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PNSBuildModelStyle) {
    //全屏
    PNSBuildModelStylePortrait,
    PNSBuildModelStyleLandscape,
    PNSBuildModelStyleAutorotate,
    
    //弹窗
    PNSBuildModelStyleAlertPortrait,
    PNSBuildModelStyleAlertLandscape,
    PNSBuildModelStyleAlertAutorotate,
    
    //底部弹窗
    PNSBuildModelStyleSheetPortrait,
    
    //DIY 动画
    PNSDIYAlertPortraitFade,
    PNSDIYAlertPortraitDropDown,
    PNSDIYAlertPortraitBounce,
    PNSDIYPortraitFade,
    PNSDIYPortraitScale,
    
    //other
    PNSBuildModelStyleVideoBackground,
    PNSBuildModelStyleGifBackground,
};

@interface PNSBuildModelUtils : NSObject

+ (TXCustomModel *)buildModelWithStyle:(PNSBuildModelStyle)style
                          button1Title:(NSString *)button1Title
                               target1:(id)target1
                             selector1:(SEL)selector1
                          button2Title:(NSString *)button2Title
                               target2:(id)target2
                             selector2:(SEL)selector2;

@end

NS_ASSUME_NONNULL_END
