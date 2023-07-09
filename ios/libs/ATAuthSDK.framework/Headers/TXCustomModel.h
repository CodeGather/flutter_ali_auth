//
//  TXCustomModel.h
//  ATAuthSDK
//
//  Created by yangli on 2019/4/4.
//  Copyright © 2019. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PNSPresentationDirection){
    PNSPresentationDirectionBottom = 0,
    PNSPresentationDirectionRight,
    PNSPresentationDirectionTop,
    PNSPresentationDirectionLeft,
};

/**
 *  构建控件的frame，view布局时会调用该block得到控件的frame
 *  @param  screenSize 屏幕的size，可以通过该size来判断是横屏还是竖屏
 *  @param  superViewSize 该控件的super view的size，可以通过该size，辅助该控件重新布局
 *  @param  frame 控件默认的位置
 *  @return 控件新设置的位置
 */
typedef CGRect(^PNSBuildFrameBlock)(CGSize screenSize, CGSize superViewSize, CGRect frame);

@interface TXCustomModel : NSObject

/**
 * 说明，可设置的Y轴距离，waring: 以下所有关于Y轴的设置<=0都将不生效，请注意
 * 全屏模式：默认是以375x667pt为基准，其他屏幕尺寸可以根据(ratio = 屏幕高度/667)比率来适配，比如 Y*ratio
 */

#pragma mark- 全屏、弹窗模式设置
/**
 *  授权页面中，渲染并显示所有控件的view，称content view，不实现该block默认为全屏模式
 *  实现弹窗的方案 x >= 0 || y >= 0 width <= 屏幕宽度 || height <= 屏幕高度
 */
@property (nonatomic, copy) PNSBuildFrameBlock contentViewFrameBlock;

#pragma mark- 竖屏、横屏模式设置
/** 屏幕是否支持旋转方向，默认UIInterfaceOrientationMaskPortrait，注意：在刘海屏，UIInterfaceOrientationMaskPortraitUpsideDown属性慎用！ */
@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientations;

#pragma mark- 仅弹窗模式属性
/** 底部蒙层背景颜色，默认黑色 */
@property (nonatomic, strong) UIColor *alertBlurViewColor;
/** 底部蒙层背景透明度，默认0.5 */
@property (nonatomic, assign) CGFloat alertBlurViewAlpha;
/** contentView背景颜色，默认白色 */
@property (nonatomic, strong) UIColor *alertContentViewColor;
/** contentView背景透明度，默认1.0 ，即不透明*/
@property (nonatomic, assign) CGFloat alertContentViewAlpha;
/** contentView的四个圆角值，顺序为左上，左下，右下，右上，需要填充4个值，不足4个值则无效，如果值<=0则为直角 */
@property (nonatomic, copy) NSArray<NSNumber *> *alertCornerRadiusArray;
/** 标题栏背景颜色 */
@property (nonatomic, strong) UIColor *alertTitleBarColor;
/** 标题栏是否隐藏，默认NO */
@property (nonatomic, assign) BOOL alertBarIsHidden;
/** 标题栏标题，内容、字体、大小、颜色 */
@property (nonatomic, copy) NSAttributedString *alertTitle;
/** 标题栏右侧关闭按钮图片设置*/
@property (nonatomic, strong) UIImage *alertCloseImage;
/** 标题栏右侧关闭按钮是否显示，默认NO*/
@property (nonatomic, assign) BOOL alertCloseItemIsHidden;

