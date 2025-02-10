#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `s.dependency lib lint tradplus_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tradplus_sdk'
  s.version          = '1.1.9'
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
  s.platform = :ios, '12.0'
  
  s.frameworks = 'NetworkExtension','DeviceCheck','CoreML'

  s.static_framework = true

  s.pod_target_xcconfig =   {'OTHER_LDFLAGS' => ['-lObjC']}
  
  s.libraries = 'c++', 'z', 'sqlite3', 'xml2', 'resolv', 'bz2.1.0','bz2','xml2','resolv.9','iconv','c++abi'

  s.vendored_frameworks = 'TradPlusFrameworks/**/*.framework'
  
  s.vendored_libraries = ['TradPlusFrameworks/GDTMob/GDTSDK/*.a','TradPlusFrameworks/Kidoz/KidozSDK/*.a','TradPlusFrameworks/YouDao/YDSDK/*.a',]
  
  s.resources = ['TradPlusFrameworks/**/*.bundle',"Assets/**/*"]

  s.dependency 'TradPlusAdSDK', '13.1.0'
  s.dependency 'TradPlusAdSDK/TPCrossAdapter', '13.1.0'
  #Meta
  s.dependency 'TradPlusAdSDK/FacebookAdapter', '13.1.0'
  s.dependency 'FBAudienceNetwork','6.16.0'
  #GoogleAds
  s.dependency 'TradPlusAdSDK/AdMobAdapter', '13.1.0'
  s.dependency 'Google-Mobile-Ads-SDK','11.13.0'
  #UnityAds
  s.dependency 'TradPlusAdSDK/UnityAdapter', '13.1.0'
  s.dependency 'UnityAds','4.13.0'
  #AppLovin
  s.dependency 'TradPlusAdSDK/AppLovinAdapter', '13.1.0'
  s.dependency 'AppLovinSDK','13.0.1'
  #Liftoff
  s.dependency 'TradPlusAdSDK/VungleAdapter', '13.1.0'
  s.dependency 'VungleAds', '7.4.4'
  #IronSource
  s.dependency 'TradPlusAdSDK/IronSourceAdapter', '13.1.0'
  s.dependency 'IronSourceSDK','8.6.0'
  #InMobi
  s.dependency 'TradPlusAdSDK/InMobiAdapter', '13.1.0'
  s.dependency 'InMobiSDK' ,'10.8.0'
  #Mintegral
  s.dependency 'TradPlusAdSDK/MintegralAdapter', '13.1.0'
  s.dependency 'MintegralAdSDK' ,'7.7.5'
  s.dependency 'MintegralAdSDK/All','7.7.5'
  #Pangle
  s.dependency 'TradPlusAdSDK/PangleAdapter', '13.1.0'
  s.dependency 'Ads-Global', '6.4.1.1'
  #CSJ
  s.dependency 'TradPlusAdSDK/CSJAdapter', '13.1.0'
  s.dependency 'Ads-CN', '6.6.1.2'
  #Tapjoy
  s.dependency 'TradPlusAdSDK/TapjoyAdapter', '13.1.0'
  s.dependency 'TapjoySDK','13.4.0'
# #Tencent Ads
# s.dependency 'TradPlusAdSDK/GDTMobAdapter', '13.1.0'
# s.dependency 'GDTMobSDK', '4.15.10'
# #KuaiShou
# s.dependency 'TradPlusAdSDK/KuaiShouAdapter', '13.1.0'
# s.dependency 'KSAdSDK', '3.3.72'
# #Sigmob
# s.dependency 'TradPlusAdSDK/SigmobAdapter', '13.1.0'
# s.dependency 'SigmobAd-iOS', '4.16.0'
# #Smaato
# s.dependency 'TradPlusAdSDK/SmaatoAdapter', '13.1.0'
# s.dependency 'smaato-ios-sdk', '22.9.2'
# #Maio
# s.dependency 'TradPlusAdSDK/MaioAdapter', '13.1.0'
# s.dependency 'MaioSDK-v2', '2.1.5'
# #MyTarget
# s.dependency 'TradPlusAdSDK/MyTargetAdapter', '13.1.0'
# s.dependency 'myTargetSDK', '5.24.1'
# #Kidoz
# s.dependency 'TradPlusAdSDK/KidozAdapter', '13.1.0'
# s.dependency 'TradPlusKidozSDK','8.9.3'
# #Start.io
# s.dependency 'TradPlusAdSDK/StartAppAdapter',  '13.1.0'
# s.dependency 'StartAppSDK','4.10.0'
# #Chartboost
# s.dependency 'TradPlusAdSDK/ChartboostAdapter', '13.1.0'
# s.dependency 'ChartboostSDK','9.8.0'
# #Fyber
# s.dependency 'TradPlusAdSDK/FyberAdapter', '13.1.0'
# s.dependency 'Fyber_Marketplace_SDK','8.3.4'
# #SuperAwesome
# s.dependency 'TradPlusAdSDK/SuperAwesomeAdapter', '13.1.0'
# s.dependency 'SuperAwesome','9.0.1'
# #Ogury
# s.dependency 'TradPlusAdSDK/OguryAdapter', '13.1.0'
# s.dependency 'OgurySdk', '5.0.1'
# #Baidu
# s.dependency 'TradPlusAdSDK/BaiduAdapter', '13.1.0'
# s.dependency 'BaiduMobAdSDK','5.373'
# #Verve
# s.dependency 'TradPlusAdSDK/VerveAdapter', '13.1.0'
# s.dependency 'HyBid','3.1.4'
# #Yandex
# s.dependency 'TradPlusAdSDK/YandexAdapter', '13.1.0'
# s.dependency 'YandexMobileAds','7.8.0'
# #Helium
# s.dependency 'TradPlusAdSDK/HeliumAdapter', '13.1.0'
# s.dependency 'ChartboostMediationSDK','5.1.0'
# s.dependency 'ChartboostMediationAdapterChartboost','5.9.8.0.0'
# #Bigo
# s.dependency 'TradPlusAdSDK/BigoAdapter', '13.1.0'
# s.dependency 'BigoADS','4.6.0'
# #ZMaticoo
# s.dependency 'TradPlusAdSDK/TPZMaticooAdapter', '13.1.0'
# s.dependency 'zMaticoo','1.5.2'
# #Beizi
# s.dependency 'TradPlusAdSDK/BeiziAdapter', '13.1.0'
# s.dependency 'BeiZiSDK-iOS/BeiZiSDK-iOS','4.90.4.36'
# #Amazon
# s.dependency 'TradPlusAdSDK/AmazonAdapter', '13.1.0'
# s.dependency 'AmazonPublisherServicesSDK','5.0.0'
# #Tanx
# s.dependency 'TradPlusAdSDK/TanxAdapter', '13.1.0'
# s.dependency 'TradPlusTanXSDK','3.5.6'
# #KwaiAds
# s.dependency 'TradPlusAdSDK/KwaiAdsAdapter', '13.1.0'
# s.dependency 'KwaiAdsSDK','1.1.0'
# #YSONetwork
# s.dependency 'TradPlusAdSDK/YSONetworkAdapter', '13.1.0'
# s.dependency 'YsoNetworkSDK','1.1.29'
# #TaurusX
# s.dependency 'TradPlusAdSDK/TaurusXAdapter', '13.1.0'
# s.dependency 'TaurusxAdsSDK','1.0.2'
# #AdColony
# s.dependency 'TradPlusAdSDK/AdColonyAdapter', '13.1.0'
# s.dependency 'AdColony','4.9.0'

  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 arm64' }
end
