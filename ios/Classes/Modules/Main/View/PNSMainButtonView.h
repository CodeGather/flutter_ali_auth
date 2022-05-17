//
//  PNSMainButtonView.h
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNSMainButtonView : UIView

- (instancetype)initWithButtonTitle:(NSString *)buttonTitle
                       buttonTarget:(id)buttonTarget
                       buttonAction:(SEL)buttonAction
                    descriptionText:(NSString *)descriptionText;

@end

NS_ASSUME_NONNULL_END
