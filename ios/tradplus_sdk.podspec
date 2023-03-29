#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tradplus_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tradplus_sdk'
  s.version          = '1.0.8'
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

     s.dependency 'TradPlusAdSDK', '9.1.0'
     s.dependency 'TradPlusAdSDK/TPCrossAdapter', '9.1.0'
     # #Meta
     s.dependency 'TradPlusAdSDK/FacebookAdapter', '9.1.0'
     s.dependency 'FBAudienceNetwork','6.12.0'
     # #Admob
     s.dependency 'TradPlusAdSDK/AdMobAdapter', '9.1.0'
     s.dependency 'Google-Mobile-Ads-SDK','10.2.0'
     # #UnityAds
     s.dependency 'TradPlusAdSDK/UnityAdapter', '9.1.0'
     s.dependency 'UnityAds','4.5.0'
     # #AppLovin
     s.dependency 'TradPlusAdSDK/AppLovinAdapter', '9.1.0'
     s.dependency 'AppLovinSDK','11.8.2'
     # #Tapjoy
     s.dependency 'TradPlusAdSDK/TapjoyAdapter', '9.1.0'
     s.dependency 'TapjoySDK','12.11.1'
     # #Vungle
     s.dependency 'TradPlusAdSDK/VungleAdapter', '9.1.0'
     s.dependency 'VungleSDK-iOS', '6.12.3'
     # #IronSource
     s.dependency 'TradPlusAdSDK/IronSourceAdapter', '9.1.0'
     s.dependency 'IronSourceSDK','7.2.7.0'
     # #AdColony
     s.dependency 'TradPlusAdSDK/AdColonyAdapter', '9.1.0'
     s.dependency 'AdColony','4.9.0'
     # #InMobi
     s.dependency 'TradPlusAdSDK/InMobiAdapter', '9.1.0'
     s.dependency 'InMobiSDK/Core' ,'10.1.2'
     #Mintegral
     s.dependency 'TradPlusAdSDK/MintegralAdapter', '9.1.0'
     s.dependency 'MintegralAdSDK' ,'7.3.3'
     s.dependency 'MintegralAdSDK/All','7.3.3'
     # #Smaato
     s.dependency 'TradPlusAdSDK/SmaatoAdapter', '9.1.0'
     s.dependency 'smaato-ios-sdk', '22.0.2'
     # #Baidu
     s.dependency 'TradPlusAdSDK/BaiduAdapter', '9.1.0'
     s.dependency 'BaiduMobAdSDK','5.121'
     # #Tencent Ads
     s.dependency 'TradPlusAdSDK/GDTMobAdapter', '9.1.0'
     s.dependency 'GDTMobSDK', '4.14.12'
     # #Pangle
     s.dependency 'TradPlusAdSDK/PangleAdapter', '9.1.0'
     s.dependency 'Ads-Global/BUAdSDK_Compatible', '5.0.0.9'
     # #穿山甲
     s.dependency 'TradPlusAdSDK/CSJAdapter', '9.1.0'
     s.dependency 'Ads-CN/BUAdSDK_Compatible', '5.0.0.5'
     # #KuaiShou
     # s.dependency 'TradPlusAdSDK/KuaiShouAdapter', '9.1.0'
     # s.dependency 'KSAdSDK', '3.3.40'
     # #Sigmob
     # s.dependency 'TradPlusAdSDK/SigmobAdapter', '9.1.0'
     # s.dependency 'SigmobAd-iOS', '4.7.0'
     # #YouDao
     # s.dependency 'TradPlusAdSDK/YouDaoAdapter', '9.1.0'
     # s.dependency 'YDADSDK', '2.16.14'
     # #Maio
     # s.dependency 'TradPlusAdSDK/MaioAdapter', '9.1.0'
     # s.dependency 'MaioSDK', '1.6.3'
     # #MyTarget
     # s.dependency 'TradPlusAdSDK/MyTargetAdapter', '9.1.0'
     # s.dependency 'myTargetSDK', '5.17.4'
     # #Kidoz
     # s.dependency 'TradPlusAdSDK/KidozAdapter', '9.1.0'
     # s.dependency 'TradPlusKidozSDK','8.9.3'
     # #Klevin
     # s.dependency 'TradPlusAdSDK/KlevinAdapter', '9.1.0'
     # s.dependency 'KlevinAdSDK','2.11.0.215'
     # #Start.io
     # s.dependency 'TradPlusAdSDK/StartAppAdapter',  '9.1.0'
     # s.dependency 'StartAppSDK','4.7.3'
     # #Chartboost
     # s.dependency 'TradPlusAdSDK/ChartboostAdapter', '9.1.0'
     # s.dependency 'ChartboostSDK','9.1.0'
     # #Fyber
     # s.dependency 'TradPlusAdSDK/FyberAdapter', '9.1.0'
     # s.dependency 'Fyber_Marketplace_SDK','8.1.9'
     # #SuperAwesome
     # s.dependency 'TradPlusAdSDK/SuperAwesomeAdapter', '9.1.0'
     # s.dependency 'SuperAwesome','8.5.6'
     # #Ogury
     # s.dependency 'TradPlusAdSDK/OguryAdapter', '9.1.0'
     # s.dependency 'OgurySdk', '2.1.0'
     # #Verve
     # s.dependency 'TradPlusAdSDK/VerveAdapter', '9.1.0'
     # s.dependency 'HyBid','2.17.0'
     # #Yandex
     # s.dependency 'TradPlusAdSDK/YandexAdapter', '9.1.0'
     # s.dependency 'YandexMobileAds','5.2.1'
     # #Helium
     # s.dependency 'TradPlusAdSDK/HeliumAdapter', '9.1.0'
     # s.dependency 'ChartboostHelium','3.3.2'
     # #Bigo
     # s.dependency 'TradPlusAdSDK/BigoAdapter', '9.1.0'
     # s.dependency 'BigoADS','2.1.1'

  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
end
