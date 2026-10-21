import { MethodCall } from '@ohos/flutter_ohos';
import { AuthUiConfig, OperatorIndex, PageOrientation } from 'numberauth_standard';
import { installAuthDecoration } from './AliAuthDecoration';

function stringArgument(call: MethodCall, key: string): string | undefined {
  const value: ESObject = call.argument(key);
  return typeof value === 'string' ? value : undefined;
}

function nonEmptyStringArgument(call: MethodCall, key: string): string | undefined {
  const value: string | undefined = stringArgument(call, key);
  return value !== undefined && value.length > 0 ? value : undefined;
}

function numberArgument(call: MethodCall, key: string): number | undefined {
  const value: ESObject = call.argument(key);
  return typeof value === 'number' ? value : undefined;
}

function boolArgument(call: MethodCall, key: string): boolean | undefined {
  const value: ESObject = call.argument(key);
  return typeof value === 'boolean' ? value : undefined;
}

function numberArrayArgument(call: MethodCall, key: string): Array<number> | undefined {
  const value: ESObject = call.argument(key);
  if (!Array.isArray(value)) {
    return undefined;
  }
  const source: Array<ESObject> = value as Array<ESObject>;
  const result: Array<number> = [];
  source.forEach((item: ESObject) => {
    if (typeof item === 'number') {
      result.push(item);
    }
  });
  return result;
}

function colorWithAlpha(color: string, alpha: number): string {
  const clampedAlpha: number = Math.max(0, Math.min(1, alpha));
  let alphaHex: string = Math.round(clampedAlpha * 255).toString(16);
  if (alphaHex.length < 2) {
    alphaHex = `0${alphaHex}`;
  }
  alphaHex = alphaHex.toUpperCase();
  if (color.startsWith('#') && color.length === 7) {
    return `#${alphaHex}${color.substring(1)}`;
  }
  if (color.startsWith('#') && color.length === 9) {
    return `#${alphaHex}${color.substring(3)}`;
  }
  return color;
}

function applyWindowBarConfig(call: MethodCall, config: AuthUiConfig): void {
  const statusBarColor: string | undefined = nonEmptyStringArgument(call, 'statusBarColor');
  const navigationBarColor: string | undefined =
    nonEmptyStringArgument(call, 'bottomNavColor') ?? nonEmptyStringArgument(call, 'bottomNavBarColor');
  const lightColor: boolean | undefined = boolArgument(call, 'lightColor');
  if (statusBarColor !== undefined || navigationBarColor !== undefined || lightColor !== undefined) {
    config.windowBarProperties = {
      statusBarColor: statusBarColor,
      navigationBarColor: navigationBarColor,
      isStatusBarLightIcon: lightColor === undefined ? undefined : !lightColor,
      isNavigationBarLightIcon: lightColor === undefined ? undefined : !lightColor
    };
  }
}

function applyNavigationConfig(call: MethodCall, config: AuthUiConfig): void {
  const navColor: string | undefined = nonEmptyStringArgument(call, 'navColor');
  const navTextColor: string | undefined = nonEmptyStringArgument(call, 'navTextColor');
  const navTextSize: number | undefined = numberArgument(call, 'navTextSize');
  if (navColor !== undefined) {
    config.navColor = navColor;
  }
  if (navTextColor !== undefined) {
    config.navFontColor = navTextColor;
  }
  if (navTextSize !== undefined && navTextSize > 0) {
    config.navFontSize = navTextSize;
  }
}

function applyNumberConfig(call: MethodCall, config: AuthUiConfig): void {
  const numberColor: string | undefined = nonEmptyStringArgument(call, 'numberColor');
  const numberSize: number | undefined = numberArgument(call, 'numberSize');
  if (numberColor !== undefined) {
    config.numberFontColor = numberColor;
  }
  if (numberSize !== undefined && numberSize > 0) {
    config.numberFontSize = numberSize;
  }

  const left: number | undefined = numberArgument(call, 'numberFieldOffsetX');
  const top: number | undefined = numberArgument(call, 'numFieldOffsetY');
  const bottom: number | undefined = numberArgument(call, 'numFieldOffsetY_B');
  if ((left !== undefined && left >= 0) || (top !== undefined && top >= 0) ||
    (bottom !== undefined && bottom >= 0)) {
    const margin: Margin = {};
    if (left !== undefined && left >= 0) {
      margin.left = left;
    }
    if (top !== undefined && top >= 0) {
      margin.top = top;
    }
    if (bottom !== undefined && bottom >= 0) {
      margin.bottom = bottom;
    }
    config.numberMargin = margin;
  }
}

