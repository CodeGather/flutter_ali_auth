//
//  ACMUploadManager.h
//  Monitor
//
//  Created by Vienta on 2019/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACMUploadManager : NSObject

/**
 * 上传失败的数据，同时会上传埋点和日志的数据，如果有降级限流的情况，最好是在设置完成相应的降级接口（setACMLoggerEnable:和 setACMMonitorEnable）之后调用
 */
+ (void)uploadFailedData;

/**
 * 业务层配置降级限流
 */
+ (void)setLimitConfig:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
