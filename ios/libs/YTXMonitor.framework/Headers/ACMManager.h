
#import <Foundation/Foundation.h>
#import <YTXMonitor/ACMLogger.h>
#import <YTXMonitor/ACMMonitor.h>
#import <YTXMonitor/ACMProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACMManager : NSObject

/// 日志操作对象
@property (nonatomic, strong, readonly) ACMLogger *logger;

/// 埋点操作对象
@property (nonatomic, strong, readonly) ACMMonitor *monitor;

- (instancetype)init NS_UNAVAILABLE;

/**
 *  初始化
 *  @param  databaseName 数据库名，不指定则默认为 “ACMDatabase”
 *  @param  monitorTableName 埋点表名，必须要指定，用来区分不同产品数据
 *  @param  loggerTablename 日志表名，必须要指定，用来区分不同产品数据
 *  @param  limitKeyPrefix 限流信息存储到本地key的前缀，用来区分不同产品的限流缓存
 */
- (instancetype)initWithDatabaseName:(NSString * _Nullable)databaseName
                    monitorTableName:(NSString *)monitorTableName
                     loggerTableName:(NSString *)loggerTablename
                      limitKeyPrefix:(NSString *)limitKeyPrefix;

/**
 *  初始化
 *  @param  databaseName 数据库名，不指定则默认为 “ACMDatabase”
 *  @param  monitorTableName 埋点表名，必须要指定，用来区分不同产品数据
 *  @param  loggerTablename 日志表名，必须要指定，用来区分不同产品数据
 *  @param  limitKeyPrefix 限流信息存储到本地key的前缀，用来区分不同产品的限流缓存
 *  @param  uploadCount 每次上传条数
 *  @param  retryRightNow 上传失败是否立马重试，默认立马重试
 *  @param  uploadOnce 是否只执行一轮上传，默认NO
 */
- (instancetype)initWithDatabaseName:(NSString * _Nullable)databaseName
                    monitorTableName:(NSString *)monitorTableName
                     loggerTableName:(NSString *)loggerTablename
                      limitKeyPrefix:(NSString *)limitKeyPrefix
                         uploadCount:(NSInteger)uploadCount
                       retryRightNow:(BOOL)retryRightNow
                          uploadOnce:(BOOL)uploadOnce;

/**
 *  获取组件当前版本号
 */
- (NSString *)getVersion;

/**
 *  设置日志埋点上传代理对象
 *  注：这里是强引用
 *  @param  uploadDelegate 代理对象，需要实现 ACMProtocol 协议
 */
- (void)setUploadDelegate:(id<ACMProtocol> _Nullable)uploadDelegate;

/**
 *  更新限流相关
 *  @param  isLimit 是否限流
 *  @param  limitTimeHour 限流区间大小
 *  @param  limitCount 区间内限流次数
 */
- (void)updateLimitConfig:(BOOL)isLimit
            limitTimeHour:(NSInteger)limitTimeHour
               limitCount:(NSInteger)limitCount;

@end

NS_ASSUME_NONNULL_END