/** 构建标题栏的frame，view布局或布局发生变化时调用，不实现则按默认处理，实现时仅有height生效 */
@property (nonatomic, copy) PNSBuildFrameBlock alertTitleBarFrameBlock;
/** 构建标题栏标题的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) PNSBuildFrameBlock alertTitleFrameBlock;
/** 构建标题栏右侧关闭按钮的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) PNSBuildFrameBlock alertCloseItemFrameBlock;

#pragma mark- 导航栏（只对全屏模式有效）
/**授权页显示中，导航栏是否隐藏，默认NO*/
@property (nonatomic, assign) BOOL navIsHidden;
/**授权页push到其他页面后，导航栏是否隐藏，默认NO*/
@property (nonatomic, assign) BOOL navIsHiddenAfterLoginVCDisappear;
/**是否需要中断返回,如果设置为YES，则点击左上角返回按钮的时候默认页面不消失，同时透出状态码700010，需要自己调用TXCommonHandler cancelLoginVCAnimated方法隐藏页面，默认为NO*/
@property (nonatomic, assign) BOOL suspendDisMissVC;
/** 导航栏主题色 */
@property (nonatomic, strong) UIColor *navColor;
/** 导航栏标题，内容、字体、大小、颜色 */
@property (nonatomic, copy) NSAttributedString *navTitle;
/** 导航栏返回图片 */
@property (nonatomic, strong) UIImage *navBackImage;
/** 是否隐藏授权页导航栏返回按钮，默认不隐藏 */
@property (nonatomic, assign) BOOL hideNavBackItem;
/** 导航栏右侧自定义控件，可以在创建该VIEW的时候添加手势操作，或者创建按钮或其他赋值给VIEW */
@property (nonatomic, strong) UIView *navMoreView;

/** 构建导航栏返回按钮的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) PNSBuildFrameBlock navBackButtonFrameBlock;
/** 构建导航栏标题的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) PNSBuildFrameBlock navTitleFrameBlock;
/** 构建导航栏右侧more view的frame，view布局或布局发生变化时调用，不实现则按默认处理，边界 CGRectGetMinX(frame) >= (superViewSizeViewSize / 0.3) && CGRectGetWidth(frame) <= (superViewSize.width / 3.0) */
@property (nonatomic, copy) PNSBuildFrameBlock navMoreViewFrameBlock;

#pragma mark- 全屏、弹窗模式共同属性

#pragma mark- 授权页动画相关
/** 授权页弹出方向，默认PNSPresentationDirectionBottom，该属性只对自带动画起效，不影响自定义动画 */
@property (nonatomic, assign) PNSPresentationDirection presentDirection;
/** 授权页显示和消失动画时间，默认为0.25s，<= 0 时关闭动画，该属性只对自带动画起效，不影响自定义动画 **/
@property (nonatomic, assign) CGFloat animationDuration;

/** 授权页显示动画（弹窗 & 全屏），不设置或设置为nil默认使用自带动画，SDK内部会主动更改动画的一些属性（包括：removedOnCompletion = NO、fillMode = kCAFillModeForwards 及 delegate） **/
@property (nonatomic, strong, nullable) CAAnimation *entryAnimation;
/** 授权页消失动画（弹窗 & 全屏），不设置或设置为nil默认使用自带动画，SDK内部会主动更改动画的一些属性（包括：removedOnCompletion = NO、fillMode = kCAFillModeForwards 及 delegate） **/
@property (nonatomic, strong, nullable) CAAnimation *exitAnimation;

/** 授权页显示时的背景动画（仅弹窗），不设置或设置为nil默认使用自带动画，SDK内部会主动更改动画的一些属性（包括：removedOnCompletion = NO、fillMode = kCAFillModeForwards 及 delegate） **/
@property (nonatomic, strong, nullable) CAAnimation *bgEntryAnimation;
/** 授权页消失时的背景动画（仅弹窗），不设置或设置为nil默认使用自带动画，SDK内部会主动更改动画的一些属性（包括：removedOnCompletion = NO、fillMode = kCAFillModeForwards 及 delegate） **/
@property (nonatomic, strong, nullable) CAAnimation *bgExitAnimation;

#pragma mark- 状态栏
/** 状态栏是否隐藏，默认NO */
@property (nonatomic, assign) BOOL prefersStatusBarHidden;
/** 状态栏主题风格，默认UIStatusBarStyleDefault */
@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;

#pragma mark- 背景
/** 授权页背景色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 授权页背景图片 */
@property (nonatomic, strong) UIImage *backgroundImage;
/** 授权页背景图片view的 content mode，默认为 UIViewContentModeScaleAspectFill */
@property (nonatomic, assign) UIViewContentMode backgroundImageContentMode;

#pragma mark- logo图片
/** logo图片设置 */
@property (nonatomic, strong) UIImage *logoImage;
/** logo是否隐藏，默认NO */
@property (nonatomic, assign) BOOL logoIsHidden;

