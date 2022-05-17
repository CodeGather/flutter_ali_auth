//
//  PNSLoginStyleSelectController.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/5.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "PNSStyleSelectController.h"
#import "PNSBuildModelUtils.h"
#import "PNSDelayLoginController.h"
#import "PNSSmsLoginController.h"
#import "PrivacyWebViewController.h"

@interface PNSStyleSelectController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *dataSource;

@end

@implementation PNSStyleSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.isDelay ? @"一键登录场景（延迟登录）" : @"一键登录场景（非延迟）";
}

#pragma mark - Logic
- (void)beginOneKeyLoginWithStyle:(PNSBuildModelStyle)style {
    if (self.isDelay) {
        [self delayLoginWithStyle:style];
    } else {
        [self beginLoginWithWithStyle:style];
    }
}

- (void)beginLoginWithWithStyle:(PNSBuildModelStyle)style {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    TXCustomModel *model = [PNSBuildModelUtils buildModelWithStyle:style
                                                      button1Title:@"短信登录（使用系统导航栏）"
                                                           target1:self
                                                         selector1:@selector(gotoSmsControllerAndShowNavBar)
                                                      button2Title:@"短信登录（隐藏系统导航栏）"
                                                           target2:self
                                                         selector2:@selector(gotoSmsControllerAndHiddenNavBar)];
    
    /**
     //修改checkbox按钮大小
     model.checkBoxWH = 30;
     //修改checkbox按钮图片的内边距
     model.checkBoxImageEdgeInsets = UIEdgeInsetsMake(0, 6, 12, 6);
     */
    
    /**
     //自定义协议页面
     model.privacyVCIsCustomized = YES;
     */
    
    /**
     //点击登录按钮时未同意协议时，登录按钮的抖动动画
     CAKeyframeAnimation *privacyAnimation = [CAKeyframeAnimation animation];
     privacyAnimation.keyPath = @"transform.translation.x";
     privacyAnimation.values = @[@(0), @(-10), @(0)];
     privacyAnimation.repeatCount = 2;
     privacyAnimation.speed = 1;
     model.privacyAnimation = privacyAnimation;
     */
    
    __weak typeof(self) weakSelf = self;
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:self
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode]) {
            NSLog(@"页面点击事件回调：%@", resultDic);
        }else if([PNSCodeLoginControllerClickProtocol isEqualToString:resultCode]){
            NSString *privacyUrl = [resultDic objectForKey:@"url"];
            NSString *privacyName = [resultDic objectForKey:@"urlName"];
            NSLog(@"如果TXCustomModel的privacyVCIsCustomized设置成YES，则SDK内部不会跳转协议页，需要自己实现");
            if(model.privacyVCIsCustomized){
                PrivacyWebViewController *controller = [[PrivacyWebViewController alloc] initWithUrl:privacyUrl andUrlName:privacyName];
                controller.isHiddenNavgationBar = NO;
                UINavigationController *navigationController = weakSelf.navigationController;
                if (weakSelf.presentedViewController) {
                    //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                    navigationController = (UINavigationController *)weakSelf.presentedViewController;
                }
                [navigationController pushViewController:controller animated:YES];
            }
        } else if ([PNSCodeSuccess isEqualToString:resultCode]) {
            NSLog(@"获取LoginToken成功回调：%@", resultDic);
            //NSString *token = [resultDic objectForKey:@"token"];
            NSLog(@"接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束");
            //[weakSelf dismissViewControllerAnimated:YES completion:nil];
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        } else {
            NSLog(@"获取LoginToken或拉起授权页失败回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            //失败后可以跳转到短信登录界面
            PNSSmsLoginController *controller = [[PNSSmsLoginController alloc] init];
            controller.isHiddenNavgationBar = NO;
            UINavigationController *navigationController = weakSelf.navigationController;
            if (weakSelf.presentedViewController) {
                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                navigationController = (UINavigationController *)weakSelf.presentedViewController;
            }
            [navigationController pushViewController:controller animated:YES];
        }
    }];
}

