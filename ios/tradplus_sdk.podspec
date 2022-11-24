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

  s.dependency 'TradPlusAdSDK', '8.3.20'
  s.dependency 'TradPlusAdSDK/FacebookAdapter', '8.3.20'
  s.dependency 'FBAudienceNetwork','6.11.2'
  s.dependency 'TradPlusAdSDK/AdMobAdapter', '8.3.20'
  s.dependency 'Google-Mobile-Ads-SDK','9.11.0'
  s.dependency 'TradPlusAdSDK/UnityAdapter', '8.3.20'
  s.dependency 'UnityAds','4.4.0'
  s.dependency 'TradPlusAdSDK/AppLovinAdapter', '8.3.20'
  s.dependency 'AppLovinSDK','11.5.0'
  s.dependency 'TradPlusAdSDK/TapjoyAdapter', '8.3.20'
  s.dependency 'TapjoySDK','12.10.0'
  s.dependency 'TradPlusAdSDK/VungleAdapter', '8.3.20'
  s.dependency 'VungleSDK-iOS', '6.12.0'
  s.dependency 'TradPlusAdSDK/IronSourceAdapter', '8.3.20'
  s.dependency 'IronSourceSDK','7.2.5.0'
  s.dependency 'TradPlusAdSDK/AdColonyAdapter', '8.3.20'
  s.dependency 'AdColony','4.9.0'
  s.dependency 'TradPlusAdSDK/InMobiAdapter', '8.3.20'
  s.dependency 'InMobiSDK/Core' ,'10.1.0'
  s.dependency 'TradPlusAdSDK/MintegralAdapter', '8.3.20'
  s.dependency 'MintegralAdSDK' ,'7.2.1'
  s.dependency 'MintegralAdSDK/All','7.2.1'
  s.dependency 'TradPlusAdSDK/GDTMobAdapter', '8.3.20'
  s.dependency 'GDTMobSDK', '4.13.90'
  s.dependency 'TradPlusAdSDK/SmaatoAdapter', '8.3.20'
  s.dependency 'smaato-ios-sdk', '21.7.7'
  s.dependency 'TradPlusAdSDK/TPCrossAdapter', '8.3.20'
  s.dependency 'TradPlusAdSDK/BaiduAdapter', '8.3.20'
  s.dependency 'BaiduMobAdSDK','4.901'
  s.dependency 'TradPlusAdSDK/PangleAdapter', '8.3.20'
  #穿山甲
  s.dependency 'Ads-CN/BUAdSDK_Compatible', '4.8.0.8'
  #Pangle
  s.dependency 'Ads-Global/BUAdSDK_Compatible', '4.7.0.6'


  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
end