/** 构建logo的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) PNSBuildFrameBlock logoFrameBlock;
/** logo的宽设置 */
@property (nonatomic, assign) CGFloat logoWidth DEPRECATED_MSG_ATTRIBUTE("Please use logoFrameBlock instead");
/** logo的高设置 */
@property (nonatomic, assign) CGFloat logoHeight DEPRECATED_MSG_ATTRIBUTE("Please use logoFrameBlock instead");
/** logo相对导航栏底部或标题栏底部的Y轴距离 */
@property (nonatomic, assign) CGFloat logoTopOffetY DEPRECATED_MSG_ATTRIBUTE("Please use logoFrameBlock instead");

#pragma mark- slogan
/** slogan文案，内容、字体、大小、颜色 */
@property (nonatomic, copy) NSAttributedString *sloganText;
/** slogan是否隐藏，默认NO */
@property (nonatomic, assign) BOOL sloganIsHidden;

/** 构建slogan的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) PNSBuildFrameBlock sloganFrameBlock;
/** slogan相对导航栏底部或标题栏底部的Y轴距离 */
@property (nonatomic, assign) CGFloat sloganTopOffetY DEPRECATED_MSG_ATTRIBUTE("Please use sloganFrameBlock instead");

#pragma mark- 号码
/** 号码颜色设置 */
@property (nonatomic, strong) UIColor *numberColor;
/** 号码字体大小设置，大小小于16则不生效 */
@property (nonatomic, strong) UIFont *numberFont;

/**
 *  构建号码的frame，view布局或布局发生变化时调用，只有x、y生效，不实现则按默认处理，
 *  注：设置不能超出父视图 content view
 */
@property (nonatomic, copy) PNSBuildFrameBlock numberFrameBlock;
/**
 *  号码相对导航栏底部或标题栏底部的Y轴距离，不设置则按默认处理
 *  注：设置超出父视图 content view 时不生效
 */
@property (nonatomic, assign) CGFloat numberTopOffetY DEPRECATED_MSG_ATTRIBUTE("Please use numberFrameBlock instead");
/**
 *  号码相对屏幕中线的X轴偏移距离，不设置则按默认处理，默认为0水平居中
 *  注：设置不能超出父视图 content view
 */
@property (nonatomic, assign) CGFloat numberOffetX DEPRECATED_MSG_ATTRIBUTE("Please use numberFrameBlock instead");

#pragma mark- 登录
/** 登陆按钮文案，内容、字体、大小、颜色*/
@property (nonatomic, strong) NSAttributedString *loginBtnText;
/** 登录按钮背景图片组，默认高度50.0pt，@[激活状态的图片,失效状态的图片,高亮状态的图片] */
@property (nonatomic, strong) NSArray<UIImage *> *loginBtnBgImgs;
/**
 *  是否自动隐藏点击登录按钮之后授权页上转圈的 loading, 默认为YES，在获取登录Token成功后自动隐藏
 *  如果设置为 NO，需要自己手动调用 [[TXCommonHandler sharedInstance] hideLoginLoading] 隐藏
 */
@property (nonatomic, assign) BOOL autoHideLoginLoading;
/**
 *  构建登录按钮的frame，view布局或布局发生变化时调用，不实现则按默认处理
 *  注：不能超出父视图 content view，height不能小于20，width不能小于父视图宽度的一半
 */
@property (nonatomic, copy) PNSBuildFrameBlock loginBtnFrameBlock;
/**
 *  登录按钮相对导航栏底部或标题栏底部的Y轴距离，不设置则按默认处理
 *  注：设置超出父视图 content view 时不生效
 */
@property (nonatomic, assign) CGFloat loginBtnTopOffetY DEPRECATED_MSG_ATTRIBUTE("Please use loginBtnFrameBlock instead");
/** 登录按钮高度，小于20.0pt不生效，不设置则按默认处理 */
@property (nonatomic, assign) CGFloat loginBtnHeight DEPRECATED_MSG_ATTRIBUTE("Please use loginBtnFrameBlock instead");
/** 登录按钮相对content view的左右边距，按钮宽度必须大于等于屏幕的一半，不设置则按默认处理 */
@property (nonatomic, assign) CGFloat loginBtnLRPadding DEPRECATED_MSG_ATTRIBUTE("Please use loginBtnFrameBlock instead");

