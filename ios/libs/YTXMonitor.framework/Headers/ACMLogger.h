
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 日志级别
extern NSString * const ACM_LOGGER_LEVEL_VERBOSE;
extern NSString * const ACM_LOGGER_LEVEL_DEBUG;
extern NSString * const ACM_LOGGER_LEVEL_INFO;
extern NSString * const ACM_LOGGER_LEVEL_WARN;
extern NSString * const ACM_LOGGER_LEVEL_ERROR;
extern NSString * const ACM_LOGGER_LEVEL_REALTIME;

@interface ACMLogger : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// 日志是否入库，默认不入库
@property (nonatomic, assign) BOOL enterDatabase;;

/// 日志是否允许上传，默认不上传
@property (nonatomic, assign) BOOL isAllowUpload;

/**
 *  日志入库
 *  @param  obj 日志的具体内容
 *  @param  level 日志等级
 */
- (BOOL)logger:(id)obj level:(NSString *)level ;

/**
 *  上传日志
 *  @param  startDate 日志开始时间，如果传nil则查询不加该条件
 *  @param  endDate 日志结束时间，如果传nil则查询不加该条件
 *  @param  levels 日志等级数组，里面包含对应的日志等级字符串，如果传nil则查询不加该条件
 */
- (void)uploadLoggersWithLevels:(NSArray <NSString *>* _Nullable)levels
                      startDate:(NSDate * _Nullable)startDate
                        endDate:(NSDate * _Nullable)endDate;

/**
 *  上传失败的日志，一般放在重启应用后
 */
- (void)uploadFailedRecords;

@end

NS_ASSUME_NONNULL_END
