import { MethodCall } from '@ohos/flutter_ohos';
import { AuthUiConfig } from 'numberauth_standard';

// The SDK owns one authorization page. Snapshot display-only values per open;
// the native number, login action, checkbox and operator terms stay SDK-owned.
class AuthDecorationOptions {
  background: string = '';
  logo: string = '';
  close: string = '';
  logoWidth: number = 80;
  logoHeight: number = 80;
  logoTop: number = 80;
  alternateTop: number = 400;
  alternate: string = '';
  color: string = '#777777';
  fontSize: number = 14;
  onExit: (alternate: boolean) => void = () => {};
}

let activeDecoration: AuthDecorationOptions = new AuthDecorationOptions();

function textValue(call: MethodCall, key: string, fallback: string = ''): string {
  const value: ESObject = call.argument(key);
  return typeof value === 'string' ? value : fallback;
}
function numericValue(call: MethodCall, key: string, fallback: number): number {
  const value: ESObject = call.argument(key);
  return typeof value === 'number' && value >= 0 ? value : fallback;
}

export function clearAuthDecoration(): void {
  activeDecoration = new AuthDecorationOptions();
}

export function installAuthDecoration(call: MethodCall, config: AuthUiConfig,
  onExit: (alternate: boolean) => void): void {
  const options: AuthDecorationOptions = new AuthDecorationOptions();
  options.background = textValue(call, 'pageBackgroundPath');
  options.logo = call.argument('logoHidden') === true ? '' : textValue(call, 'logoImgPath');
  options.close = call.argument('navReturnHidden') === true ? '' : textValue(call, 'navReturnImgPath');
  options.logoWidth = numericValue(call, 'logoWidth', 80);
  options.logoHeight = numericValue(call, 'logoHeight', 80);
  options.logoTop = numericValue(call, 'logoOffsetY', 80);
  options.alternateTop = numericValue(call, 'switchOffsetY', 400);
  options.alternate = call.argument('switchAccHidden') === true ? '' : textValue(call, 'switchAccText');
  options.color = textValue(call, 'switchAccTextColor', '#777777');
  options.fontSize = numericValue(call, 'switchAccTextSize', 14);
  options.onExit = onExit;
  activeDecoration = options;
  config.loginPageComponent = wrapBuilder(authDecoration);
}

// Official SDK demo adds children to its RelativeContainer via this builder.
// Keep the background below the SDK controls and exclude it from hit testing.
@Builder
function authDecoration(): void {
  if (activeDecoration.background.length > 0) {
    Image($rawfile('flutter_assets/' + activeDecoration.background))
      .width('100%').height('100%').objectFit(ImageFit.Cover)
      .position({ x: 0, y: 0 }).zIndex(-1)
      .hitTestBehavior(HitTestMode.None)
  }
  if (activeDecoration.logo.length > 0) {
    Image($rawfile('flutter_assets/' + activeDecoration.logo))
      .width(activeDecoration.logoWidth).height(activeDecoration.logoHeight)
      .objectFit(ImageFit.Contain)
      .margin({ top: activeDecoration.logoTop })
      .alignRules({ middle: { anchor: '__container__', align: HorizontalAlign.Center },
        top: { anchor: '__container__', align: VerticalAlign.Top } })
      .hitTestBehavior(HitTestMode.None)
  }
  if (activeDecoration.close.length > 0) {
    Image($rawfile('flutter_assets/' + activeDecoration.close))
      .width(44).height(44).objectFit(ImageFit.Contain)
      .margin({ top: 20, left: 20 }).zIndex(1)
      .alignRules({ left: { anchor: '__container__', align: HorizontalAlign.Start },
        top: { anchor: '__container__', align: VerticalAlign.Top } })
      .accessibilityText('关闭登录')
      .onClick(() => activeDecoration.onExit(false))
  }
  if (activeDecoration.alternate.length > 0) {
    Text(activeDecoration.alternate)
      .fontSize(activeDecoration.fontSize).fontColor(activeDecoration.color)
      .fontWeight(FontWeight.Medium).height(44).padding({ left: 24, right: 24 })
      .margin({ top: activeDecoration.alternateTop - 12 }).zIndex(1)
      .alignRules({ middle: { anchor: '__container__', align: HorizontalAlign.Center },
        top: { anchor: '__container__', align: VerticalAlign.Top } })
      .onClick(() => activeDecoration.onExit(true))
  }
}