#pragma mark- 协议
/** checkBox图片组，[uncheckedImg,checkedImg]*/
@property (nonatomic, copy) NSArray<UIImage *> *checkBoxImages;
/** checkBox图片距离控件边框的填充，默认为 UIEdgeInsetsZero，确保控件大小减去内填充大小为资源图片大小情况下，图片才不会变形 **/
@property (nonatomic, assign) UIEdgeInsets checkBoxImageEdgeInsets;
/** checkBox是否勾选，默认NO */
@property (nonatomic, assign) BOOL checkBoxIsChecked;
/** checkBox是否隐藏，默认NO */
@property (nonatomic, assign) BOOL checkBoxIsHidden;
/** checkBox大小，高宽一样，必须大于0 */
@property (nonatomic, assign) CGFloat checkBoxWH;
/** checkBox是否和协议内容垂直居中，默认NO，即顶部对齐 */
@property (nonatomic, assign) BOOL checkBoxVerticalCenter;

/** 协议1，[协议名称,协议Url]，注：三个协议名称不能相同 */
@property (nonatomic, copy) NSArray<NSString *> *privacyOne;
/** 协议2，[协议名称,协议Url]，注：三个协议名称不能相同 */
@property (nonatomic, copy) NSArray<NSString *> *privacyTwo;
/** 协议3，[协议名称,协议Url]，注：三个协议名称不能相同 */
@property (nonatomic, copy) NSArray<NSString *> *privacyThree;
/** 协议名称之间连接字符串数组，默认 ["和","、","、"] ，即第一个为"和"，其他为"、"，按顺序读取，为空则取默认 */
@property (nonatomic, copy) NSArray<NSString *> *privacyConectTexts;
/** 协议内容颜色数组，[非点击文案颜色，点击文案颜色] */
@property (nonatomic, copy) NSArray<UIColor *> *privacyColors;
/** 运营商协议内容颜色 ，优先级最高，如果privacyOperatorColors不设置，则取privacyColors中的点击文案颜色，privacyColors不设置，则是默认色*/
@property (nonatomic, strong) UIColor *privacyOperatorColor;
/** 协议1内容颜色，优先级最高，如果privacyOneColors不设置，则取privacyColors中的点击文案颜色，privacyColors不设置，则是默认色*/
@property (nonatomic, strong) UIColor *privacyOneColor;
/** 协议2内容颜色，优先级最高，如果privacyTwoColors不设置，则取privacyColors中的点击文案颜色，privacyColors不设置，则是默认色*/
@property (nonatomic, strong) UIColor *privacyTwoColor;
/** 协议3内容颜色，优先级最高，如果privacyThreeColors不设置，则取privacyColors中的点击文案颜色，privacyColors不设置，则是默认色*/
@property (nonatomic, strong) UIColor *privacyThreeColor;
/** 协议文案支持居中、居左、居右设置，默认居左 */
@property (nonatomic, assign) NSTextAlignment privacyAlignment;
/** 协议整体文案，前缀部分文案 */
@property (nonatomic, copy) NSString *privacyPreText;
/** 协议整体文案，后缀部分文案 */
@property (nonatomic, copy) NSString *privacySufText;
/** 运营商协议名称前缀文案，仅支持 <([《（【『 */
@property (nonatomic, copy) NSString *privacyOperatorPreText;
/** 运营商协议名称后缀文案，仅支持 >)]》）】』*/
@property (nonatomic, copy) NSString *privacyOperatorSufText;
/** 运营商协议指定显示顺序，默认0，即第1个协议显示，最大值可为3，即第4个协议显示*/
@property (nonatomic, assign) NSInteger privacyOperatorIndex;
/** 协议整体文案字体大小，小于12.0不生效 */
@property (nonatomic, strong) UIFont *privacyFont;
/** checkBox是否扩大按钮可交互范围至"协议前缀部分文案(默认:我已阅读并同意)"区域，默认NO */
@property (nonatomic, assign) BOOL expandAuthPageCheckedScope;

/**
 *  构建协议整体（包括checkBox）的frame，view布局或布局发生变化时调用，不实现则按默认处理
 *  如果设置的width小于checkBox的宽则不生效，最小x、y为0，最大width、height为父试图宽高
 *  最终会根据设置进来的width对协议文本进行自适应，得到的size是协议控件的最终大小
 */
