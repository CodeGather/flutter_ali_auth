//
//  PNSBuildModelUtils.h
//  ATAuthSceneDemo
//
//  Created by Yau的MacBook on 2022/5/19.
//  Copyright © 2022 Yau的MacBook. All rights reserved.
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
