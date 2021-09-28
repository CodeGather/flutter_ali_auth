
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACMMonitor : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// 埋点是否入库，默认入库
@property (nonatomic, assign) BOOL enterDatabase;;

/// 埋点是否允许上传，默认上传
@property (nonatomic, assign) BOOL isAllowUpload;

/**
 *  非实时埋点入库
 *  @param  obj 埋点具体内容
 */
- (BOOL)monitor:(id)obj;

/**
 *  实时埋点入库
 *  @param  obj 埋点的具体内容
 */
- (BOOL)monitorRealtime:(id)obj;

/**
 *  手动触发埋点上传，只上传未上传过的埋点
 */
- (void)uploadMonitorByManual;

/**
 *  上传失败的埋点，一般放在重启应用后
 */
- (void)uploadFailedRecords;

@end

NS_ASSUME_NONNULL_END