@property (nonatomic, copy) PNSBuildFrameBlock privacyFrameBlock;
/**
 *  未同意协议时点击登录按钮，协议整体文案的动画效果，不设置或设置为nil默认没有动画，SDK内部会主动更改动画的一些属性（包括：removedOnCompletion = NO、fillMode = kCAFillModeRemoved 及 delegate）
 */
@property (nonatomic, strong, nullable) CAAnimation *privacyAnimation;
/** 协议整体相对屏幕底部的Y轴距离，与其他有区别！！不能小于0 */
@property (nonatomic, assign) CGFloat privacyBottomOffetY DEPRECATED_MSG_ATTRIBUTE("Please use privacyFrameBlock instead");
/** 协议整体（包括checkBox）相对content view的左右边距，当协议整体宽度小于（content view宽度-2*左右边距）且居中模式，则左右边距设置无效，不能小于0 */
@property (nonatomic, assign) CGFloat privacyLRPadding DEPRECATED_MSG_ATTRIBUTE("Please use privacyFrameBlock instead");

#pragma mark- 切换到其他方式
/** changeBtn标题，内容、字体、大小、颜色 */
@property (nonatomic, copy) NSAttributedString *changeBtnTitle;
/** changeBtn是否隐藏，默认NO*/
@property (nonatomic, assign) BOOL changeBtnIsHidden;

/** 构建changeBtn的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) PNSBuildFrameBlock changeBtnFrameBlock;
/** changeBtn相对导航栏底部或标题栏底部的Y轴距离 */
@property (nonatomic, assign) CGFloat changeBtnTopOffetY DEPRECATED_MSG_ATTRIBUTE("Please use changeBtnFrameBlock instead");

#pragma mark- 协议详情页
/** 协议详情页容器是否自定义，默认NO，若为YES，则根据 PNSCodeLoginControllerClickProtocol 返回码获取协议点击详情信息 */
@property (nonatomic, assign) BOOL privacyVCIsCustomized;
/** 导航栏背景颜色设置 */
@property (nonatomic, strong) UIColor *privacyNavColor;
/** 导航栏标题字体、大小 */
@property (nonatomic, strong) UIFont *privacyNavTitleFont;
/** 导航栏标题颜色 */
@property (nonatomic, strong) UIColor *privacyNavTitleColor;
/** 导航栏返回图片 */
@property (nonatomic, strong) UIImage *privacyNavBackImage;

#pragma mark- 其他自定义控件添加及布局

/**
 * 自定义控件添加，注意：自定义视图的创建初始化和添加到父视图，都需要在主线程！！
 * @param  superCustomView 父视图
 */
@property (nonatomic, copy) void(^customViewBlock)(UIView *superCustomView);

/**
 *  每次授权页布局完成时会调用该block，可以在该block实现里面可设置自定义添加控件的frame
 *  @param  screenSize 屏幕的size
 *  @param  contentViewFrame content view的frame，
 *  @param  navFrame 导航栏的frame，仅全屏时有效
 *  @param  titleBarFrame 标题栏的frame，仅弹窗时有效
 *  @param  logoFrame logo图片的frame
 *  @param  sloganFrame slogan的frame
 *  @param  numberFrame 号码栏的frame
 *  @param  loginFrame 登录按钮的frame
 *  @param  changeBtnFrame 切换到其他方式按钮的frame
 *  @param  privacyFrame 协议整体（包括checkBox）的frame
 */
@property (nonatomic, copy) void(^customViewLayoutBlock)(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame);

