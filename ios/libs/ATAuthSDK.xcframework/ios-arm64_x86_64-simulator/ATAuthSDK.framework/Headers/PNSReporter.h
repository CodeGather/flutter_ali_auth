//
//  PNSReporter.h
//  ATAuthSDK
//
//  Created by 刘超的MacBook on 2020/5/21.
//  Copyright © 2020. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PNSLoggerLevel) {
    PNSLoggerLevelVerbose = 1,
    PNSLoggerLevelDebug,
    PNSLoggerLevelInfo,
    PNSLoggerLevelWarn,
    PNSLoggerLevelError
};

@interface PNSReporter : NSObject

/**
 *  控制台日志输出开关，若开启会以PNS_LOGGER为开始标记对日志进行输出，Release模式记得关闭！
 *  @param enable 开关参数，默认为NO
 */
- (void)setConsolePrintLoggerEnable:(BOOL)enable;

/**
 *  设置埋点上传开关，但不会对通过 setupUploader: 接口实现的自定义上传方法起作用
 *  @param  enable 开关设置BOOL值，默认为YES
 */
- (void)setUploadEnable:(BOOL)enable DEPRECATED_MSG_ATTRIBUTE("日志不再上传");;

@end

NS_ASSUME_NONNULL_END