function applyLoginButtonConfig(call: MethodCall, config: AuthUiConfig): void {
  const background: string | undefined = nonEmptyStringArgument(call, 'logBtnBackgroundColor');
  const radius: number | undefined = numberArgument(call, 'logBtnCornerRadius');
  if (background !== undefined) {
    config.loginBtnBackGroundColor = background;
    config.privacyCbSelectColor = background;
  }
  if (radius !== undefined && radius >= 0) config.loginBtnBorder = radius;
  config.loginBtnAlignRuleOption = {
    middle: { anchor: '__container__', align: HorizontalAlign.Center },
    top: { anchor: '__container__', align: VerticalAlign.Top }
  };
  const text: string | undefined = stringArgument(call, 'logBtnText');
  const fontSize: number | undefined = numberArgument(call, 'logBtnTextSize');
  const fontColor: string | undefined = nonEmptyStringArgument(call, 'logBtnTextColor');
  const width: number | undefined = numberArgument(call, 'logBtnWidth');
  const height: number | undefined = numberArgument(call, 'logBtnHeight');
  if (text !== undefined) {
    config.loginBtnText = text;
  }
  if (fontSize !== undefined && fontSize > 0) {
    config.loginBtnFontSize = fontSize;
  }
  if (fontColor !== undefined) {
    config.loginBtnFontColor = fontColor;
  }
  if (width !== undefined && width > 0) {
    config.loginBtnWidth = width;
  }
  if (height !== undefined && height > 0) {
    config.loginBtnHeight = height;
  }

  const horizontal: number | undefined = numberArgument(call, 'logBtnMarginLeftAndRight');
  const offsetX: number | undefined = numberArgument(call, 'logBtnOffsetX');
  const top: number | undefined = numberArgument(call, 'logBtnOffsetY');
  const bottom: number | undefined = numberArgument(call, 'logBtnOffsetY_B');
  if ((horizontal !== undefined && horizontal >= 0) || (offsetX !== undefined && offsetX >= 0) ||
    (top !== undefined && top >= 0) || (bottom !== undefined && bottom >= 0)) {
    const margin: Margin = {};
    if (horizontal !== undefined && horizontal >= 0) {
      margin.left = horizontal;
      margin.right = horizontal;
    } else if (offsetX !== undefined && offsetX >= 0) {
      margin.left = offsetX;
    }
    if (top !== undefined && top >= 0) {
      margin.top = top;
    }
    if (bottom !== undefined && bottom >= 0) {
      margin.bottom = bottom;
    }
    config.loginBtnMargin = margin;
  }
}

