//
//  ACMMonitor.h
//  Monitor
//
//  Created by Vienta on 2019/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACMMonitor : NSObject

/**
 *  上传非实时埋点
 *  @param  obj 埋点内容
 *  @return 埋点存储结果
 */
+ (BOOL)monitorRecord:(id)obj;

/**
 *  上传实时埋点
 *  @param  obj 埋点内容
 *  @return 埋点上传准备结果
 */
+ (BOOL)monitorRealtimeRecord:(id)obj;

/**
 *  开始手动上传，在设置uploadType为ACMMonitorUploadManual时生效
 */
+ (void)uploadMonitorByManual;

@end

NS_ASSUME_NONNULL_END
