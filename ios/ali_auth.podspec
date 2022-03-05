#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'ali_auth'
  s.version          = '0.2.2'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
  是一个集成阿里云号码认证服务SDK的flutter插件
                       DESC
  s.homepage         = 'http://ki5k.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'raohong07@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.vendored_frameworks = 'libs/ATAuthSDK.framework', 'libs/YTXMonitor.framework', 'libs/YTXOperators.framework'
  s.static_framework = false

  # 解决移动crash
  s.xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC',
    'ENABLE_BITCODE' => 'NO'
  }
  
  # 加载静态资源
  s.resources = ['Assets/*']

  s.ios.deployment_target = '9.0'
  # s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.pod_target_xcconfig = {'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'   }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end