function applyPrivacyConfig(call: MethodCall, config: AuthUiConfig): void {
  config.privacyCbShape = CheckBoxShape.CIRCLE;
  const checkboxHidden: boolean | undefined = boolArgument(call, 'checkboxHidden');
  const checkboxWidth: number | undefined = numberArgument(call, 'checkBoxWidth');
  const checkboxHeight: number | undefined = numberArgument(call, 'checkBoxHeight');
  if (checkboxHidden === true) {
    config.privacyCbWidth = 0;
    config.privacyCbHeight = 0;
  } else {
    if (checkboxWidth !== undefined && checkboxWidth >= 0) {
      config.privacyCbWidth = checkboxWidth;
    }
    if (checkboxHeight !== undefined && checkboxHeight >= 0) {
      config.privacyCbHeight = checkboxHeight;
    }
  }

  const privacyState: boolean | undefined = boolArgument(call, 'privacyState');
  if (privacyState !== undefined) {
    config.privacyCbIsOn = privacyState;
  }

  const privacyMargin: number | undefined = numberArgument(call, 'privacyMargin');
  const privacyTop: number | undefined = numberArgument(call, 'privacyOffsetY');
  const privacyBottom: number | undefined = numberArgument(call, 'privacyOffsetY_B');
  if ((privacyMargin !== undefined && privacyMargin >= 0) || (privacyTop !== undefined && privacyTop >= 0) ||
    (privacyBottom !== undefined && privacyBottom >= 0)) {
    const margin: Margin = {};
    if (privacyMargin !== undefined && privacyMargin >= 0) {
      margin.left = privacyMargin;
      margin.right = privacyMargin;
    }
    if (privacyTop !== undefined && privacyTop >= 0) {
      margin.top = privacyTop;
    }
    if (privacyBottom !== undefined && privacyBottom >= 0) {
      margin.bottom = privacyBottom;
    }
    config.privacyMargin = margin;
  }

  const privacySize: number | undefined = numberArgument(call, 'privacyTextSize');
  if (privacySize !== undefined && privacySize > 0) {
    config.privacyFontSize = privacySize;
    config.privacySpanBeforeFontSize = privacySize;
    config.privacySpanOneFontSize = privacySize;
    config.privacySpanTwoFontSize = privacySize;
    config.privacySpanThreeFontSize = privacySize;
    config.privacySpanEndFontSize = privacySize;
  }

  const protocolColor: string | undefined =
    nonEmptyStringArgument(call, 'protocolOwnColor') ?? nonEmptyStringArgument(call, 'protocolColor');
  const customColor: string | undefined = nonEmptyStringArgument(call, 'protocolCustomColor');
  if (protocolColor !== undefined) {
    config.privacyFontColor = protocolColor;
    config.privacySpanBeforeFontColor = protocolColor;
    config.privacySpanEndFontColor = protocolColor;
  }

  const oneColor: string | undefined = nonEmptyStringArgument(call, 'protocolOwnOneColor') ?? customColor;
  const twoColor: string | undefined = nonEmptyStringArgument(call, 'protocolOwnTwoColor') ?? customColor;
  if (oneColor !== undefined) {
    config.privacySpanOneFontColor = oneColor;
  }
  if (twoColor !== undefined) {
    config.privacySpanTwoFontColor = twoColor;
  }
  if (customColor !== undefined) {
    config.privacySpanThreeFontColor = customColor;
  }

  const before: string | undefined = stringArgument(call, 'privacyBefore');
  const end: string | undefined = stringArgument(call, 'privacyEnd');
  const vendorPrefix: string | undefined = stringArgument(call, 'vendorPrivacyPrefix');
  const vendorSuffix: string | undefined = stringArgument(call, 'vendorPrivacySuffix');
  if (before !== undefined) {
    config.privacySpanBeforeText = before;
  }
  if (end !== undefined) {
    config.privacySpanEndText = end;
  }
  if (vendorPrefix !== undefined) {
    config.vendorPrivacyPrefix = vendorPrefix;
  }
  if (vendorSuffix !== undefined) {
    config.vendorPrivacySuffix = vendorSuffix;
  }

  const oneName: string | undefined = stringArgument(call, 'protocolOneName');
  const oneUrl: string | undefined = stringArgument(call, 'protocolOneURL');
  const twoName: string | undefined = stringArgument(call, 'protocolTwoName');
  const twoUrl: string | undefined = stringArgument(call, 'protocolTwoURL');
  const threeName: string | undefined = stringArgument(call, 'protocolThreeName');
  const threeUrl: string | undefined = stringArgument(call, 'protocolThreeURL');
  if (oneName !== undefined) {
    config.privacySpanOneText = oneName;
  }
  if (oneUrl !== undefined) {
    config.privacySpanOneUrl = oneUrl;
  }
  if (twoName !== undefined) {
    config.privacySpanTwoText = twoName;
  }
  if (twoUrl !== undefined) {
    config.privacySpanTwoUrl = twoUrl;
  }
  if (threeName !== undefined) {
    config.privacySpanThreeText = threeName;
  }
  if (threeUrl !== undefined) {
    config.privacySpanThreeUrl = threeUrl;
  }

  const operatorIndex: number | undefined = numberArgument(call, 'privacyOperatorIndex');
  if (operatorIndex !== undefined) {
    config.privacyOperatorIndex = operatorIndex === 0 ? OperatorIndex.BEGIN : OperatorIndex.END;
  }

  const hideToast: boolean | undefined = boolArgument(call, 'isHideToast');
  const toastText: string | undefined = stringArgument(call, 'toastText');
  if (hideToast === true) {
    config.privacyCbTipText = '';
  } else if (toastText !== undefined) {
    config.privacyCbTipText = toastText;
  }
}

function applyPageConfig(call: MethodCall, config: AuthUiConfig): boolean {
  const pageType: number = numberArgument(call, 'pageType') ?? 0;
  const isLandscape: boolean = pageType === 1 || pageType === 3;
  const isDialog: boolean = pageType === 2 || pageType === 3 || pageType === 4;
  config.pageScreenOrientation = isLandscape ? PageOrientation.LANDSCAPE : PageOrientation.PORTRAIT;

  const dialogWidth: number | undefined = numberArgument(call, 'dialogWidth');
  const dialogHeight: number | undefined = numberArgument(call, 'dialogHeight');
  if (dialogWidth !== undefined && dialogWidth > 0) {
    config.dialogWidth = dialogWidth;
  }
  if (dialogHeight !== undefined && dialogHeight > 0) {
    config.dialogHeight = dialogHeight;
  }
  const dialogBottom: boolean = boolArgument(call, 'dialogBottom') ?? false;
  config.dialogAlignment = pageType === 4 || dialogBottom ? DialogAlignment.Bottom : DialogAlignment.Center;
  config.dialogAutoCancel = boolArgument(call, 'tapAuthPageMaskClosePage') ?? false;
  return isDialog;
}

