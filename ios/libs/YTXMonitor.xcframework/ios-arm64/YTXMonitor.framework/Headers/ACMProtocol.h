
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ACMProtocol <NSObject>

@required

/// 埋点抛出，可在抛出里面进行上传
- (BOOL)uploadMonitors:(NSArray<NSDictionary *> *)monitors;
/// 日志抛出，可在抛出里面进行上传
- (BOOL)uploadLoggers:(NSArray<NSDictionary *> *)loggers;

@end

NS_ASSUME_NONNULL_END
