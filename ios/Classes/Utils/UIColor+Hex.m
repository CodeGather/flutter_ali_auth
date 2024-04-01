//
//  UIColor+Hex.m
//  ali_auth
//
//  Created by Yau on 2023/4/13.
//
#import "UIColor+Hex.h"

@implementation UIColor (Hex)
+ (UIColor*)colorWithHex:(NSString*)hexColor defaultValue:(NSString*)defaultValue {
  if (
      hexColor == nil  || [hexColor  isEqual: @""]
  ) {
    hexColor = defaultValue;
  }
  
  if (hexColor.length < 8) {
    return [self colorWithHexString: hexColor alpha: 1 defaultValue: [UIColor blueColor]];
  }
  
  unsigned int alpha, red, green, blue;
  NSRange range;
  range.length =2;

  range.location =1;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&alpha];//透明度
  range.location =3;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
  range.location =5;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
  range.location =7;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
  return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:(float)(alpha/255.0f)];
}


/**
 16进制颜色转换为UIColor
 @param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 @param opacity 透明度
 @return 16进制字符串对应的颜色
 */
+(UIColor *)colorWithHexString:(NSString *)hexColor alpha:(CGFloat)opacity defaultValue:(UIColor*)defaultValue{
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

  
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];

    if ([cString length] != 6) return [UIColor blackColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];

    range.location = 2;
    NSString * gString = [cString substringWithRange:range];

    range.location = 4;
    NSString * bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}

+ (UIColor *)colorWithAlphaHex:(NSInteger)hex alpha:(CGFloat)alpha defaultValue:(UIColor*)defaultValue{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}
@end
