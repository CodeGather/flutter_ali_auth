/// 本机号码校验,一键登录
enum SdkType { auth, login }

/// ScaleType 可选类型
enum ScaleType {
  matrix,
  fitXy,
  fitStart,
  fitCenter,
  fitEnd,
  center,
  centerCrop,
  centerInside,
}

enum Gravity {
  CENTER_HORIZONTAL,
  LEFT,
  RIGHT,
}

enum UIFAG {
  SYSTEM_UI_FLAG_LOW_PROFILE,
  SYSTEM_UI_FLAG_HIDE_NAVIGATION,
  SYSTEM_UI_FLAG_FULLSCREEN,
  SYSTEM_UI_FLAG_LAYOUT_STABLE,
  SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION,
  SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN,
  SYSTEM_UI_FLAG_IMMERSIVE,
  SYSTEM_UI_FLAG_IMMERSIVE_STICKY,
  SYSTEM_UI_FLAG_LIGHT_STATUS_BAR,
  SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR
}

enum PageType {
  ///全屏（竖屏）
  fullPort,

  ///全屏（横屏）
  fullLand,

  ///弹窗（竖屏）
  dialogPort,

  ///"弹窗（横屏）
  dialogLand,

  ///底部弹窗
  dialogBottom,

  ///自定义View
  customView,

  ///自定义View（Xml）
  customXml,

  /// 自定义背景GIF
  customGif,

  /// 自定义背景视频
  customMOV,

  /// 自定义背景图片
  customPIC,
}

class EnumUtils {
  static int formatGravityValue(Gravity? status) {
    switch (status) {
      case Gravity.CENTER_HORIZONTAL:
        return 1;
      case Gravity.LEFT:
        return 3;
      default:
        return 4;
    }
  }

  static int formatUiFagValue(UIFAG? status) {
    switch (status) {
      case UIFAG.SYSTEM_UI_FLAG_LOW_PROFILE:
        return 1;
      case UIFAG.SYSTEM_UI_FLAG_HIDE_NAVIGATION:
        return 2;
      case UIFAG.SYSTEM_UI_FLAG_FULLSCREEN:
        return 4;
      case UIFAG.SYSTEM_UI_FLAG_LAYOUT_STABLE:
        return 256;
      case UIFAG.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION:
        return 512;
      case UIFAG.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN:
        return 1024;
      case UIFAG.SYSTEM_UI_FLAG_IMMERSIVE:
        return 2048;
      case UIFAG.SYSTEM_UI_FLAG_IMMERSIVE_STICKY:
        return 4096;
      case UIFAG.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR:
        return 8192;
      default:
        return 16;
    }
  }
}

/// 第三方布局实体
class CustomThirdView {
  final int? top;
  final int? right;
  final int? bottom;
  final int? left;
  final int? width;
  final int? height;
  final int? space;
  final int? size;
  final String? color;
  final int? itemWidth;
  final int? itemHeight;
  final List<String>? viewItemName;
  final List<String>? viewItemPath;
  CustomThirdView(
      this.top,
      this.right,
      this.bottom,
      this.left,
      this.width,
      this.height,
      this.space,
      this.size,
      this.color,
      this.itemWidth,
      this.itemHeight,
      this.viewItemName,
      this.viewItemPath);

  factory CustomThirdView.fromJson(Map<String, dynamic> srcJson) =>
      _$CustomThirdViewFromJson(srcJson);
  Map<String, dynamic> toJson() => _$CustomThirdViewToJson(this);
}

/// 第三方布局json转实体
CustomThirdView _$CustomThirdViewFromJson(Map<String, dynamic> json) {
  return CustomThirdView(
      json['top'],
      json['right'],
      json['bottom'],
      json['left'],
      json['width'],
      json['height'],
      json['space'],
      json['size'],
      json['color'],
      json['itemWidth'],
      json['itemHeight'],
      json['viewItemName'],
      json['viewItemPath']);
}

/// 第三方布局实体转json
Map<String, dynamic> _$CustomThirdViewToJson(CustomThirdView instance) =>
    <String, dynamic>{
      'top': instance.top,
      'right': instance.right,
      'bottom': instance.bottom,
      'left': instance.left,
      'width': instance.width,
      'height': instance.height,
      'space': instance.space,
      'size': instance.size,
      'color': instance.color,
      'itemWidth': instance.itemWidth,
      'itemHeight': instance.itemHeight,
      'viewItemName': instance.viewItemName,
      'viewItemPath': instance.viewItemPath,
    };
