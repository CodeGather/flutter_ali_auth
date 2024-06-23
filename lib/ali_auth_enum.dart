import 'dart:io';

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

enum ContentMode {
  scaleToFill,
  scaleAspectFit, // contents scaled to fit with fixed aspect. remainder is transparent
  scaleAspectFill, // contents scaled to fill with fixed aspect. some portion of content may be clipped.
  redraw, // redraw on bounds change (calls -setNeedsDisplay)
  center, // contents remain same size. positioned adjusted.
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

enum Gravity { centerHorizntal, left, right }

enum UIFAG {
  systemUiFalgLowProfile,
  systemUiFalgHideNavigation,
  systemUiFalgFullscreen,
  systemUiFalgLayoutStable,
  systemUiFalgLayoutHideNavigtion,
  systemUiFalgLayoutFullscreen,
  systemUiFalgImmersive,
  systemUiFalgImmersiveSticky,
  systemUiFalgLightStatusBar,
  systemUiFalgLightNavigationBar
}

enum PNSPresentationDirection {
  presentationDirectionBottom,
  presentationDirectionRight,
  presentationDirectionTop,
  presentationDirectionLeft,
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
      case Gravity.centerHorizntal:
        return 1;
      case Gravity.left:
        if (Platform.isAndroid) {
          return 3;
        } else {
          return 0;
        }
      case Gravity.right:
        if (Platform.isAndroid) {
          return 5;
        } else {
          return 2;
        }
      default:
        return 4;
    }
  }

  static int formatUiFagValue(UIFAG? status) {
    switch (status) {
      case UIFAG.systemUiFalgLowProfile:
        return 1;
      case UIFAG.systemUiFalgHideNavigation:
        return 2;
      case UIFAG.systemUiFalgFullscreen:
        return 4;
      case UIFAG.systemUiFalgLayoutStable:
        return 256;
      case UIFAG.systemUiFalgLayoutHideNavigtion:
        return 512;
      case UIFAG.systemUiFalgLayoutFullscreen:
        return 1024;
      case UIFAG.systemUiFalgImmersive:
        return 2048;
      case UIFAG.systemUiFalgImmersiveSticky:
        return 4096;
      case UIFAG.systemUiFalgLightStatusBar:
        return 8192;
      default:
        return 16;
    }
  }
}

/// 第三方布局实体
class CustomThirdView {
  late int? top;
  late int? right;
  late int? bottom;
  late int? left;
  late int? width;
  late int? height;
  late int? space;
  late int? size;
  late String? color;
  late int? itemWidth;
  late int? itemHeight;
  late List<String>? viewItemName;
  late List<String>? viewItemPath;
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

///  自定义布局实体
class CustomView {
  late int? top;
  late int? right;
  late int? bottom;
  late int? left;
  late int? width;
  late int? height;
  late String? imgPath;
  late ScaleType? imgScaleType;
  CustomView(this.top, this.right, this.bottom, this.left, this.width,
      this.height, this.imgPath, this.imgScaleType);

  factory CustomView.fromJson(Map<String, dynamic> srcJson) =>
      _$CustomViewFromJson(srcJson);
  Map<String, dynamic> toJson() => _$CustomViewToJson(this);
}

/// 自定义布局json转实体
CustomView _$CustomViewFromJson(Map<String, dynamic> json) {
  return CustomView(json['top'], json['right'], json['bottom'], json['left'],
      json['width'], json['height'], json['imgPath'], json['imgScaleType']);
}

/// 自定义布局实体转json
Map<String, dynamic> _$CustomViewToJson(CustomView instance) =>
    <String, dynamic>{
      'top': instance.top ?? 0,
      'right': instance.right ?? 0,
      'bottom': instance.bottom ?? 0,
      'left': instance.left ?? 0,
      'width': instance.width,
      'height': instance.height,
      'imgPath': instance.imgPath,
      'imgScaleType': (instance.imgScaleType ?? ScaleType.centerCrop).index,
    };
