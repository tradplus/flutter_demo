#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `s.dependency lib lint tradplus_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tradplus_sdk'
  s.version          = '1.1.6'
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
  
  s.frameworks = 'NetworkExtension','DeviceCheck'

  s.pod_target_xcconfig =   {'OTHER_LDFLAGS' => ['-lObjC']}
  
  s.libraries = 'c++', 'z', 'sqlite3', 'xml2', 'resolv', 'bz2.1.0','bz2','xml2','resolv.9','iconv','c++abi'

  s.vendored_frameworks = 'TradPlusFrameworks/**/*.framework'
  
  s.vendored_libraries = ['TradPlusFrameworks/GDTMob/GDTSDK/*.a','TradPlusFrameworks/Kidoz/KidozSDK/*.a','TradPlusFrameworks/YouDao/YDSDK/*.a',]
  
  s.resources = ['TradPlusFrameworks/**/*.bundle',"Assets/**/*"]

#     s.dependency 'TradPlusAdSDK', '12.0.0'
#     s.dependency 'TradPlusAdSDK/TPCrossAdapter', '12.0.0'
#     #Meta
#     s.dependency 'TradPlusAdSDK/FacebookAdapter', '12.0.0'
#     s.dependency 'FBAudienceNetwork','6.15.1'
#     #GoogleAds
#     s.dependency 'TradPlusAdSDK/AdMobAdapter', '12.0.0'
#     s.dependency 'Google-Mobile-Ads-SDK','11.7.0'
#     #UnityAds
#     s.dependency 'TradPlusAdSDK/UnityAdapter', '12.0.0'
#     s.dependency 'UnityAds','4.12.1'
#     #AppLovin
#     s.dependency 'TradPlusAdSDK/AppLovinAdapter', '12.0.0'
#     s.dependency 'AppLovinSDK','12.6.0'
#     #Liftoff
#     s.dependency 'TradPlusAdSDK/VungleAdapter', '12.0.0'
#     s.dependency 'VungleAds', '7.4.0'
#     #IronSource
#     s.dependency 'TradPlusAdSDK/IronSourceAdapter', '12.0.0'
#     s.dependency 'IronSourceSDK','8.2.0'
#     #InMobi
#     s.dependency 'TradPlusAdSDK/InMobiAdapter', '12.0.0'
#     s.dependency 'InMobiSDK' ,'10.7.5'
#     #Mintegral
#     s.dependency 'TradPlusAdSDK/MintegralAdapter', '12.0.0'
#     s.dependency 'MintegralAdSDK' ,'7.6.9'
#     s.dependency 'MintegralAdSDK/All','7.6.9'
#     #KuaiShou
#     s.dependency 'TradPlusAdSDK/KuaiShouAdapter', '12.0.0'
#     s.dependency 'KSAdSDK', '3.3.66.3'
#     #Sigmob
#     s.dependency 'TradPlusAdSDK/SigmobAdapter', '12.0.0'
#     s.dependency 'SigmobAd-iOS', '4.15.0'
#     #Tencent Ads
#     s.dependency 'TradPlusAdSDK/GDTMobAdapter', '12.0.0'
#     s.dependency 'GDTMobSDK', '4.14.90'
#     #Pangle
#     s.dependency 'TradPlusAdSDK/PangleAdapter', '12.0.0'
#     s.dependency 'Ads-Global', '6.1.0.6'
#     #Smaato
#     s.dependency 'TradPlusAdSDK/SmaatoAdapter', '12.0.0'
#     s.dependency 'smaato-ios-sdk', '22.8.4'
#     #Maio
#     s.dependency 'TradPlusAdSDK/MaioAdapter', '12.0.0'
#     s.dependency 'MaioSDK-v2', '2.1.5'
#     #MyTarget
#     s.dependency 'TradPlusAdSDK/MyTargetAdapter', '12.0.0'
#     s.dependency 'myTargetSDK', '5.21.5'
#     #Chartboost
#     s.dependency 'TradPlusAdSDK/ChartboostAdapter', '12.0.0'
#     s.dependency 'ChartboostSDK','9.7.0'
#     #Fyber
#     s.dependency 'TradPlusAdSDK/FyberAdapter', '12.0.0'
#     s.dependency 'Fyber_Marketplace_SDK','8.3.1'
#     #Ogury
#     s.dependency 'TradPlusAdSDK/OguryAdapter', '12.0.0'
#     s.dependency 'OgurySdk', '4.4.0'
#     #Baidu
#     s.dependency 'TradPlusAdSDK/BaiduAdapter', '12.0.0'
#     s.dependency 'BaiduMobAdSDK','5.360'
#     #Verve
#     s.dependency 'TradPlusAdSDK/VerveAdapter', '12.0.0'
#     s.dependency 'HyBid','3.0.3'
#     #Yandex
#     s.dependency 'TradPlusAdSDK/YandexAdapter', '12.0.0'
#     s.dependency 'YandexMobileAds','7.1.1'
#     #Helium
#     s.dependency 'TradPlusAdSDK/HeliumAdapter', '12.0.0'
#     s.dependency 'ChartboostMediationSDK','4.9.0.1'
#     s.dependency 'ChartboostMediationAdapterChartboost','4.9.7.0.0'
#     #CSJ
#     s.dependency 'TradPlusAdSDK/CSJAdapter', '12.0.0'
#     s.dependency 'Ads-CN', '6.2.1.6'
#     #Bigo
#     s.dependency 'TradPlusAdSDK/BigoAdapter', '12.0.0'
#     s.dependency 'BigoADS','4.3.0'
#     #zMaticoo
#     s.dependency 'TradPlusAdSDK/TPZMaticooAdapter', '12.0.0'
#     s.dependency 'zMaticoo','1.4.0'
#     #Beizi
#     s.dependency 'TradPlusAdSDK/BeiziAdapter', '12.0.0'
#     s.dependency 'BeiZiSDK-iOS/BeiZiSDK-iOS','4.90.4.8'
#     #Amazon
#     s.dependency 'TradPlusAdSDK/AmazonAdapter', '12.0.0'
#     s.dependency 'AmazonPublisherServicesSDK','4.9.7'
#     #TanX
#     s.dependency 'TradPlusAdSDK/TanxAdapter', '12.0.0'
#     s.dependency 'TradPlusTanXSDK','3.5.3'
#     #KwaiAds
#     s.dependency 'TradPlusAdSDK/KwaiAdsAdapter', '12.0.0'
#     s.dependency 'TradPlusKwaiAdsSDK','1.0.8'
#     #Tapjoy
#     s.dependency 'TradPlusAdSDK/TapjoyAdapter', '12.0.0'
#     s.dependency 'TapjoySDK','13.4.0'
#     #AdColony
#     s.dependency 'TradPlusAdSDK/AdColonyAdapter', '12.0.0'
#     s.dependency 'AdColony','4.9.0'
#      #Start.io
#     s.dependency 'TradPlusAdSDK/StartAppAdapter',  '12.0.0'
#     s.dependency 'StartAppSDK','4.10.0'
#      #Kidoz
#     s.dependency 'TradPlusAdSDK/KidozAdapter', '12.0.0'
#     s.dependency 'TradPlusKidozSDK','8.9.3'
#     #SuperAwesome
#     s.dependency 'TradPlusAdSDK/SuperAwesomeAdapter', '12.0.0'
#     s.dependency 'SuperAwesome','9.0.1'

  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 arm64' }
end
