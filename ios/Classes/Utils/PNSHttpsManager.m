//
//  PNSHttpsManager.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/11.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "PNSHttpsManager.h"

@implementation PNSHttpsManager

+ (void)requestATAuthSDKInfo:(void (^)(BOOL, NSString * _Nonnull))block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(1.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        
        if (block) {
            block(YES, PNSATAUTHSDKINFO);
        }
    });
}

@end
