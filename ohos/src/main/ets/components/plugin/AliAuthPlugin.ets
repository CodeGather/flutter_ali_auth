import common from '@ohos.app.ability.common';
import deviceInfo from '@ohos.deviceInfo';
import connection from '@ohos.net.connection';
import {
  AbilityAware,
  AbilityPluginBinding,
  EventChannel,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult
} from '@ohos/flutter_ohos';
import {
  EventSink,
  StreamHandler
} from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import PhoneNumberAuthHelper, {
  AuthUIControlClickListener,
  PreLoginResultListener,
  TokenResultListener
} from 'numberauth_standard';
import { AliAuthUiResult, createAliAuthUiConfig } from '../config/AliAuthUiConfig';
import { clearAuthDecoration } from '../config/AliAuthDecoration';

const METHOD_CHANNEL_NAME: string = 'ali_auth';
const EVENT_CHANNEL_NAME: string = 'ali_auth/event';
// The delivered archive and release notes are 2.0.21. The HAR metadata still identifies itself as 2.0.20.
const SDK_VERSION: string = '2.0.21';
const DEFAULT_TIMEOUT: number = 5000;

interface SdkPayload {
  _code?: ESObject;
  code?: ESObject;
  resultCode?: ESObject;
  _msg?: ESObject;
  msg?: ESObject;
  _token?: ESObject;
  token?: ESObject;
  _carrierFailedResultData?: ESObject;
  carrierFailedResultData?: ESObject;
  isChecked?: ESObject;
  _isChecked?: ESObject;
  name?: ESObject;
  url?: ESObject;
}

function valueAsString(value: ESObject): string {
  if (value === null || value === undefined) {
    return '';
  }
  return String(value);
}

function parsePayload(value: string): SdkPayload | undefined {
  if (value.length === 0 || value === 'null') {
    return undefined;
  }
  try {
    const parsed: ESObject = JSON.parse(value);
    if (parsed === null || parsed === undefined || typeof parsed !== 'object') {
      return undefined;
    }
    return parsed as SdkPayload;
  } catch (error) {
    return undefined;
  }
}

function payloadCode(payload: SdkPayload | undefined, fallback: string): string {
  if (payload === undefined) {
    return fallback;
  }
  const code: string = valueAsString(payload._code ?? payload.code ?? payload.resultCode);
  return code.length > 0 ? code : fallback;
}

function payloadMessage(payload: SdkPayload | undefined): string {
  if (payload === undefined) {
    return '';
  }
  return valueAsString(payload._msg ?? payload.msg);
}

function payloadToken(payload: SdkPayload | undefined): string {
  if (payload === undefined) {
    return '';
  }
  return valueAsString(payload._token ?? payload.token);
}

function payloadChecked(payload: SdkPayload | undefined): boolean | undefined {
  if (payload === undefined) {
    return undefined;
  }
  const checked: ESObject = payload.isChecked ?? payload._isChecked;
  return typeof checked === 'boolean' ? checked : undefined;
}

function errorMessage(error: ESObject): string {
  if (error instanceof Error) {
    return error.message;
  }
  return valueAsString(error);
}

