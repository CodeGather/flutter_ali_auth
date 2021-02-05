//
//  ACMConfig.h
//  ATAuthSDK
//
//  Created by 刘超的MacBook on 2020/5/19.
//  Copyright © 2020. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACMUploadInterface.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ACMMonitorUploadType) {
    ACMMonitorUploadTypeRealTime,   //实时上传，暂时不支持，如果采用这个方式将以默认的轮询上传实现
    ACMMonitorUploadTypeCirculate,  //轮询上传
    ACMMonitorUploadTypeManual      //手动上传
};

@interface ACMConfig : NSObject

+ (instancetype)sharedInstance;

/// 日志是否入库，默认NO
@property (atomic, assign) BOOL loggerIsSaveInDB;
/// 埋点是否入库，默认YES
@property (atomic, assign) BOOL monitorIsSaveInDB;
/// 日志是否上传，默认NO
@property (atomic, assign) BOOL loggerIsUpload;
/// 埋点是否上传，默认YES
@property (atomic, assign) BOOL monitorIsUpload;

/// 日志埋点组件上传type，默认 ACMMonitorUploadTypeManual
@property (nonatomic, assign) ACMMonitorUploadType uploadType;
/// 日志埋点组件上传代理对象，注：这里是弱引用，组件外面需要保证该上传对象不要被释放，如果被释放掉将影响日志埋点的上传
@property (nonatomic, weak) id<ACMProtocol> uploadDelegate;

/// 更新日志埋点组件限流信息
- (void)setLimitConfig:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
