//
//  UIColor+Hex.h
//  Pods
//
//  Created by Yau on 2023/4/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef UIColor_Hex_h
#define UIColor_Hex_h

@interface UIColor (Hex)
+ (UIColor*)colorWithHex:(NSString *)hex defaultValue:(NSString *)defaultValue;
+ (UIColor*)colorWithHexString:(NSString *)hex alpha: (CGFloat)opacity defaultValue:(UIColor *)defaultValue;
+ (UIColor*)colorWithAlphaHex:(NSInteger)hex alpha: (CGFloat)opacity defaultValue:(UIColor *)defaultValue;
@end

#endif /* UIColor_Hex_h */
