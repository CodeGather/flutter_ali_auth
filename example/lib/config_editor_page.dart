import 'dart:ui';
import 'package:ali_auth/ali_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 配置模板
class Preset {
  final String name;
  final Map<String, dynamic> config;
  Preset(this.name, this.config);
}

/// 动态参数配置页面
class ConfigEditorPage extends StatefulWidget {
  const ConfigEditorPage({super.key});

  @override
  State<ConfigEditorPage> createState() => _ConfigEditorPageState();
}

class _ConfigEditorPageState extends State<ConfigEditorPage> {
  /// 模板列表（跨页面持久化）
  static final List<Preset> _presets = [];

  late Map<String, dynamic> _config;
  late Map<String, TextEditingController> _controllers;

  Map<String, dynamic> get _defaultConfig => {
    'androidSk': '', 'iosSk': '', 'isDebug': true, 'isDelay': false,
    'pageType': 0,
    'statusBarColor': '#026ED2', 'lightColor': false, 'isStatusBarHidden': false,
    'statusBarUIFlag': 4, 'webViewStatusBarColor': '',
    'navHidden': false, 'navColor': '#026ED2', 'navText': '一键登录插件演示', 'navTextColor': '#000000',
    'navTextSize': 18, 'navReturnImgPath': 'assets/return_btn.png', 'navReturnHidden': false,
    'navReturnImgWidth': 30, 'navReturnImgHeight': 30, 'navReturnScaleType': 4,
    'webNavColor': '#026ED2', 'webNavTextColor': '#ffffff', 'webNavTextSize': 20, 'webNavReturnImgPath': 'assets/return_btn.png',
    'logoImgPath': 'assets/logo.png', 'logoHidden': false, 'logoWidth': 90, 'logoHeight': 90,
    'logoOffsetY': -1, 'logoOffsetY_B': -1, 'logoScaleType': 1,
    'sloganHidden': false, 'sloganText': '思预云欢迎您使用一键登录', 'sloganTextColor': '#ffffff', 'sloganTextSize': 16,
    'sloganOffsetY': -1, 'sloganOffsetY_B': -1,
    'numberColor': '#ffffff', 'numberSize': 28, 'numFieldOffsetY': -1, 'numFieldOffsetY_B': -1,
    'numberFieldOffsetX': 0, 'numberLayoutGravity': 0,
    'logBtnText': '一键登录', 'logBtnTextColor': '#FFF000', 'logBtnTextSize': 16,
    'logBtnWidth': -1, 'logBtnHeight': 51, 'logBtnOffsetY': -1, 'logBtnOffsetY_B': -1,
    'logBtnOffsetX': 0, 'logBtnMarginLeftAndRight': 28, 'logBtnLayoutGravity': 0,
    'logBtnBackgroundPath': 'assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png',
    'loadingImgPath': 'authsdk_waiting_icon', 'logBtnToastHidden': true,
    'switchAccHidden': false, 'switchAccText': '切换到其他方式', 'switchAccTextColor': '#FDFDFD',
    'switchAccTextSize': 16, 'switchOffsetY': -1, 'switchOffsetY_B': -1,
    'isHiddenCustom': false,
    'protocolOneName': '《通达理》', 'protocolOneURL': 'https://tunderly.com',
    'protocolTwoName': '《思预云》', 'protocolTwoURL': 'https://jokui.com',
    'protocolThreeName': '《思预云APP》', 'protocolThreeURL': 'https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002',
    'protocolColor': '#bfbfbf', 'protocolCustomColor': '#026ED2',
    'protocolOwnColor': '', 'protocolOwnOneColor': '', 'protocolOwnTwoColor': '',
    'protocolLayoutGravity': 0, 'privacyState': false, 'protocolGravity': 0,
    'privacyTextSize': 12, 'privacyMargin': 28, 'privacyBefore': '已阅读并同意',
    'privacyEnd': '', 'vendorPrivacyPrefix': '《', 'vendorPrivacySuffix': '》',
    'uncheckedImgPath': 'assets/btn_unchecked.png', 'checkedImgPath': 'assets/btn_checked.png',
    'checkBoxWidth': 18, 'checkBoxHeight': 18,
    'checkboxHidden': false, 'privacyOffsetY': -1, 'privacyOffsetY_B': 28, 'privacyOffsetX': -1,
    'privacyOperatorIndex': 0, 'privacyConectTexts': '和,和,和',
    'dialogWidth': -1, 'dialogHeight': -1, 'dialogBottom': false,
    'dialogOffsetX': 0, 'dialogOffsetY': 0, 'dialogCornerRadiusArray': '10,10,10,10',
    'dialogAlpha': 1.0, 'pageBackgroundRadius': 0, 'tapAuthPageMaskClosePage': false,
    'pageBackgroundPath': 'assets/background_image.jpeg', 'backgroundImageContentMode': 2,
    'backgroundColor': '#000000', 'bottomNavColor': '#FFFFFF', 'bottomNavBarColor': '',
    'screenOrientation': -1, 'fullScreen': false, 'authPageUseDayLight': false,
    'keepAllPageHideNavigationBar': false, 'closeAuthPageReturnBack': false, 'autoQuitPage': false,
    'alertBarIsHidden': false, 'alertTitleBarColor': '', 'alertCloseItemIsHidden': false,
    'alertCloseImagePath': '', 'alertCloseImageX': 0, 'alertCloseImageY': 0,
    'alertCloseImageW': 45, 'alertCloseImageH': 45,
    'alertBlurViewColor': '#000000', 'alertBlurViewAlpha': 0.5, 'presentDirection': 0,
    'privacyAlertIsNeedShow': false, 'privacyAlertIsNeedAutoLogin': true,
    'privacyAlertWidth': -1, 'privacyAlertHeight': -1, 'privacyAlertOffsetX': 40,
    'privacyAlertOffsetY': -1, 'privacyAlertTitleTextSize': 18, 'privacyAlertTitleColor': '',
    'privacyAlertTitleBackgroundColor': '', 'privacyAlertTitleAlignment': 0,
    'privacyAlertTitleOffsetX': 0, 'privacyAlertTitleOffsetY': 20,
    'privacyAlertTitleContent': '请阅读并同意以下条款',
    'privacyAlertContentTextSize': 16, 'privacyAlertContentBackgroundColor': '',
    'privacyAlertContentAlignment': 0, 'privacyAlertContentColor': '',
    'privacyAlertContentBaseColor': '', 'privacyAlertContentHorizontalMargin': 0,
    'privacyAlertContentVerticalMargin': 10, 'privacyAlertProtocolNameUseUnderLine': false,
    'privacyAlertBtnText': '同意并登录', 'privacyAlertBtnTextColor': '', 'privacyAlertBtnTextSize': 18,
    'privacyAlertBtnWidth': -1, 'privacyAlertBtnHeigth': -1, 'privacyAlertBtnBackgroundImgPath': '',
    'privacyAlertBefore': '', 'privacyAlertEnd': '', 'privacyAlertCloseBtnShow': true,
    'privacyAlertCloseImagPath': '', 'privacyAlertCloseScaleType': 0,
    'privacyAlertCloseImgWidth': 0, 'privacyAlertCloseImgHeight': 0,
    'privacyAlertCornerRadiusArray': '10,10,10,10', 'privacyAlertAlpha': 1.0,
    'privacyAlertBackgroundColor': '', 'privacyAlertMaskIsNeedShow': true,
    'privacyAlertMaskAlpha': 0.5, 'privacyAlertMaskColor': '#000000',
    'tapPrivacyAlertMaskCloseAlert': true,
    'privacyAlertOwnOneColor': '', 'privacyAlertOwnTwoColor': '', 'privacyAlertOwnThreeColor': '',
    'privacyAlertOperatorColor': '', 'privacyAlertEntryAnimation': '', 'privacyAlertExitAnimation': '',
    'isHideToast': false, 'toastText': '请先阅读用户协议', 'toastBackground': '#FF000000',
    'toastColor': '#FFFFFFFF', 'toastPadding': 9, 'toastMarginTop': 0, 'toastMarginBottom': 0,
    'toastPositionMode': 2, 'toastDelay': 3,
  };

