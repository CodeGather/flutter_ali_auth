package com.jokui.rao.auth.ali_auth;

/**
 * @ProjectName: ali_auth
 * @Package: com.jokui.rao.auth.ali_auth
 * @ClassName: StatusAll
 * @Description: java类作用描述
 * @Author: liys
 * @CreateDate: 2/16/22 5:58 PM
 * @UpdateUser: 更新者
 * @UpdateDate: 2/16/22 5:58 PM
 * @UpdateRemark: 更新说明
 * @Version: 1.0
 */
public enum StatusAll {
  Status600000("获取token成功！", "600000"),
  Status600001("唤起授权页成功！", "600001"),
  Status600002("唤起授权⻚失败！建议切换到其他登录⽅式", "600002"),
  Status600004("获取运营商配置信息失败！创建⼯单联系⼯程师", "600004"),
  Status600005("⼿机终端不安全！切换到其他登录⽅式", "600005"),
  Status600007("未检测到sim卡！⽤户检查 SIM 卡后重试", "600007"),
  Status600008("蜂窝⽹络未开启！⽤户开启移动⽹络后重试", "600008"),
  Status600009("⽆法判断运营商! 创建⼯单联系⼯程师", "600009"),
  Status600010("未知异常创建！⼯单联系⼯程师", "600010"),
  Status600011("获取token失败！切换到其他登录⽅式", "600011"),
  Status600012("预取号失败！", "600012"),
  Status600013("运营商维护升级！该功能不可⽤创建⼯单联系⼯程师", "600013"),
  Status600014("运营商维护升级！该功能已达最⼤调⽤次创建⼯单联系⼯程师", "600014"),
  Status600015("接⼝超时！切换到其他登录⽅式", "600011"),
  Status600017("AppID、Appkey解析失败! 秘钥未设置或者设置错误，请先检查秘钥信息，如果⽆法解决问题创建⼯单联系⼯程师", "600017"),
  Status600021("点击登录时检测到运营商已切换！⽤户退出授权⻚，重新登录", "600021"),
  Status600023("加载⾃定义控件异常！检查⾃定义控件添加是否正确", "600023"),
  Status600024("终端环境检查⽀持认证", "600024"),
  Status600025("终端检测参数错误检查传⼊参数类型与范围是否正确", "600025"),
  Status600026("授权⻚已加载时不允许调⽤加速或预取号接⼝检查是否有授权⻚拉起后，去调⽤preLogin或者accelerateAuthPage的接⼝，该⾏为不允许", "600026"),
  Status700000("点击返回", "700000"),
  Status700001("用户切换其他登录方式", "700001"),
  Status700002("点击登录按钮", "700002"),
  Status700003("勾选协议选项", "700003");


  private String name;
  private String value;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getValue() {
    return value;
  }

  public void setValue(String value) {
    this.value = value;
  }

  // 构造方法
  StatusAll(String name, String value) {
    this.name = name;
    this.value = value;
  }

  // 普通方法
  public static String getName(String value) {
    for (StatusAll t : StatusAll.values()) {
      if (t.getValue().equals(value)) {
        return t.name;
      }
    }
    return null;
  }
  /**
   * 通过value取枚举
   * @param valueKey
   * @return
   */
  public static StatusAll getStatusByValue(String valueKey){
    for (StatusAll enums : StatusAll.values()) {
      if (enums.getValue().equals(valueKey)) {
        return enums;
      }
    }
    return null;
  }

}
