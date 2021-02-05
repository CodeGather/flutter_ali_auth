//
//  ACMUploadInterface.h
//  Monitor
//
//  Created by 沈超 on 2019/12/17.
//

@protocol ACMProtocol <NSObject>

@required
/**
 * 埋点聚合上传（包括轮询和手动）
 * @param monitors 需要上传的埋点信息
 * @return 上传是否成功，建议上传采用同步策略
 */
- (BOOL)uploadMonitors:(NSArray<NSDictionary *> *)monitors;

/**
 * 日志上传
 * @param logContents 需要上传的日志
 * @return 上传是否成功，建议上传采用同步策略
 */
- (BOOL)uploadLogs:(NSArray<NSDictionary *> *)logContents;

@end
