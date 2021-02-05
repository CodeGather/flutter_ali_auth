//
//  ACMLogger.h
//  Monitor
//
//  Created by Vienta on 2019/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACMLogger : NSObject

+ (BOOL)verboseRecord:(id)obj;

+ (BOOL)debugRecord:(id)obj;

+ (BOOL)infoRecord:(id)obj;

+ (BOOL)warnRecord:(id)obj;

+ (BOOL)errorRecord:(id)obj;

/**
 *  日志上传
 *  @param  startDate 日志开始时间，如果传nil则查询不加该条件
 *  @param  endDate 日志结束时间，如果传nil则查询不加该条件
 *  @param  levels 日志等级数组，里面包含对应的日志等级字符串，如果传nil则查询不加该条件
 */
+ (void)uploadLoggerRecordsWithStartDate:(NSDate * _Nullable)startDate endDate:(NSDate * _Nullable)endDate levels:(NSArray <NSString *>* _Nullable)levels;

@end

NS_ASSUME_NONNULL_END