#pragma mark - 二次隐私协议弹窗设置
/** 二次隐私协议弹窗是否需要显示, 默认NO */
@property (nonatomic, assign) BOOL privacyAlertIsNeedShow;
/** 二次隐私协议弹窗点击按钮是否需要执行登陆，默认YES */
@property (nonatomic, assign) BOOL privacyAlertIsNeedAutoLogin;
/** 二次隐私协议弹窗显示自定义动画，默认从下往上位移动画 */
@property (nonatomic, strong, nullable) CAAnimation *privacyAlertEntryAnimation;
/** 二次隐私协议弹窗隐藏自定义动画，默认从上往下位移动画 */
@property (nonatomic, strong, nullable) CAAnimation *privacyAlertExitAnimation;
/** 二次隐私协议弹窗的四个圆角值，顺序为左上，左下，右下，右上，需要填充4个值，不足4个值则无效，如果值<=0则为直角 ，默认0*/
@property (nonatomic, copy) NSArray<NSNumber *> *privacyAlertCornerRadiusArray;
/** 二次隐私协议弹窗背景颜色，默认为白色 */
@property (nonatomic, strong) UIColor *privacyAlertBackgroundColor;
/** 二次隐私协议弹窗透明度，默认不透明1.0 ，设置范围0.3~1.0之间 */
@property (nonatomic, assign) CGFloat privacyAlertAlpha;
/** 二次隐私协议弹窗标题文字内容，默认"请阅读并同意以下条款" */
@property (nonatomic, copy) NSString *privacyAlertTitleContent;
/** 二次隐私协议弹窗标题文字大小，最小12，默认12 */
@property (nonatomic, strong) UIFont *privacyAlertTitleFont;
/** 二次隐私协议弹窗标题文字颜色，默认黑色 */
@property (nonatomic, strong) UIColor *privacyAlertTitleColor;
/** 二次隐私协议弹窗标题背景颜色，默认白色*/
@property (nonatomic, strong) UIColor *privacyAlertTitleBackgroundColor;
/** 二次隐私协议弹窗标题位置，默认居中*/
@property (nonatomic, assign) NSTextAlignment privacyAlertTitleAlignment;
/** 二次隐私协议弹窗协议内容文字大小，最小12，默认12 */
@property (nonatomic, strong) UIFont *privacyAlertContentFont;
/** 二次隐私协议弹窗协议内容背景颜色，默认白色 */
@property (nonatomic, strong) UIColor *privacyAlertContentBackgroundColor;
/** 二次隐私协议弹窗协议内容颜色数组，[非点击文案颜色，点击文案颜色],默认[0x999999,0x1890FF] */
@property (nonatomic, copy) NSArray<UIColor *> *privacyAlertContentColors;
/** 二次隐私协议弹窗协议运营商协议内容颜色，优先级最高，如果privacyAlertOperatorColors不设置，则取privacyAlertContentColors中的点击文案颜色，privacyAlertContentColors不设置，则是默认色*/
@property (nonatomic, strong) UIColor *privacyAlertOperatorColor;
/** 二次隐私协议弹窗协议协议1内容颜色 ，优先级最高，如果privacyAlertOneColors不设置，则取privacyAlertContentColors中的点击文案颜色，privacyAlertContentColors不设置，则是默认色*/
@property (nonatomic, strong) UIColor *privacyAlertOneColor;
/** 二次隐私协议弹窗协议协议2内容颜色 ，优先级最高，如果privacyAlertTwoColors不设置，则取privacyAlertContentColors中的点击文案颜色，privacyAlertContentColors不设置，则是默认色*/
@property (nonatomic, strong) UIColor *privacyAlertTwoColor;
/** 二次隐私协议弹窗协议协议3内容颜色 ，优先级最高，如果privacyAlertThreeColors不设置，则取privacyAlertContentColors中的点击文案颜色，privacyAlertContentColors不设置，则是默认色*/
@property (nonatomic, strong) UIColor *privacyAlertThreeColor;
/** 二次隐私协议弹窗协议文案支持居中、居左、居右设置，默认居左 */
@property (nonatomic, assign) NSTextAlignment privacyAlertContentAlignment;

/** 二次隐私协议弹窗协议整体文案，前缀部分文案 ,如果不赋值，默认使用privacyPreText*/
@property (nonatomic, copy) NSString *privacyAlertPreText;
/** 二次隐私协议弹窗协议整体文案，后缀部分文案 如果不赋值，默认使用privacySufText*/
@property (nonatomic, copy) NSString *privacyAlertSufText;