function statusMessage(code: string): string {
  switch (code) {
    case '500000':
      return '参数获取异常！';
    case '500001':
      return '请先对插件进行监听！';
    case '500002':
      return '校验成功，可进行一键登录！';
    case '500003':
      return '该接口为延时登录接口，请先初始化后再次调用该接口！';
    case '500004':
      return `插件启动监听成功, 当前SDK版本: ${SDK_VERSION}`;
    case '500005':
      return 'SDK初始化完成，但一键登录不可用！';
    case '600000':
      return '获取token成功！';
    case '600001':
      return '唤起授权页成功！';
    case '600002':
      return '唤起授权页失败！建议切换到其他登录方式';
    case '600004':
      return '获取运营商配置信息失败！创建工单联系工程师';
    case '600005':
      return '手机终端不安全！切换到其他登录方式';
    case '600006':
      return '终端缺少号码认证所需权限！';
    case '600007':
      return '未检测到sim卡！用户检查 SIM 卡后重试';
    case '600008':
      return '蜂窝网络未开启！用户开启移动网络后重试';
    case '600009':
      return '无法判断运营商! 创建工单联系工程师';
    case '600010':
      return '未知异常！创建工单联系工程师';
    case '600011':
      return '获取token失败！切换到其他登录方式';
    case '600012':
      return '预取号失败！';
    case '600013':
      return '运营商维护升级！该功能不可用';
    case '600014':
      return '该功能已达最大调用次数';
    case '600015':
      return '接口超时！切换到其他登录方式';
    case '600016':
      return '预取号成功！';
    case '600017':
      return 'AppID、Appkey解析失败! 请检查密钥信息';
    case '600018':
      return '请先初始化SDK！';
    case '600021':
      return '点击登录时检测到运营商已切换！用户退出授权页，重新登录';
    case '600023':
      return '加载自定义控件异常！';
    case '600024':
      return '终端环境检查支持认证';
    case '600025':
      return '终端检测参数错误';
    case '600026':
      return '授权页已加载时不允许调用加速或预取号接口';
    case '600037':
      return 'token加密失败';
    case '700000':
      return '用户取消登录';
    case '700001':
      return '用户切换其他登录方式';
    case '700002':
      return '用户点击登录按钮';
    case '700003':
      return '用户勾选协议选项';
    case '700004':
      return '用户点击协议富文本';
    case '700006':
      return '点击一键登录拉起授权页二次弹窗';
    case '700007':
      return '隐私协议二次弹窗关闭';
    case '700008':
      return '点击隐私协议二次弹窗上同意并继续';
    case '700009':
      return '点击隐私协议二次弹窗上的协议富文本文字';
    case '700010':
    case '700011':
      return '用户自行控制取消操作';
    case '700020':
      return '授权页已销毁';
    default:
      return '';
  }
}

/** AliAuthPlugin */
export default class AliAuthPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware {
  private methodChannel: MethodChannel | null = null;
  private eventChannel: EventChannel | null = null;
  private eventSink: EventSink | null = null;
  private abilityContext: common.UIAbilityContext | null = null;
  private helper: PhoneNumberAuthHelper | null = null;
  private tokenListener: AliAuthTokenListener | null = null;
  private initialized: boolean = false;
  private environmentAvailable: boolean = false;
  private isDelay: boolean = false;
  private isChecked: boolean = false;
  private autoQuitPage: boolean = true;
  private sdkGeneration: number = 0;
  private preLoginRequested: boolean = false;

  getUniqueClassName(): string {
    return 'AliAuthPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.methodChannel = new MethodChannel(binding.getBinaryMessenger(), METHOD_CHANNEL_NAME);
    this.methodChannel.setMethodCallHandler(this);
    this.eventChannel = new EventChannel(binding.getBinaryMessenger(), EVENT_CHANNEL_NAME);
    this.eventChannel.setStreamHandler(new AliAuthStreamHandler(this));
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.methodChannel?.setMethodCallHandler(null);
    // EventChannel accepts null at runtime, but the current OHOS Flutter declaration omits `| null`.
    binding.getBinaryMessenger().setMessageHandler(EVENT_CHANNEL_NAME, null);
    this.methodChannel = null;
    this.eventChannel = null;
    this.eventSink = null;
    this.releaseSdk();
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.abilityContext = binding.getAbility().context;
  }

  onDetachedFromAbility(): void {
    this.releaseSdk();
    this.abilityContext = null;
  }