function applyPrivacyAlertConfig(call: MethodCall, config: AuthUiConfig): void {
  const needShow: boolean | undefined = boolArgument(call, 'privacyAlertIsNeedShow');
  if (needShow !== undefined) {
    config.needShowPrivacyAlert = needShow;
  }

  const title: string | undefined = stringArgument(call, 'privacyAlertTitleContent');
  const titleColor: string | undefined = nonEmptyStringArgument(call, 'privacyAlertTitleColor');
  const titleSize: number | undefined = numberArgument(call, 'privacyAlertTitleTextSize');
  if (title !== undefined) {
    config.privacyAlertTitleText = title;
  }
  if (titleColor !== undefined) {
    config.privacyAlertTitleFontColor = titleColor;
  }
  if (titleSize !== undefined && titleSize > 0) {
    config.privacyAlertTitleFontSize = titleSize;
  }

  const width: number | undefined = numberArgument(call, 'privacyAlertWidth');
  const height: number | undefined = numberArgument(call, 'privacyAlertHeight');
  const backgroundColor: string | undefined = nonEmptyStringArgument(call, 'privacyAlertBackgroundColor');
  const backgroundAlpha: number = numberArgument(call, 'privacyAlertAlpha') ?? 1;
  if (width !== undefined && width > 0) {
    config.privacyAlertWidth = width;
  }
  if (height !== undefined && height > 0) {
    config.privacyAlertHeight = height;
  }
  if (backgroundColor !== undefined) {
    config.privacyAlertBackgroundColor = colorWithAlpha(backgroundColor, backgroundAlpha);
  }

  const radius: Array<number> | undefined = numberArrayArgument(call, 'privacyAlertCornerRadiusArray');
  if (radius !== undefined && radius.length >= 4) {
    config.privacyAlertBorderRadius = {
      topLeft: radius[0],
      topRight: radius[1],
      bottomRight: radius[2],
      bottomLeft: radius[3]
    };
  }

  config.privacyAlertAutoCancel = boolArgument(call, 'tapPrivacyAlertMaskCloseAlert') ?? true;
  const alignment: number | undefined = numberArgument(call, 'privacyAlertAlignment');
  if (alignment === 0) {
    config.privacyAlertAlignment = DialogAlignment.CenterStart;
  } else if (alignment === 2) {
    config.privacyAlertAlignment = DialogAlignment.CenterEnd;
  } else {
    config.privacyAlertAlignment = DialogAlignment.Center;
  }

  const maskShown: boolean = boolArgument(call, 'privacyAlertMaskIsNeedShow') ?? true;
  const maskColor: string | undefined = nonEmptyStringArgument(call, 'privacyAlertMaskColor');
  const maskAlpha: number = numberArgument(call, 'privacyAlertMaskAlpha') ?? 0.5;
  config.privacyAlertMaskColor = maskShown ? colorWithAlpha(maskColor ?? '#000000', maskAlpha) : '#00000000';

  const buttonText: string | undefined = stringArgument(call, 'privacyAlertBtnText');
  const buttonTextColor: string | undefined = nonEmptyStringArgument(call, 'privacyAlertBtnTextColor');
  const buttonTextSize: number | undefined = numberArgument(call, 'privacyAlertBtnTextSize');
  const buttonWidth: number | undefined = numberArgument(call, 'privacyAlertBtnWidth');
  const buttonHeight: number | undefined = numberArgument(call, 'privacyAlertBtnHeigth');
  if (buttonText !== undefined) {
    config.privacyAlertConfirmBtnText = buttonText;
  }
  if (buttonTextColor !== undefined) {
    config.privacyAlertConfirmBtnFontColor = buttonTextColor;
  }
  if (buttonTextSize !== undefined && buttonTextSize > 0) {
    config.privacyAlertConfirmBtnFontSize = buttonTextSize;
  }
  if (buttonWidth !== undefined && buttonWidth > 0) {
    config.privacyAlertConfirmBtnWidth = buttonWidth;
  }
  if (buttonHeight !== undefined && buttonHeight > 0) {
    config.privacyAlertConfirmBtnHeight = buttonHeight;
  }

  const contentSize: number | undefined = numberArgument(call, 'privacyAlertContentTextSize');
  const contentColor: string | undefined =
    nonEmptyStringArgument(call, 'privacyAlertContentColor') ??
      nonEmptyStringArgument(call, 'privacyAlertContentBaseColor');
  const horizontalMargin: number | undefined = numberArgument(call, 'privacyAlertContentHorizontalMargin');
  const verticalMargin: number | undefined = numberArgument(call, 'privacyAlertContentVerticalMargin');
  if (contentSize !== undefined && contentSize > 0) {
    config.privacyAlertOperatorFontSize = contentSize;
    config.privacyAlertSpanBeforeFontSize = contentSize;
    config.privacyAlertSpanOneFontSize = contentSize;
    config.privacyAlertSpanTwoFontSize = contentSize;
    config.privacyAlertSpanThreeFontSize = contentSize;
    config.privacyAlertSpanEndFontSize = contentSize;
  }
  if (contentColor !== undefined) {
    config.privacyAlertOperatorFontColor = contentColor;
    config.privacyAlertSpanBeforeFontColor = contentColor;
    config.privacyAlertSpanEndFontColor = contentColor;
  }
  if (horizontalMargin !== undefined || verticalMargin !== undefined) {
    config.privacyAlertContentMargin = {
      left: horizontalMargin ?? 0,
      right: horizontalMargin ?? 0,
      top: verticalMargin ?? 0,
      bottom: verticalMargin ?? 0
    };
  }

  const before: string | undefined = stringArgument(call, 'privacyAlertBefore');
  const end: string | undefined = stringArgument(call, 'privacyAlertEnd');
  if (before !== undefined) {
    config.privacyAlertSpanBeforeText = before;
  }
  if (end !== undefined) {
    config.privacyAlertSpanEndText = end;
  }

  const oneName: string | undefined = stringArgument(call, 'protocolOneName');
  const oneUrl: string | undefined = stringArgument(call, 'protocolOneURL');
  const twoName: string | undefined = stringArgument(call, 'protocolTwoName');
  const twoUrl: string | undefined = stringArgument(call, 'protocolTwoURL');
  const threeName: string | undefined = stringArgument(call, 'protocolThreeName');
  const threeUrl: string | undefined = stringArgument(call, 'protocolThreeURL');
  if (oneName !== undefined) {
    config.privacyAlertSpanOneText = oneName;
  }
  if (oneUrl !== undefined) {
    config.privacyAlertSpanOneUrl = oneUrl;
  }
  if (twoName !== undefined) {
    config.privacyAlertSpanTwoText = twoName;
  }
  if (twoUrl !== undefined) {
    config.privacyAlertSpanTwoUrl = twoUrl;
  }
  if (threeName !== undefined) {
    config.privacyAlertSpanThreeText = threeName;
  }
  if (threeUrl !== undefined) {
    config.privacyAlertSpanThreeUrl = threeUrl;
  }

  const oneColor: string | undefined = nonEmptyStringArgument(call, 'privacyAlertOwnOneColor');
  const twoColor: string | undefined = nonEmptyStringArgument(call, 'privacyAlertOwnTwoColor');
  const threeColor: string | undefined = nonEmptyStringArgument(call, 'privacyAlertOwnThreeColor');
  if (oneColor !== undefined) {
    config.privacyAlertSpanOneFontColor = oneColor;
  }
  if (twoColor !== undefined) {
    config.privacyAlertSpanTwoFontColor = twoColor;
  }
  if (threeColor !== undefined) {
    config.privacyAlertSpanThreeFontColor = threeColor;
  }
}

export interface AliAuthUiResult {
  config: AuthUiConfig;
  isDialog: boolean;
}

export function createAliAuthUiConfig(call: MethodCall, onExit?: (alternate: boolean) => void): AliAuthUiResult {
  const config: AuthUiConfig = new AuthUiConfig();
  applyWindowBarConfig(call, config);
  applyNavigationConfig(call, config);
  applyNumberConfig(call, config);
  applyLoginButtonConfig(call, config);
  applyPrivacyConfig(call, config);
  const isDialog: boolean = applyPageConfig(call, config);
  applyPrivacyAlertConfig(call, config);
  if (onExit !== undefined) installAuthDecoration(call, config, onExit);
  return { config: config, isDialog: isDialog };
}