/** 二次隐私协议弹窗按钮文字内容 默认“同意”*/
@property (nonatomic, copy) NSString *privacyAlertBtnContent;
/** 二次隐私协议弹窗按钮按钮背景图片 ,默认高度50.0pt，@[激活状态的图片,高亮状态的图片] */
@property (nonatomic, copy) NSArray<UIImage *> *privacyAlertBtnBackgroundImages;
/** 二次隐私协议弹窗按钮文字颜色，默认黑色, @[激活状态的颜色,高亮状态的颜色] */
@property (nonatomic, copy) NSArray<UIColor *> *privacyAlertButtonTextColors;
/** 二次隐私协议弹窗按钮文字大小，最小10，默认18*/
@property (nonatomic, strong) UIFont *privacyAlertButtonFont;
/** 二次隐私协议弹窗关闭按钮是否显示，默认显示 */
@property (nonatomic, assign) BOOL privacyAlertCloseButtonIsNeedShow;
/** 二次隐私协议弹窗右侧关闭按钮图片设置，默认内置的X图片*/
@property (nonatomic, strong) UIImage *privacyAlertCloseButtonImage;
/** 二次隐私协议弹窗背景蒙层是否显示 ,默认YES*/
@property (nonatomic, assign) BOOL privacyAlertMaskIsNeedShow;
/** 二次隐私协议弹窗点击背景蒙层是否关闭弹窗 ,默认YES*/
@property (nonatomic, assign) BOOL tapPrivacyAlertMaskCloseAlert;
/** 二次隐私协议弹窗蒙版背景颜色，默认黑色 */
@property (nonatomic, strong) UIColor *privacyAlertMaskColor;
/** 二次隐私协议弹窗蒙版透明度 设置范围0.3~1.0之间 ，默认0.5*/
@property (nonatomic, assign) CGFloat privacyAlertMaskAlpha;
/** 二次隐私协议弹窗蒙版显示动画，默认渐显动画 */
@property (nonatomic, strong) CAAnimation *privacyAlertMaskEntryAnimation;
/** 二次隐私协议弹窗蒙版消失动画，默认渐隐动画 */
@property (nonatomic, strong) CAAnimation *privacyAlertMaskExitAnimation;
/** 二次隐私协议弹窗尺寸设置,不能超出父视图 content view，height不能小于50，width不能小于0，默认屏幕居中，宽为屏幕的宽度减掉80，高为200 */
@property (nonatomic, copy) PNSBuildFrameBlock privacyAlertFrameBlock;
/** 二次隐私协议弹窗标题尺寸，默认x=0，y=0，width=弹窗宽度，最小宽度为100，height=根据文本计算的高度，最小高度为15，不能超出父视图 */
@property (nonatomic, copy) PNSBuildFrameBlock privacyAlertTitleFrameBlock;
/** 二次隐私协议弹窗内容尺寸，默认为从标题顶部位置开始，最终会根据设置进来的width对协议文本进行自适应，得到的size是协议控件的最终大小。不能超出父视图 */
@property (nonatomic, copy) PNSBuildFrameBlock privacyAlertPrivacyContentFrameBlock;
/** 二次隐私协议弹窗确认按钮尺寸,默认为父视图的宽度一半,居中显示。高度默认50, */
@property (nonatomic, copy) PNSBuildFrameBlock privacyAlertButtonFrameBlock;
/** 二次隐私协议弹窗右侧关闭按钮尺寸，默认宽高44，居弹窗右侧15，居弹窗顶部0*/
@property (nonatomic, copy) PNSBuildFrameBlock privacyAlertCloseFrameBlock;

/**
 * 二次授权页弹窗自定义控件添加，注意：自定义视图的创建初始化和添加到父视图，都需要在主线程！！
 * @param  superCustomView 父视图
 */
@property (nonatomic, copy) void(^privacyAlertCustomViewBlock)(UIView *superPrivacyAlertCustomView);

/**
 *  二次授权页弹窗布局完成时会调用该block，可以在该block实现里面可设置自定义添加控件的frame
 *  @param  privacyAlertFrame 二次授权页弹窗frame
 *  @param  privacyAlertTitleFrame 二次授权页弹窗标题frame
 *  @param  privacyAlertPrivacyContentFrame 二次授权页弹窗协议内容frame
 *  @param  privacyAlertButtonFrame 二次授权页弹窗确认按钮frame
 *  @param  privacyAlertCloseFrame 二次授权页弹窗右上角关闭按钮frame
 */
@property (nonatomic, copy) void(^privacyAlertCustomViewLayoutBlock)(CGRect privacyAlertFrame, CGRect privacyAlertTitleFrame, CGRect privacyAlertPrivacyContentFrame, CGRect privacyAlertButtonFrame, CGRect privacyAlertCloseFrame);

@end

NS_ASSUME_NONNULL_END

