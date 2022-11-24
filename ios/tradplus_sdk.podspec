#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tradplus_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tradplus_sdk'
  s.version          = '1.0.4'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
Tradplus SDK Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'
  
  s.frameworks = 'NetworkExtension','DeviceCheck'

  s.pod_target_xcconfig =   {'OTHER_LDFLAGS' => ['-lObjC']}
  
  s.libraries = 'c++', 'z', 'sqlite3', 'xml2', 'resolv', 'bz2.1.0','bz2','xml2','resolv.9','iconv','c++abi'

  s.vendored_frameworks = 'TradPlusFrameworks/**/*.framework'
  
  s.vendored_libraries = ['TradPlusFrameworks/GDTMob/GDTSDK/*.a','TradPlusFrameworks/Kidoz/KidozSDK/*.a','TradPlusFrameworks/YouDao/YDSDK/*.a',]
  
  s.resources = ['TradPlusFrameworks/**/*.bundle',"Assets/**/*"]

  s.dependency 'TradPlusAdSDK', '8.5.0'
  s.dependency 'TradPlusAdSDK/FacebookAdapter', '8.5.0'
  s.dependency 'FBAudienceNetwork','6.12.0'
  s.dependency 'TradPlusAdSDK/AdMobAdapter', '8.5.0'
  s.dependency 'Google-Mobile-Ads-SDK','9.13.0'
  s.dependency 'TradPlusAdSDK/UnityAdapter', '8.5.0'
  s.dependency 'UnityAds','4.4.1'
  s.dependency 'TradPlusAdSDK/AppLovinAdapter', '8.5.0'
  s.dependency 'AppLovinSDK','11.5.5'
  s.dependency 'TradPlusAdSDK/TapjoyAdapter', '8.5.0'
  s.dependency 'TapjoySDK','12.11.0'
  s.dependency 'TradPlusAdSDK/VungleAdapter', '8.5.0'
  s.dependency 'VungleSDK-iOS', '6.12.1'
  s.dependency 'TradPlusAdSDK/IronSourceAdapter', '8.5.0'
  s.dependency 'IronSourceSDK','7.2.5.1'
  s.dependency 'TradPlusAdSDK/AdColonyAdapter', '8.5.0'
  s.dependency 'AdColony','4.9.0'
  s.dependency 'TradPlusAdSDK/InMobiAdapter', '8.5.0'
  s.dependency 'InMobiSDK/Core' ,'10.1.1'
  s.dependency 'TradPlusAdSDK/MintegralAdapter', '8.5.0'
  s.dependency 'MintegralAdSDK' ,'7.2.5'
  s.dependency 'MintegralAdSDK/All','7.2.5'
  s.dependency 'TradPlusAdSDK/GDTMobAdapter', '8.5.0'
  s.dependency 'GDTMobSDK', '4.13.90'
  s.dependency 'TradPlusAdSDK/SmaatoAdapter', '8.5.0'
  s.dependency 'smaato-ios-sdk', '21.7.8'
  s.dependency 'TradPlusAdSDK/TPCrossAdapter', '8.5.0'
  s.dependency 'TradPlusAdSDK/BaiduAdapter', '8.5.0'
  s.dependency 'BaiduMobAdSDK','4.901'
  s.dependency 'TradPlusAdSDK/PangleAdapter', '8.5.0'
  #穿山甲
  s.dependency 'Ads-CN/BUAdSDK_Compatible', '4.8.1.0'
  #Pangle
  s.dependency 'Ads-Global/BUAdSDK_Compatible', '4.8.0.6'


  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
end