  @override
  void initState() {
    super.initState();
    _config = _presets.isNotEmpty
        ? Map<String, dynamic>.from(_presets.first.config)
        : Map<String, dynamic>.from(_defaultConfig);
    _controllers = {};
    // 计算动态默认值（基于屏幕尺寸，与主页 getFullPortConfig 一致）
    if (_presets.isEmpty) {
      final screenHeight = (PlatformDispatcher.instance.views.first.physicalSize.height /
          PlatformDispatcher.instance.views.first.devicePixelRatio).floor();
      final dialogHeight = (screenHeight * 0.65).floor() - 50;
      final unit = dialogHeight ~/ 10;
      _config['logoOffsetY'] = unit * 2;
      _config['sloganOffsetY'] = unit * 5;
      _config['numFieldOffsetY'] = unit * 7;
      _config['logBtnOffsetY'] = unit * 8;
      _config['switchOffsetY'] = unit * 9 + 20;
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String key) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController(text: '${_config[key] ?? ''}');
    }
    return _controllers[key]!;
  }

  void _updateValue(String key, dynamic value) {
    setState(() => _config[key] = value);
  }

  // ==================== 通用控件 ====================

  Widget _buildTextField(String key, String label, {String? hint, bool isNumber = false, bool isColor = false, bool isLarge = false}) {
    final isColorField = isColor || key.toLowerCase().contains('color');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: isLarge ? 100 : 130,
            child: Text(label, style: TextStyle(fontSize: isLarge ? 15 : 13, fontWeight: isLarge ? FontWeight.w600 : FontWeight.normal, color: Colors.grey.shade800)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: isLarge ? 44 : 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isColorField ? Colors.blue.shade200 : Colors.grey.shade300),
                color: isColorField ? Colors.blue.shade50 : Colors.white,
              ),
              child: Row(
                children: [
                  if (isColorField && _config[key] is String && '${_config[key]}'.length == 7)
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: _parseColor('${_config[key]}'),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                  Expanded(
                    child: TextField(
                      controller: _getController(key),
                      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                      style: TextStyle(fontSize: isLarge ? 14 : 13, color: Colors.grey.shade900),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: isColorField ? 6 : 10, vertical: isLarge ? 12 : 8),
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      ),
                      onChanged: (v) {
                        if (isNumber) {
                          if (v.contains('.')) {
                            _config[key] = double.tryParse(v) ?? 0;
                          } else {
                            _config[key] = int.tryParse(v) ?? 0;
                          }
                        } else {
                          _config[key] = v;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
      if (h.length == 8) return Color(int.parse(h, radix: 16));
    } catch (_) {}
    return Colors.transparent;
  }

  Widget _buildSwitch(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade800))),
          const Spacer(),
          _buildModernSwitch(_config[key] == true, (v) => _updateValue(key, v)),
        ],
      ),
    );
  }

  Widget _buildModernSwitch(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? Colors.blue : Colors.grey.shade300,
          boxShadow: value
              ? [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 3, offset: const Offset(0, 1))],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(String key, String label, List<T> items, String Function(T) labelFn, {bool isLarge = false}) {
    final currentValue = _config[key] as T;
    final currentLabel = labelFn(currentValue);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          SizedBox(width: isLarge ? 100 : 130, child: Text(label, style: TextStyle(fontSize: isLarge ? 15 : 13, fontWeight: isLarge ? FontWeight.w600 : FontWeight.normal, color: Colors.grey.shade800))),
          const SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              onTap: () => _showPickerSheet(context, key, items, labelFn),
              child: Container(
                height: isLarge ? 44 : 36,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentLabel,
                        style: TextStyle(fontSize: isLarge ? 14 : 13, color: Colors.grey.shade900),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, size: isLarge ? 22 : 18, color: Colors.grey.shade500),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPickerSheet<T>(BuildContext context, String key, List<T> items, String Function(T) labelFn) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.only(top: 40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖拽指示条
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 标题栏
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    Text('请选择', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Text('取消', style: TextStyle(fontSize: 15, color: Colors.blue.shade500)),
                    ),
                  ],
                ),
              ),
              // 选项列表
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final isSelected = _config[key] == items[i];
                    return GestureDetector(
                      onTap: () {
                        _updateValue(key, items[i]);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                          color: isSelected ? Colors.blue.shade50 : Colors.white,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                labelFn(items[i]),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isSelected ? Colors.blue.shade700 : Colors.grey.shade900,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check, size: 20, color: Colors.blue.shade500),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // 底部安全区
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        );
      },
    );
  }

  // ==================== 构建 AliAuthModel ====================

  AliAuthModel _buildModel() {
    final privacyConectTexts = '${_config['privacyConectTexts']}'.split(',');
    return AliAuthModel(
      '${_config['androidSk'] ?? ''}',
      '${_config['iosSk'] ?? ''}',
      isDebug: _config['isDebug'] as bool? ?? true,
      isDelay: _config['isDelay'] as bool? ?? false,
      pageType: PageType.values[_config['pageType'] as int? ?? 0],
      statusBarColor: '${_config['statusBarColor'] ?? ''}'.isEmpty ? null : '${_config['statusBarColor']}',
      lightColor: _config['lightColor'] as bool?,
      isStatusBarHidden: _config['isStatusBarHidden'] as bool?,
      statusBarUIFlag: UIFAG.values[_config['statusBarUIFlag'] as int? ?? 4],
      webViewStatusBarColor: '${_config['webViewStatusBarColor'] ?? ''}'.isEmpty ? null : '${_config['webViewStatusBarColor']}',
      navHidden: _config['navHidden'] as bool?,
      navColor: '${_config['navColor'] ?? ''}'.isEmpty ? null : '${_config['navColor']}',
      navText: '${_config['navText'] ?? ''}'.isEmpty ? null : '${_config['navText']}',
      navTextColor: '${_config['navTextColor'] ?? ''}'.isEmpty ? null : '${_config['navTextColor']}',
      navTextSize: _config['navTextSize'] as int?,
      navReturnImgPath: '${_config['navReturnImgPath'] ?? ''}'.isEmpty ? null : '${_config['navReturnImgPath']}',
      navReturnHidden: _config['navReturnHidden'] as bool?,
      navReturnImgWidth: _config['navReturnImgWidth'] as int?,
      navReturnImgHeight: _config['navReturnImgHeight'] as int?,
      customReturnBtn: null,
      navReturnScaleType: ScaleType.values[_config['navReturnScaleType'] as int? ?? 4],
      webNavColor: '${_config['webNavColor'] ?? ''}'.isEmpty ? null : '${_config['webNavColor']}',
      webNavTextColor: '${_config['webNavTextColor'] ?? ''}'.isEmpty ? null : '${_config['webNavTextColor']}',
      webNavTextSize: _config['webNavTextSize'] as int?,
      webNavReturnImgPath: '${_config['webNavReturnImgPath'] ?? ''}'.isEmpty ? null : '${_config['webNavReturnImgPath']}',
      logoImgPath: '${_config['logoImgPath'] ?? ''}'.isEmpty ? null : '${_config['logoImgPath']}',
      logoHidden: _config['logoHidden'] as bool?,
      logoWidth: _config['logoWidth'] as int?,
      logoHeight: _config['logoHeight'] as int?,
      logoOffsetY: _config['logoOffsetY'] as int?,
      logoOffsetY_B: _config['logoOffsetY_B'] as int?,
      logoScaleType: ScaleType.values[_config['logoScaleType'] as int? ?? 1],
      sloganHidden: _config['sloganHidden'] as bool?,
      sloganText: '${_config['sloganText'] ?? ''}'.isEmpty ? null : '${_config['sloganText']}',
      sloganTextColor: '${_config['sloganTextColor'] ?? ''}'.isEmpty ? null : '${_config['sloganTextColor']}',
      sloganTextSize: _config['sloganTextSize'] as int?,
      sloganOffsetY: _config['sloganOffsetY'] as int?,
      sloganOffsetY_B: _config['sloganOffsetY_B'] as int?,
      numberColor: '${_config['numberColor'] ?? ''}'.isEmpty ? null : '${_config['numberColor']}',
      numberSize: _config['numberSize'] as int?,
      numFieldOffsetY: _config['numFieldOffsetY'] as int?,
      numFieldOffsetY_B: _config['numFieldOffsetY_B'] as int?,
      numberFieldOffsetX: _config['numberFieldOffsetX'] as int?,
      numberLayoutGravity: Gravity.values[_config['numberLayoutGravity'] as int? ?? 0],
      logBtnText: '${_config['logBtnText'] ?? ''}'.isEmpty ? null : '${_config['logBtnText']}',
      logBtnTextColor: '${_config['logBtnTextColor'] ?? ''}'.isEmpty ? null : '${_config['logBtnTextColor']}',
      logBtnTextSize: _config['logBtnTextSize'] as int?,
      logBtnWidth: _config['logBtnWidth'] as int?,
      logBtnHeight: _config['logBtnHeight'] as int?,
      logBtnOffsetY: _config['logBtnOffsetY'] as int?,
      logBtnOffsetY_B: _config['logBtnOffsetY_B'] as int?,
      logBtnOffsetX: _config['logBtnOffsetX'] as int?,
      logBtnMarginLeftAndRight: _config['logBtnMarginLeftAndRight'] as int?,
      logBtnLayoutGravity: Gravity.values[_config['logBtnLayoutGravity'] as int? ?? 0],
      logBtnBackgroundPath: '${_config['logBtnBackgroundPath'] ?? ''}'.isEmpty ? null : '${_config['logBtnBackgroundPath']}',
      loadingImgPath: '${_config['loadingImgPath'] ?? ''}'.isEmpty ? null : '${_config['loadingImgPath']}',
      logBtnToastHidden: _config['logBtnToastHidden'] as bool?,
      switchAccHidden: _config['switchAccHidden'] as bool?,
      switchAccText: '${_config['switchAccText'] ?? ''}'.isEmpty ? null : '${_config['switchAccText']}',
      switchAccTextColor: '${_config['switchAccTextColor'] ?? ''}'.isEmpty ? null : '${_config['switchAccTextColor']}',
      switchAccTextSize: _config['switchAccTextSize'] as int?,
      switchOffsetY: _config['switchOffsetY'] as int?,
      switchOffsetY_B: _config['switchOffsetY_B'] as int?,
      protocolOneName: '${_config['protocolOneName'] ?? ''}'.isEmpty ? null : '${_config['protocolOneName']}',
      protocolOneURL: '${_config['protocolOneURL'] ?? ''}'.isEmpty ? null : '${_config['protocolOneURL']}',
      protocolTwoName: '${_config['protocolTwoName'] ?? ''}'.isEmpty ? null : '${_config['protocolTwoName']}',
      protocolTwoURL: '${_config['protocolTwoURL'] ?? ''}'.isEmpty ? null : '${_config['protocolTwoURL']}',
      protocolThreeName: '${_config['protocolThreeName'] ?? ''}'.isEmpty ? null : '${_config['protocolThreeName']}',
      protocolThreeURL: '${_config['protocolThreeURL'] ?? ''}'.isEmpty ? null : '${_config['protocolThreeURL']}',
      protocolColor: '${_config['protocolColor'] ?? ''}'.isEmpty ? null : '${_config['protocolColor']}',
      protocolCustomColor: '${_config['protocolCustomColor'] ?? ''}'.isEmpty ? null : '${_config['protocolCustomColor']}',
      protocolOwnColor: '${_config['protocolOwnColor'] ?? ''}'.isEmpty ? null : '${_config['protocolOwnColor']}',
      protocolOwnOneColor: '${_config['protocolOwnOneColor'] ?? ''}'.isEmpty ? null : '${_config['protocolOwnOneColor']}',
      protocolOwnTwoColor: '${_config['protocolOwnTwoColor'] ?? ''}'.isEmpty ? null : '${_config['protocolOwnTwoColor']}',
      protocolLayoutGravity: Gravity.values[_config['protocolLayoutGravity'] as int? ?? 0],
      privacyState: _config['privacyState'] as bool? ?? false,
      protocolGravity: Gravity.values[_config['protocolGravity'] as int? ?? 0],
      privacyTextSize: _config['privacyTextSize'] as int?,
      privacyMargin: _config['privacyMargin'] as int?,
      privacyBefore: '${_config['privacyBefore'] ?? ''}'.isEmpty ? null : '${_config['privacyBefore']}',
      privacyEnd: '${_config['privacyEnd'] ?? ''}'.isEmpty ? null : '${_config['privacyEnd']}',
      vendorPrivacyPrefix: '${_config['vendorPrivacyPrefix'] ?? ''}'.isEmpty ? null : '${_config['vendorPrivacyPrefix']}',
      vendorPrivacySuffix: '${_config['vendorPrivacySuffix'] ?? ''}'.isEmpty ? null : '${_config['vendorPrivacySuffix']}',
      uncheckedImgPath: '${_config['uncheckedImgPath'] ?? ''}'.isEmpty ? null : '${_config['uncheckedImgPath']}',
      checkedImgPath: '${_config['checkedImgPath'] ?? ''}'.isEmpty ? null : '${_config['checkedImgPath']}',
      checkBoxWidth: _config['checkBoxWidth'] as int?,
      checkBoxHeight: _config['checkBoxHeight'] as int?,
      checkboxHidden: _config['checkboxHidden'] as bool?,
      privacyOffsetY: _config['privacyOffsetY'] as int?,
      privacyOffsetY_B: _config['privacyOffsetY_B'] as int?,
      privacyOffsetX: _config['privacyOffsetX'] as int?,
      privacyOperatorIndex: _config['privacyOperatorIndex'] as int?,
      privacyConectTexts: privacyConectTexts,
      dialogWidth: _config['dialogWidth'] as int?,
      dialogHeight: _config['dialogHeight'] as int?,
      dialogBottom: _config['dialogBottom'] as bool?,
      dialogOffsetX: _config['dialogOffsetX'] as int?,
      dialogOffsetY: _config['dialogOffsetY'] as int?,
      dialogCornerRadiusArray: '${_config['dialogCornerRadiusArray'] ?? ''}'.split(',').map((e) => int.tryParse(e) ?? 10).toList(),
      dialogAlpha: (_config['dialogAlpha'] as num?)?.toDouble(),
      pageBackgroundRadius: _config['pageBackgroundRadius'] as int?,
      tapAuthPageMaskClosePage: _config['tapAuthPageMaskClosePage'] as bool? ?? false,
      pageBackgroundPath: '${_config['pageBackgroundPath'] ?? ''}'.isEmpty ? null : '${_config['pageBackgroundPath']}',
      backgroundImageContentMode: ContentMode.values[_config['backgroundImageContentMode'] as int? ?? 2],
      backgroundColor: '${_config['backgroundColor'] ?? ''}'.isEmpty ? null : '${_config['backgroundColor']}',
      bottomNavColor: '${_config['bottomNavColor'] ?? ''}'.isEmpty ? null : '${_config['bottomNavColor']}',
      bottomNavBarColor: '${_config['bottomNavBarColor'] ?? ''}'.isEmpty ? null : '${_config['bottomNavBarColor']}',
      screenOrientation: _config['screenOrientation'] as int?,
      fullScreen: _config['fullScreen'] as bool? ?? false,
      authPageUseDayLight: _config['authPageUseDayLight'] as bool? ?? false,
      keepAllPageHideNavigationBar: _config['keepAllPageHideNavigationBar'] as bool? ?? false,
      closeAuthPageReturnBack: _config['closeAuthPageReturnBack'] as bool? ?? false,
      autoQuitPage: _config['autoQuitPage'] as bool? ?? true,
      isHiddenCustom: _config['isHiddenCustom'] as bool?,
      customThirdView: null,
      alertBarIsHidden: _config['alertBarIsHidden'] as bool?,
      alertTitleBarColor: '${_config['alertTitleBarColor'] ?? ''}'.isEmpty ? null : '${_config['alertTitleBarColor']}',
      alertCloseItemIsHidden: _config['alertCloseItemIsHidden'] as bool?,
      alertCloseImagePath: '${_config['alertCloseImagePath'] ?? ''}'.isEmpty ? null : '${_config['alertCloseImagePath']}',
      alertCloseImageX: _config['alertCloseImageX'] as int?,
      alertCloseImageY: _config['alertCloseImageY'] as int?,
      alertCloseImageW: _config['alertCloseImageW'] as int?,
      alertCloseImageH: _config['alertCloseImageH'] as int?,
      alertBlurViewColor: '${_config['alertBlurViewColor'] ?? ''}'.isEmpty ? null : '${_config['alertBlurViewColor']}',
      alertBlurViewAlpha: (_config['alertBlurViewAlpha'] as num?)?.toDouble(),
      presentDirection: PNSPresentationDirection.values[_config['presentDirection'] as int? ?? 0],
      privacyAlertIsNeedShow: _config['privacyAlertIsNeedShow'] as bool? ?? false,
      privacyAlertIsNeedAutoLogin: _config['privacyAlertIsNeedAutoLogin'] as bool? ?? true,
      privacyAlertWidth: _config['privacyAlertWidth'] as int?,
      privacyAlertHeight: _config['privacyAlertHeight'] as int?,
      privacyAlertOffsetX: _config['privacyAlertOffsetX'] as int?,
      privacyAlertOffsetY: _config['privacyAlertOffsetY'] as int?,
      privacyAlertTitleTextSize: _config['privacyAlertTitleTextSize'] as int?,
      privacyAlertTitleColor: '${_config['privacyAlertTitleColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertTitleColor']}',
      privacyAlertTitleBackgroundColor: '${_config['privacyAlertTitleBackgroundColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertTitleBackgroundColor']}',
      privacyAlertTitleAlignment: Gravity.values[_config['privacyAlertTitleAlignment'] as int? ?? 0],
      privacyAlertTitleOffsetX: _config['privacyAlertTitleOffsetX'] as int?,
      privacyAlertTitleOffsetY: _config['privacyAlertTitleOffsetY'] as int?,
      privacyAlertTitleContent: '${_config['privacyAlertTitleContent'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertTitleContent']}',
      privacyAlertContentTextSize: _config['privacyAlertContentTextSize'] as int?,
      privacyAlertContentBackgroundColor: '${_config['privacyAlertContentBackgroundColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertContentBackgroundColor']}',
      privacyAlertContentAlignment: Gravity.values[_config['privacyAlertContentAlignment'] as int? ?? 0],
      privacyAlertContentColor: '${_config['privacyAlertContentColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertContentColor']}',
      privacyAlertContentBaseColor: '${_config['privacyAlertContentBaseColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertContentBaseColor']}',
      privacyAlertContentHorizontalMargin: _config['privacyAlertContentHorizontalMargin'] as int?,
      privacyAlertContentVerticalMargin: _config['privacyAlertContentVerticalMargin'] as int?,
      privacyAlertProtocolNameUseUnderLine: _config['privacyAlertProtocolNameUseUnderLine'] as bool? ?? false,
      privacyAlertBtnText: '${_config['privacyAlertBtnText'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertBtnText']}',
      privacyAlertBtnTextColor: '${_config['privacyAlertBtnTextColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertBtnTextColor']}',
      privacyAlertBtnTextSize: _config['privacyAlertBtnTextSize'] as int?,
      privacyAlertBtnWidth: _config['privacyAlertBtnWidth'] as int?,
      privacyAlertBtnHeigth: _config['privacyAlertBtnHeigth'] as int?,
      privacyAlertBtnBackgroundImgPath: '${_config['privacyAlertBtnBackgroundImgPath'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertBtnBackgroundImgPath']}',
      privacyAlertBefore: '${_config['privacyAlertBefore'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertBefore']}',
      privacyAlertEnd: '${_config['privacyAlertEnd'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertEnd']}',
      privacyAlertCloseBtnShow: _config['privacyAlertCloseBtnShow'] as bool? ?? true,
      privacyAlertCloseImagPath: '${_config['privacyAlertCloseImagPath'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertCloseImagPath']}',
      privacyAlertCloseScaleType: ScaleType.values[_config['privacyAlertCloseScaleType'] as int? ?? 0],
      privacyAlertCloseImgWidth: _config['privacyAlertCloseImgWidth'] as int?,
      privacyAlertCloseImgHeight: _config['privacyAlertCloseImgHeight'] as int?,
      privacyAlertCornerRadiusArray: '${_config['privacyAlertCornerRadiusArray'] ?? ''}'.split(',').map((e) => int.tryParse(e) ?? 10).toList(),
      privacyAlertAlpha: (_config['privacyAlertAlpha'] as num?)?.toDouble() ?? 1.0,
      privacyAlertBackgroundColor: '${_config['privacyAlertBackgroundColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertBackgroundColor']}',
      privacyAlertMaskIsNeedShow: _config['privacyAlertMaskIsNeedShow'] as bool? ?? true,
      privacyAlertMaskAlpha: (_config['privacyAlertMaskAlpha'] as num?)?.toDouble() ?? 0.5,
      privacyAlertMaskColor: '${_config['privacyAlertMaskColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertMaskColor']}',
      tapPrivacyAlertMaskCloseAlert: _config['tapPrivacyAlertMaskCloseAlert'] as bool? ?? true,
      privacyAlertOwnOneColor: '${_config['privacyAlertOwnOneColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertOwnOneColor']}',
      privacyAlertOwnTwoColor: '${_config['privacyAlertOwnTwoColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertOwnTwoColor']}',
      privacyAlertOwnThreeColor: '${_config['privacyAlertOwnThreeColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertOwnThreeColor']}',
      privacyAlertOperatorColor: '${_config['privacyAlertOperatorColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertOperatorColor']}',
      isHideToast: _config['isHideToast'] as bool? ?? false,
      toastText: '${_config['toastText'] ?? ''}'.isEmpty ? null : '${_config['toastText']}',
      toastBackground: '${_config['toastBackground'] ?? ''}'.isEmpty ? null : '${_config['toastBackground']}',
      toastColor: '${_config['toastColor'] ?? ''}'.isEmpty ? null : '${_config['toastColor']}',
      toastPadding: _config['toastPadding'] as int?,
      toastMarginTop: _config['toastMarginTop'] as int?,
      toastMarginBottom: _config['toastMarginBottom'] as int?,
      toastPositionMode: _toastModeString(_config['toastPositionMode'] as int?),
      toastDelay: _config['toastDelay'] as int?,
    );
  }

  String _toastModeString(int? v) {
    switch (v) { case 0: return 'top'; case 1: return 'center'; default: return 'bottom'; }
  }

  // ==================== 模板管理 & 应用 ====================

  void _saveAsPreset() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('保存为模板', style: TextStyle(fontSize: 17)),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '请输入模板名称',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  _presets.insert(0, Preset(name, Map<String, dynamic>.from(_config)));
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('模板「$name」已保存'),
                    backgroundColor: Colors.blue.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _loadPreset(Preset preset) {
    setState(() {
      for (final c in _controllers.values) { c.dispose(); }
      _controllers.clear();
      _config = Map<String, dynamic>.from(preset.config);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已加载模板「${preset.name}」'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _deletePreset(int index) {
    final name = _presets[index].name;
    setState(() => _presets.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('模板「$name」已删除'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// 加载模板并立即一键登录（不依赖 setState 异步）
  void _loadAndApply(Preset preset) {
    for (final c in _controllers.values) { c.dispose(); }
    _controllers.clear();
    _config = Map<String, dynamic>.from(preset.config);
    _doLogin();
  }

  void _doLogin() {
    if ('${_config['androidSk'] ?? ''}'.isEmpty && '${_config['iosSk'] ?? ''}'.isEmpty) {
      _showSnack('请先填写 Android SK 或 iOS SK', Colors.red.shade400);
      return;
    }
    final isDelay = _config['isDelay'] == true;
    final model = _buildModel();
    if (kDebugMode) {
      debugPrint('===== ${isDelay ? '延迟' : '一键'}登录 =====');
      model.toJson().forEach((k, v) => debugPrint('  $k: $v'));
    }
    _initSdkWithListener(model, isDelay: isDelay);
  }

  /// 设置监听并调用 initSdk
  void _initSdkWithListener(AliAuthModel model, {bool isDelay = false}) {
    AliAuth.loginListen(
      onEvent: (event) {
        if (kDebugMode) debugPrint('onEvent: $event');
      },
      isOnlyOne: true,
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      AliAuth.initSdk(model).catchError((e) {
        _showSnack('初始化失败: $e', Colors.red.shade400);
      });
      // 延迟模式下 initSdk 后也需要调用 login 才能弹出授权页
      if (isDelay) {
        Future.delayed(const Duration(milliseconds: 800), () {
          AliAuth.login().catchError((e) {
            _showSnack('登录失败: $e', Colors.red.shade400);
          });
        });
      }
    });
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _resetConfig() {
    for (final c in _controllers.values) { c.dispose(); }
    _controllers.clear();
    setState(() {
      _config = Map<String, dynamic>.from(_defaultConfig);
    });
  }

  // ==================== 构建页面 ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 动态参数配置'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined, color: Colors.white),
            tooltip: '保存为模板',
            onPressed: _saveAsPreset,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: '重置默认值',
            onPressed: _resetConfig,
          ),
        ],
      ),
      body: Column(
        children: [
          // 顶部固定
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                _buildTextField('androidSk', 'Android SK', hint: '请输入 Android 密钥', isLarge: true),
                const SizedBox(height: 6),
                _buildTextField('iosSk', 'iOS SK', hint: '请输入 iOS 密钥', isLarge: true),
              ],
            ),
          ),
          // 滚动分组
          Expanded(
            child: ListView(
              children: [
                // 模板列表
                if (_presets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bookmark, size: 16, color: Colors.orange.shade700),
                            const SizedBox(width: 6),
                            Text('我的模板', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(_presets.length, (i) {
                          final preset = _presets[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.orange.shade100),
                            ),
                            child: ListTile(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              leading: Icon(Icons.description_outlined, size: 20, color: Colors.orange.shade400),
                              title: Text(preset.name, style: const TextStyle(fontSize: 14)),
                              subtitle: Text('${preset.config.length} 项参数', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.play_arrow, size: 20, color: Colors.blue.shade400),
                                    tooltip: '加载并一键登录',
                                    onPressed: () => _loadAndApply(preset),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade300),
                                    tooltip: '删除模板',
                                    onPressed: () => _deletePreset(i),
                                  ),
                                ],
                              ),
                              onTap: () => _loadPreset(preset),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                _buildSection('基本设置', 4, [
                  _buildDropdown<int>('pageType', '页面类型',
                    [0,1,2,3,4,5,6,7,8,9], (i) => ['全屏竖屏','全屏横屏','弹窗竖屏','弹窗横屏','底部弹窗','自定义View','自定义Xml','自定义GIF','自定义视频','自定义图片'][i]),
                  _buildSwitch('isDebug', '调试模式'),
                  _buildSwitch('isDelay', '延迟登录'),
                  _buildSwitch('autoQuitPage', '自动关闭页面'),
                ]),
                _buildSection('一、状态栏', 5, [
                  _buildTextField('statusBarColor', '状态栏颜色', hint: '#026ED2'),
                  _buildSwitch('lightColor', '浅色文字'),
                  _buildSwitch('isStatusBarHidden', '隐藏状态栏'),
                  _buildDropdown<int>('statusBarUIFlag', '状态栏UIFlag', [0,1,2,3,4,5,6,7,8,9],
                    (i) => ['LowProfile','HideNavigation','Fullscreen','LayoutStable','LayoutHideNav','LayoutFullscreen','Immersive','ImmersiveSticky','LightStatusBar','LightNavigationBar'][i]),
                  _buildTextField('webViewStatusBarColor', '协议页状态栏颜色', hint: '#026ED2'),
                ]),
                _buildSection('二、导航栏', 14, [
                  _buildSwitch('navHidden', '隐藏导航栏'),
                  _buildTextField('navColor', '导航栏颜色', hint: '#026ED2'),
                  _buildTextField('navText', '标题文字'),
                  _buildTextField('navTextColor', '标题颜色', hint: '#000000'),
                  _buildTextField('navTextSize', '标题字号', isNumber: true),
                  _buildTextField('navReturnImgPath', '返回按钮图片', hint: 'assets/return_btn.png'),
                  _buildSwitch('navReturnHidden', '隐藏返回按钮'),
                  _buildTextField('navReturnImgWidth', '返回按钮宽度', isNumber: true),
                  _buildTextField('navReturnImgHeight', '返回按钮高度', isNumber: true),
                  _buildDropdown<int>('navReturnScaleType', '返回按钮缩放', [0,1,2,3,4,5,6,7],
                    (i) => ['Matrix','FitXY','FitStart','FitCenter','FitEnd','Center','CenterCrop','CenterInside'][i]),
                  _buildTextField('webNavColor', '协议页导航栏颜色', hint: '#FFFFFF'),
                  _buildTextField('webNavTextColor', '协议页标题颜色', hint: '#000000'),
                  _buildTextField('webNavTextSize', '协议页标题字号', isNumber: true),
                  _buildTextField('webNavReturnImgPath', '协议页返回按钮', hint: 'assets/return_btn.png'),
                ]),
                _buildSection('三、Logo区', 8, [
                  _buildTextField('logoImgPath', 'Logo图片路径', hint: 'assets/logo.png'),
                  _buildSwitch('logoHidden', '隐藏Logo'),
                  _buildTextField('logoWidth', 'Logo宽度', isNumber: true),
                  _buildTextField('logoHeight', 'Logo高度', isNumber: true),
                  _buildTextField('logoOffsetY', '距顶部偏移', isNumber: true),
                  _buildTextField('logoOffsetY_B', '距底部偏移', isNumber: true),
                  _buildDropdown<int>('logoScaleType', '缩放模式', [0,1,2,3,4,5,6,7],
                    (i) => ['Matrix','FitXY','FitStart','FitCenter','FitEnd','Center','CenterCrop','CenterInside'][i]),
                ]),
                _buildSection('四、Slogan区', 6, [
                  _buildSwitch('sloganHidden', '隐藏Slogan'),
                  _buildTextField('sloganText', 'Slogan文字'),
                  _buildTextField('sloganTextColor', '文字颜色', hint: '#ffffff'),
                  _buildTextField('sloganTextSize', '文字大小', isNumber: true),
                  _buildTextField('sloganOffsetY', '距顶部偏移', isNumber: true),
                  _buildTextField('sloganOffsetY_B', '距底部偏移', isNumber: true),
                ]),
                _buildSection('五、掩码栏', 6, [
                  _buildTextField('numberColor', '手机号颜色', hint: '#ffffff'),
                  _buildTextField('numberSize', '手机号字号', isNumber: true),
                  _buildTextField('numFieldOffsetY', '距顶部偏移', isNumber: true),
                  _buildTextField('numFieldOffsetY_B', '距底部偏移', isNumber: true),
                  _buildTextField('numberFieldOffsetX', 'X轴偏移', isNumber: true),
                  _buildDropdown<int>('numberLayoutGravity', '对齐方式', [0,1,2], (i) => ['居中','左对齐','右对齐'][i]),
                ]),
                _buildSection('六、登录按钮', 13, [
                  _buildTextField('logBtnText', '按钮文字'),
                  _buildTextField('logBtnTextColor', '文字颜色', hint: '#FFF000'),
                  _buildTextField('logBtnTextSize', '文字大小', isNumber: true),
                  _buildTextField('logBtnWidth', '按钮宽度', isNumber: true),
                  _buildTextField('logBtnHeight', '按钮高度', isNumber: true),
                  _buildTextField('logBtnOffsetY', '距顶部偏移', isNumber: true),
                  _buildTextField('logBtnOffsetY_B', '距底部偏移', isNumber: true),
                  _buildTextField('logBtnOffsetX', 'X轴偏移', isNumber: true),
                  _buildTextField('logBtnMarginLeftAndRight', '左右边距', isNumber: true),
                  _buildDropdown<int>('logBtnLayoutGravity', '对齐方式', [0,1,2], (i) => ['居中','左对齐','右对齐'][i]),
                  _buildTextField('logBtnBackgroundPath', '背景图路径', hint: '逗号分隔三态'),
                  _buildTextField('loadingImgPath', 'Loading图片路径'),
                  _buildSwitch('logBtnToastHidden', '隐藏默认Toast'),
                ]),
                _buildSection('七、切换按钮', 6, [
                  _buildSwitch('switchAccHidden', '隐藏切换按钮'),
                  _buildTextField('switchAccText', '切换文字'),
                  _buildTextField('switchAccTextColor', '文字颜色', hint: '#FDFDFD'),
                  _buildTextField('switchAccTextSize', '文字大小', isNumber: true),
                  _buildTextField('switchOffsetY', '距顶部偏移', isNumber: true),
                  _buildTextField('switchOffsetY_B', '距底部偏移', isNumber: true),
                ]),
                _buildSection('九、协议栏', 20, [
                  _buildTextField('protocolOneName', '协议1名称', hint: '《用户协议》'),
                  _buildTextField('protocolOneURL', '协议1URL'),
                  _buildTextField('protocolTwoName', '协议2名称'),
                  _buildTextField('protocolTwoURL', '协议2URL'),
                  _buildTextField('protocolThreeName', '协议3名称'),
                  _buildTextField('protocolThreeURL', '协议3URL'),
                  _buildTextField('protocolColor', '基础文字颜色', hint: '#bfbfbf'),
                  _buildTextField('protocolCustomColor', '协议链接颜色', hint: '#026ED2'),
                  _buildTextField('protocolOwnColor', '运营商协议颜色'),
                  _buildTextField('protocolOwnOneColor', '协议1颜色'),
                  _buildTextField('protocolOwnTwoColor', '协议2颜色'),
                  _buildDropdown<int>('protocolLayoutGravity', '对齐方式', [0,1,2], (i) => ['居中','左对齐','右对齐'][i]),
                  _buildSwitch('privacyState', '默认勾选协议'),
                  _buildDropdown<int>('protocolGravity', '协议栏对齐', [0,1,2], (i) => ['居中','左对齐','右对齐'][i]),
                  _buildTextField('privacyTextSize', '协议文字大小', isNumber: true),
                  _buildTextField('privacyMargin', '左右边距', isNumber: true),
                  _buildTextField('privacyBefore', '前置文案', hint: '我已阅读并同意'),
                  _buildTextField('privacyEnd', '后置文案'),
                  _buildTextField('vendorPrivacyPrefix', '运营商前缀', hint: '《'),
                  _buildTextField('vendorPrivacySuffix', '运营商后缀', hint: '》'),
                  _buildTextField('uncheckedImgPath', '未勾选图标'),
                  _buildTextField('checkedImgPath', '已勾选图标'),
                  _buildTextField('checkBoxWidth', '复选框宽度', isNumber: true),
                  _buildTextField('checkBoxHeight', '复选框高度', isNumber: true),
                  _buildSwitch('checkboxHidden', '隐藏复选框'),
                  _buildTextField('privacyOffsetY', '协议距顶部偏移', isNumber: true),
                  _buildTextField('privacyOffsetY_B', '协议距底部偏移', isNumber: true),
                  _buildTextField('privacyOffsetX', '协议X偏移', isNumber: true),
                  _buildTextField('privacyOperatorIndex', '运营商索引', isNumber: true),
                  _buildTextField('privacyConectTexts', '协议连接符', hint: '逗号分隔'),
                ]),
                _buildSection('十、弹窗设置', 9, [
                  _buildTextField('dialogWidth', '弹窗宽度', isNumber: true),
                  _buildTextField('dialogHeight', '弹窗高度', isNumber: true),
                  _buildSwitch('dialogBottom', '底部弹窗'),
                  _buildTextField('dialogOffsetX', 'X偏移', isNumber: true),
                  _buildTextField('dialogOffsetY', 'Y偏移', isNumber: true),
                  _buildTextField('dialogCornerRadiusArray', '圆角', hint: '左上,右上,右下,左下'),
                  _buildTextField('dialogAlpha', '蒙层透明度', isNumber: true),
                  _buildTextField('pageBackgroundRadius', '背景圆角', isNumber: true),
                  _buildSwitch('tapAuthPageMaskClosePage', '点击蒙层关闭'),
                ]),
                _buildSection('十一、全屏属性', 10, [
                  _buildTextField('pageBackgroundPath', '背景路径', hint: '支持图片/GIF/视频'),
                  _buildDropdown<int>('backgroundImageContentMode', '背景内容模式', [0,1,2,3,4,5,6,7,8,9,10,11,12],
                    (i) => ['ScaleToFill','ScaleAspectFit','ScaleAspectFill','Redraw','Center','Top','Bottom','Left','Right','TopLeft','TopRight','BottomLeft','BottomRight'][i]),
                  _buildTextField('backgroundColor', '背景色', hint: '#000000'),
                  _buildTextField('bottomNavColor', '底部导航颜色'),
                  _buildTextField('bottomNavBarColor', '虚拟导航栏颜色'),
                  _buildTextField('screenOrientation', '屏幕方向', isNumber: true),
                  _buildSwitch('fullScreen', '全屏适配'),
                  _buildSwitch('authPageUseDayLight', '跟随深色模式'),
                  _buildSwitch('keepAllPageHideNavigationBar', '隐藏底部导航栏'),
                  _buildSwitch('closeAuthPageReturnBack', '禁用返回键'),
                ]),
                _buildSection('十二、iOS弹窗', 11, [
                  _buildSwitch('alertBarIsHidden', '隐藏Bar'),
                  _buildTextField('alertTitleBarColor', 'Bar背景色', hint: '#FFFFFF'),
                  _buildSwitch('alertCloseItemIsHidden', '隐藏关闭按钮'),
                  _buildTextField('alertCloseImagePath', '关闭按钮图片'),
                  _buildTextField('alertCloseImageX', '关闭按钮X', isNumber: true),
                  _buildTextField('alertCloseImageY', '关闭按钮Y', isNumber: true),
                  _buildTextField('alertCloseImageW', '关闭按钮宽度', isNumber: true),
                  _buildTextField('alertCloseImageH', '关闭按钮高度', isNumber: true),
                  _buildTextField('alertBlurViewColor', '蒙层颜色', hint: '#000000'),
                  _buildTextField('alertBlurViewAlpha', '蒙层透明度', isNumber: true),
                  _buildDropdown<int>('presentDirection', '弹窗方向', [0,1,2,3], (i) => ['底部','右侧','顶部','左侧'][i]),
                ]),
                _buildSection('十三、二次隐私弹窗', 25, [
                  _buildSwitch('privacyAlertIsNeedShow', '启用二次弹窗'),
                  _buildSwitch('privacyAlertIsNeedAutoLogin', '自动登录'),
                  _buildTextField('privacyAlertTitleContent', '标题文字'),
                  _buildTextField('privacyAlertTitleTextSize', '标题字号', isNumber: true),
                  _buildTextField('privacyAlertTitleColor', '标题颜色'),
                  _buildTextField('privacyAlertTitleBackgroundColor', '标题背景色'),
                  _buildDropdown<int>('privacyAlertTitleAlignment', '标题对齐', [0,1,2], (i) => ['居中','左对齐','右对齐'][i]),
                  _buildTextField('privacyAlertTitleOffsetX', '标题X偏移', isNumber: true),
                  _buildTextField('privacyAlertTitleOffsetY', '标题Y偏移', isNumber: true),
                  _buildTextField('privacyAlertContentTextSize', '内容字号', isNumber: true),
                  _buildTextField('privacyAlertContentColor', '内容颜色'),
                  _buildTextField('privacyAlertContentBaseColor', '基础文字颜色'),
                  _buildTextField('privacyAlertContentBackgroundColor', '内容背景色'),
                  _buildTextField('privacyAlertContentHorizontalMargin', '内容左右边距', isNumber: true),
                  _buildTextField('privacyAlertContentVerticalMargin', '内容上下间距', isNumber: true),
                  _buildSwitch('privacyAlertProtocolNameUseUnderLine', '协议名称下划线'),
                  _buildTextField('privacyAlertWidth', '弹窗宽度', isNumber: true),
                  _buildTextField('privacyAlertHeight', '弹窗高度', isNumber: true),
                  _buildTextField('privacyAlertOffsetX', '弹窗X偏移', isNumber: true),
                  _buildTextField('privacyAlertOffsetY', '弹窗Y偏移', isNumber: true),
                  _buildTextField('privacyAlertCornerRadiusArray', '圆角', hint: '左上,右上,右下,左下'),
                  _buildTextField('privacyAlertAlpha', '弹窗透明度', isNumber: true),
                  _buildTextField('privacyAlertBackgroundColor', '弹窗背景色'),
                  _buildTextField('privacyAlertBefore', '前置文案'),
                  _buildTextField('privacyAlertEnd', '后置文案'),
                  _buildSwitch('privacyAlertMaskIsNeedShow', '显示蒙层'),
                  _buildTextField('privacyAlertMaskAlpha', '蒙层透明度', isNumber: true),
                  _buildTextField('privacyAlertMaskColor', '蒙层颜色'),
                  _buildSwitch('tapPrivacyAlertMaskCloseAlert', '点击蒙层关闭'),
                  _buildTextField('privacyAlertBtnText', '按钮文字'),
                  _buildTextField('privacyAlertBtnTextColor', '按钮文字颜色'),
                  _buildTextField('privacyAlertBtnTextSize', '按钮文字大小', isNumber: true),
                  _buildTextField('privacyAlertBtnWidth', '按钮宽度', isNumber: true),
                  _buildTextField('privacyAlertBtnHeigth', '按钮高度', isNumber: true),
                  _buildTextField('privacyAlertBtnBackgroundImgPath', '按钮背景图'),
                  _buildSwitch('privacyAlertCloseBtnShow', '显示关闭按钮'),
                  _buildTextField('privacyAlertCloseImagPath', '关闭按钮图片'),
                  _buildTextField('privacyAlertCloseImgWidth', '关闭按钮宽度', isNumber: true),
                  _buildTextField('privacyAlertCloseImgHeight', '关闭按钮高度', isNumber: true),
                  _buildTextField('privacyAlertOwnOneColor', '协议1颜色'),
                  _buildTextField('privacyAlertOwnTwoColor', '协议2颜色'),
                  _buildTextField('privacyAlertOwnThreeColor', '协议3颜色'),
                  _buildTextField('privacyAlertOperatorColor', '运营商协议颜色'),
                ]),
                _buildSection('十四、Toast设置', 9, [
                  _buildSwitch('isHideToast', '隐藏Toast'),
                  _buildTextField('toastText', '提示文字'),
                  _buildTextField('toastBackground', '背景色', hint: '#FF000000'),
                  _buildTextField('toastColor', '文字颜色', hint: '#FFFFFFFF'),
                  _buildTextField('toastPadding', '内边距', isNumber: true),
                  _buildTextField('toastMarginTop', '距顶部距离', isNumber: true),
                  _buildTextField('toastMarginBottom', '距底部距离', isNumber: true),
                  _buildDropdown<int>('toastPositionMode', '显示位置', [0,1,2], (i) => ['顶部','居中','底部'][i]),
                  _buildTextField('toastDelay', '显示时长(秒)', isNumber: true),
                ]),
              ],
            ),
          ),
          // 底部按钮
          Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 12 + MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _config['isDelay'] == true ? null : _doLogin,
                  icon: Icon(Icons.play_arrow, size: 20),
                  label: Text('一键登录', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade200,
                    disabledForegroundColor: Colors.grey.shade400,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _config['isDelay'] == true ? _doLogin : null,
                  icon: Icon(Icons.timer_outlined, size: 20),
                  label: Text('延迟登录', style: TextStyle(fontSize: 15)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal.shade700,
                    disabledForegroundColor: Colors.grey.shade300,
                    side: BorderSide(color: _config['isDelay'] == true ? Colors.teal.shade200 : Colors.grey.shade200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, int count, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Row(children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue.shade100, Colors.blue.shade50]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('$count项', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.blue.shade700)),
          ),
        ]),
        children: children,
      ),
    );
  }
}