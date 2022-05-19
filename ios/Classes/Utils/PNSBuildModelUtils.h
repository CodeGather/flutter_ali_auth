//
//  PNSBuildModelUtils.h
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import <ATAuthSDK/ATAuthSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNSBuildModelUtils : NSObject

+ (TXCustomModel *)buildModelWithStyle:(NSDictionary *)dict
                               target:(id)target
                             selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