  async onMethodCall(call: MethodCall, result: MethodResult): Promise<void> {
    switch (call.method) {
      case 'getPlatformVersion':
        result.success(deviceInfo.osFullName.length > 0 ? deviceInfo.osFullName : deviceInfo.displayVersion);
        break;
      case 'getSdkVersion':
        result.success(SDK_VERSION);
        break;
      case 'initSdk':
        this.initializeSdk(call, result);
        break;
      case 'login':
        this.login(call, result);
        break;
      case 'quitPage':
        await this.quitPage(result);
        break;
      case 'checkEnvAvailable':
        this.checkEnvironment(result);
        break;
      case 'queryCheckBoxIsChecked':
        this.queryCheckBox(result);
        break;
      case 'getCurrentCarrierName':
        await this.getCurrentCarrierName(result);
        break;
      case 'checkCellularDataEnable':
        result.success(await this.checkCellularDataEnable());
        break;
      case 'setCheckboxIsChecked':
      case 'hideLoading':
      case 'openPage':
      case 'appleLogin':
        result.notImplemented();
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  onEventListen(events: EventSink): void {
    this.eventSink = events;
    this.emitEvent('500004');
  }

  onEventCancel(): void {
    this.eventSink = null;
  }

  onTokenSuccess(generation: number, message: string): void {
    if (!this.isCurrentGeneration(generation)) {
      return;
    }
    const payload: SdkPayload | undefined = parsePayload(message);
    const code: string = payloadCode(payload, '600010');
    const checked: boolean | undefined = payloadChecked(payload);
    if (checked !== undefined) {
      this.isChecked = checked;
    }

    // UI callbacks are delivered through AuthUIControlClickListener to keep their JSON detail.
    if (code.startsWith('700') && code !== '700020') {
      return;
    }

    const shouldPreLogin: boolean = code === '600024';
    if (shouldPreLogin || code === '600016' || code === '600001' || code === '600000') {
      this.environmentAvailable = true;
    }
    const token: string = payloadToken(payload);
    this.emitEvent(code, payloadMessage(payload), token);

    if (shouldPreLogin) {
      this.startPreLogin(generation);
    }

    if (code === '600000' && this.autoQuitPage) {
      const helper: PhoneNumberAuthHelper | null = this.helper;
      helper?.quitLoginPage().catch((error: Error) => {
        if (this.isCurrentGeneration(generation)) {
          this.emitEvent('600010', error.message);
        }
      });
    }
  }

  onTokenFailure(generation: number, value: string): void {
    if (!this.isCurrentGeneration(generation)) {
      return;
    }
    const payload: SdkPayload | undefined = parsePayload(value);
    const code: string = payloadCode(payload, '600010');
    const checked: boolean | undefined = payloadChecked(payload);
    if (checked !== undefined) {
      this.isChecked = checked;
    }
    if (code.startsWith('700') && code !== '700020') {
      return;
    }
    this.emitEvent(code, payloadMessage(payload).length > 0 ? payloadMessage(payload) : value, payloadToken(payload));
  }

  onPreLoginSuccess(generation: number, vendor: string): void {
    if (!this.isCurrentGeneration(generation)) {
      return;
    }
    this.environmentAvailable = true;
    this.emitEvent('600016', '', vendor);
    if (!this.isDelay) {
      this.startLogin(DEFAULT_TIMEOUT, generation);
    }
  }

  onPreLoginFailure(generation: number, vendor: string, value: string): void {
    if (!this.isCurrentGeneration(generation)) {
      return;
    }
    this.preLoginRequested = false;
    const payload: SdkPayload | undefined = parsePayload(value);
    const code: string = payloadCode(payload, '600012');
    this.emitEvent(code, payloadMessage(payload).length > 0 ? payloadMessage(payload) : value, vendor);
    // Pre-login only accelerates the auth page. A failed acceleration does not make the environment unavailable.
    if (!this.isDelay) {
      this.startLogin(DEFAULT_TIMEOUT, generation);
    }
  }

  onUiClick(generation: number, code: string, jsonString: string): void {
    if (!this.isCurrentGeneration(generation)) {
      return;
    }
    const payload: SdkPayload | undefined = parsePayload(jsonString);
    const checked: boolean | undefined = payloadChecked(payload);
    if (checked !== undefined) {
      this.isChecked = checked;
    } else if (this.helper !== null) {
      try {
        this.isChecked = this.helper.queryCheckBoxIsChecked();
      } catch (error) {
      }
    }

    let data: ESObject = '';
    if (payload !== undefined && (payload.name !== undefined || payload.url !== undefined)) {
      const link: Map<string, ESObject> = new Map<string, ESObject>();
      link.set('name', valueAsString(payload.name));
      link.set('url', valueAsString(payload.url));
      data = link;
    } else if (jsonString.length > 0 && jsonString !== 'null' && code !== '700002' && code !== '700003') {
      data = jsonString;
    }
    this.emitEvent(code, '', data);
  }

  private initializeSdk(call: MethodCall, result: MethodResult): void {
    if (this.eventSink === null) {
      result.error('500001', statusMessage('500001'), null);
      return;
    }
    if (this.abilityContext === null) {
      this.emitEvent('500000', 'HarmonyOS Ability Context 获取失败');
      result.error('500000', statusMessage('500000'), null);
      return;
    }

    const secretValue: ESObject = call.argument('ohosSk');
    const secret: string = typeof secretValue === 'string' ? secretValue : '';
    if (secret.length === 0) {
      this.releaseSdk();
      this.emitEvent('500000', 'ohosSk 不能为空');
      result.success(null);
      return;
    }

    try {
      this.releaseSdk();
      const generation: number = this.sdkGeneration;
      const delayValue: ESObject = call.argument('isDelay');
      const checkedValue: ESObject = call.argument('privacyState');
      const autoQuitValue: ESObject = call.argument('autoQuitPage');
      this.isDelay = typeof delayValue === 'boolean' ? delayValue : false;
      this.isChecked = typeof checkedValue === 'boolean' ? checkedValue : false;
      this.autoQuitPage = typeof autoQuitValue === 'boolean' ? autoQuitValue : true;
      this.environmentAvailable = false;
      this.preLoginRequested = false;

      this.tokenListener = new AliAuthTokenListener(this, generation);
      this.helper = PhoneNumberAuthHelper.getInstance(this.abilityContext, this.tokenListener);
      this.helper.setAuthListener(this.tokenListener);
      const uiResult: AliAuthUiResult = createAliAuthUiConfig(call, (alternate: boolean) => {
        if (generation !== this.sdkGeneration) return;
        // Emit before closing: a subsequent SDK cancel must not win over switch.
        this.emitEvent(alternate ? '700001' : '700000');
        this.helper?.quitLoginPage().catch(() => {});
      });
      this.helper.setAuthConfig(uiResult.config);
      this.helper.setDialog(uiResult.isDialog);
      this.helper.setUIClickListener(new AliAuthUiClickListener(this, generation));
      this.helper.setAuthSDKInfo(secret);
      this.initialized = true;
      this.helper.checkEnvAvailable(1);
      result.success(null);
    } catch (error) {
      const message: string = errorMessage(error);
      this.releaseSdk();
      this.emitEvent('500000', message);
      result.error('500000', message, null);
    }
  }

  private login(call: MethodCall, result: MethodResult): void {
    if (!this.initialized || this.helper === null) {
      this.emitEvent('500003');
      result.success(null);
      return;
    }
    if (!this.environmentAvailable) {
      this.emitEvent('500005');
      result.success(null);
      return;
    }
    const timeoutValue: ESObject = call.argument('timeout');
    const timeout: number = typeof timeoutValue === 'number' && timeoutValue > 0 ? timeoutValue : DEFAULT_TIMEOUT;
    this.startLogin(timeout, this.sdkGeneration);
    result.success(null);
  }

  private startLogin(timeout: number, generation: number): void {
    if (!this.isCurrentGeneration(generation)) {
      return;
    }
    if (this.helper === null) {
      this.emitEvent('500003');
      return;
    }
    const helper: PhoneNumberAuthHelper = this.helper;
    helper.getLoginToken(timeout).catch((error: Error) => {
      if (this.isCurrentGeneration(generation)) {
        this.emitEvent('600011', error.message);
      }
    });
  }

  private startPreLogin(generation: number): void {
    if (!this.isCurrentGeneration(generation) || this.helper === null || this.preLoginRequested) {
      return;
    }
    this.preLoginRequested = true;
    try {
      this.helper.accelerateLoginPage(DEFAULT_TIMEOUT, new AliAuthPreLoginListener(this, generation));
    } catch (error) {
      this.onPreLoginFailure(generation, '', errorMessage(error));
    }
  }

  private isCurrentGeneration(generation: number): boolean {
    return generation === this.sdkGeneration && this.initialized;
  }

  private async quitPage(result: MethodResult): Promise<void> {
    if (this.helper === null) {
      result.success(null);
      return;
    }
    try {
      await this.helper.quitLoginPage();
      result.success(null);
    } catch (error) {
      result.error('600010', errorMessage(error), null);
    }
  }

  private checkEnvironment(result: MethodResult): void {
    if (!this.initialized || this.helper === null) {
      this.emitEvent('500003');
      result.success(null);
      return;
    }
    try {
      this.environmentAvailable = false;
      this.helper.checkEnvAvailable(1);
      result.success(null);
    } catch (error) {
      const message: string = errorMessage(error);
      this.emitEvent('500005', message);
      result.error('500005', message, null);
    }
  }

  private queryCheckBox(result: MethodResult): void {
    if (this.helper === null) {
      result.success(false);
      return;
    }
    try {
      this.isChecked = this.helper.queryCheckBoxIsChecked();
      result.success(this.isChecked);
    } catch (error) {
      result.error('600010', errorMessage(error), null);
    }
  }

  private async getCurrentCarrierName(result: MethodResult): Promise<void> {
    if (this.helper === null) {
      result.success('');
      return;
    }
    try {
      const carrier: string = await this.helper.getCurrentCarrierName();
      switch (carrier) {
        case 'CMCC':
          result.success('中国移动');
          break;
        case 'CUCC':
          result.success('中国联通');
          break;
        case 'CTCC':
          result.success('中国电信');
          break;
        default:
          result.success(carrier);
          break;
      }
    } catch (error) {
      result.error('600010', errorMessage(error), null);
    }
  }

  private async checkCellularDataEnable(): Promise<Map<string, ESObject>> {
    let enabled: boolean = false;
    let message: string = '蜂窝网络检测';
    try {
      const networks: Array<connection.NetHandle> = await connection.getAllNets();
      for (const network of networks) {
        const capabilities: connection.NetCapabilities = await connection.getNetCapabilities(network);
        if (capabilities.bearerTypes.indexOf(connection.NetBearType.BEARER_CELLULAR) >= 0) {
          enabled = true;
          break;
        }
      }
    } catch (error) {
      message = `蜂窝网络检测失败: ${errorMessage(error)}`;
    }
    const response: Map<string, ESObject> = new Map<string, ESObject>();
    response.set('code', '1');
    response.set('msg', message);
    response.set('data', enabled);
    return response;
  }

  private emitEvent(code: string, sdkMessage: string = '', data: ESObject = ''): void {
    if (this.eventSink === null) {
      return;
    }
    const mappedMessage: string = statusMessage(code);
    const event: Map<string, ESObject> = new Map<string, ESObject>();
    event.set('code', code);
    event.set('msg', mappedMessage.length > 0 ? mappedMessage : sdkMessage);
    event.set('data', data ?? '');
    event.set('isChecked', this.isChecked);
    this.eventSink.success(event);
  }

  private releaseSdk(): void {
    clearAuthDecoration();
    this.sdkGeneration += 1;
    this.preLoginRequested = false;
    this.initialized = false;
    this.environmentAvailable = false;
    const helper: PhoneNumberAuthHelper | null = this.helper;
    this.helper = null;
    this.tokenListener = null;
    if (helper !== null) {
      try {
        helper.clearAuthListener();
      } catch (error) {
      }
      try {
        helper.setUIClickListener(new NoopAliAuthUiClickListener());
      } catch (error) {
      }
      try {
        helper.quitLoginPage().catch((error: Error) => {
        });
      } catch (error) {
      }
    }
  }
}

class AliAuthStreamHandler implements StreamHandler {
  private plugin: AliAuthPlugin;

  constructor(plugin: AliAuthPlugin) {
    this.plugin = plugin;
  }

  onListen(args: ESObject, events: EventSink): void {
    this.plugin.onEventListen(events);
  }

  onCancel(args: ESObject): void {
    this.plugin.onEventCancel();
  }
}

class AliAuthTokenListener implements TokenResultListener {
  private plugin: AliAuthPlugin;
  private generation: number;

  constructor(plugin: AliAuthPlugin, generation: number) {
    this.plugin = plugin;
    this.generation = generation;
  }

  onSuccess(message: string): void {
    this.plugin.onTokenSuccess(this.generation, message);
  }

  onFailure(value: string): void {
    this.plugin.onTokenFailure(this.generation, value);
  }
}

class AliAuthPreLoginListener implements PreLoginResultListener {
  private plugin: AliAuthPlugin;
  private generation: number;

  constructor(plugin: AliAuthPlugin, generation: number) {
    this.plugin = plugin;
    this.generation = generation;
  }

  onTokenSuccess(vendor: string): void {
    this.plugin.onPreLoginSuccess(this.generation, vendor);
  }

  onTokenFailed(vendor: string, value: string): void {
    this.plugin.onPreLoginFailure(this.generation, vendor, value);
  }
}

class AliAuthUiClickListener implements AuthUIControlClickListener {
  private plugin: AliAuthPlugin;
  private generation: number;

  constructor(plugin: AliAuthPlugin, generation: number) {
    this.plugin = plugin;
    this.generation = generation;
  }

  onClick(code: string, jsonString: string): void {
    this.plugin.onUiClick(this.generation, code, jsonString);
  }
}

class NoopAliAuthUiClickListener implements AuthUIControlClickListener {
  onClick(code: string, jsonString: string): void {
  }
}