- (void)delayLoginWithStyle:(PNSBuildModelStyle)style {
    PNSDelayLoginController *controller = [[PNSDelayLoginController alloc] init];
    controller.style = style;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Action
- (void)gotoSmsControllerAndShowNavBar {
    PNSSmsLoginController *controller = [[PNSSmsLoginController alloc] init];
    controller.isHiddenNavgationBar = NO;
    if (self.presentedViewController) {
        //找到授权页的导航控制器
        [(UINavigationController *)self.presentedViewController pushViewController:controller animated:YES];
    }
}

- (void)gotoSmsControllerAndHiddenNavBar {
    PNSSmsLoginController *controller = [[PNSSmsLoginController alloc] init];
    controller.isHiddenNavgationBar = YES;
    if (self.presentedViewController) {
        //找到授权页的导航控制器
        [(UINavigationController *)self.presentedViewController pushViewController:controller animated:YES];
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] objectForKey:@"section_title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.dataSource objectAtIndex:section] objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *data = [[self.dataSource objectAtIndex:indexPath.section] objectForKey:@"data"];
    cell.textLabel.text = [[data objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *data = [[self.dataSource objectAtIndex:indexPath.section] objectForKey:@"data"];
    PNSBuildModelStyle style = [[[data objectAtIndex:indexPath.row] objectForKey:@"style"] integerValue];
    [self beginOneKeyLoginWithStyle:style];
}

#pragma mark - UI
- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.tableview];
}

- (void)setLayoutSubviews {
    [super setLayoutSubviews];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [UIView new];
    }
    return _tableview;
}

- (NSArray<NSDictionary<NSString *,id> *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[
            @{
                @"section_title" : @"基础",
                @"data" : @[
                        @{
                            @"title" : @"全屏（竖屏）",
                            @"style" : @(PNSBuildModelStylePortrait)
                        },
                        @{
                            @"title" : @"全屏（横屏）",
                            @"style" : @(PNSBuildModelStyleLandscape)
                        },
                        @{
                            @"title" : @"全屏（旋转）",
                            @"style" : @(PNSBuildModelStyleAutorotate)
                        },
                        
                        @{
                            @"title" : @"弹窗（竖屏）",
                            @"style" : @(PNSBuildModelStyleAlertPortrait)
                        },
                        @{
                            @"title" : @"弹窗（横屏）",
                            @"style" : @(PNSBuildModelStyleAlertLandscape)
                        },
                        @{
                            @"title" : @"弹窗（旋转）",
                            @"style" : @(PNSBuildModelStyleAlertAutorotate)
                        },
                        
                        @{
                            @"title" : @"底部弹窗（竖屏）",
                            @"style" : @(PNSBuildModelStyleSheetPortrait)
                        },
                ]
            },
            @{
                @"section_title" : @"DIY 授权页动画",
                @"data" : @[
                        @{
                            @"title" : @"弹窗（竖屏）弹窗渐变效果",
                            @"style" : @(PNSDIYAlertPortraitFade)
                        },
                        @{
                            @"title" : @"弹窗（竖屏）弹窗弹性伸缩效果",
                            @"style" : @(PNSDIYAlertPortraitBounce)
                        },
                        @{
                            @"title" : @"弹窗（竖屏）弹窗下坠效果",
                            @"style" : @(PNSDIYAlertPortraitDropDown)
                        },
                        @{
                            @"title" : @"全屏（竖屏）渐变效果",
                            @"style" : @(PNSDIYPortraitFade)
                        },
                        @{
                            @"title" : @"全屏（竖屏）放大/缩小",
                            @"style" : @(PNSDIYPortraitScale)
                        },
                ]
            },
            @{
                @"section_title" : @"其他",
                @"data" : @[
                        @{
                            @"title" : @"视频背景",
                            @"style" : @(PNSBuildModelStyleVideoBackground)
                        },
                        @{
                            @"title" : @"GIF背景",
                            @"style" : @(PNSBuildModelStyleGifBackground)
                        },
                ]
            }
        ];
    }
    return _dataSource;
}

@end
