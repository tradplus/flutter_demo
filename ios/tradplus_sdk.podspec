#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tradplus_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tradplus_sdk'
  s.version          = '1.1.2'
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

     s.dependency 'TradPlusAdSDK', '9.6.0'
     s.dependency 'TradPlusAdSDK/TPCrossAdapter', '9.6.0'
     #Meta
     s.dependency 'TradPlusAdSDK/FacebookAdapter', '9.6.0'
     s.dependency 'FBAudienceNetwork','6.12.0'
     #Admob
     s.dependency 'TradPlusAdSDK/AdMobAdapter', '9.6.0'
     s.dependency 'Google-Mobile-Ads-SDK','10.6.0'
     #UnityAds
     s.dependency 'TradPlusAdSDK/UnityAdapter', '9.6.0'
     s.dependency 'UnityAds','4.7.1'
     #AppLovin
     s.dependency 'TradPlusAdSDK/AppLovinAdapter', '9.6.0'
     s.dependency 'AppLovinSDK','11.10.1'
     #Tapjoy
     s.dependency 'TradPlusAdSDK/TapjoyAdapter', '9.6.0'
     s.dependency 'TapjoySDK','13.0.1'
     #Vungle
     s.dependency 'TradPlusAdSDK/VungleAdapter', '9.6.0'
     s.dependency 'VungleAds', '7.0.1'
     #IronSource
     s.dependency 'TradPlusAdSDK/IronSourceAdapter', '9.6.0'
     s.dependency 'IronSourceSDK','7.3.1.0'
     #AdColony
     s.dependency 'TradPlusAdSDK/AdColonyAdapter', '9.6.0'
     s.dependency 'AdColony','4.9.0'
     #InMobi
     s.dependency 'TradPlusAdSDK/InMobiAdapter', '9.6.0'
     s.dependency 'InMobiSDK/Core' ,'10.1.4'
     #Mintegral
     s.dependency 'TradPlusAdSDK/MintegralAdapter', '9.6.0'
     s.dependency 'MintegralAdSDK' ,'7.3.8'
     s.dependency 'MintegralAdSDK/All','7.3.8'
     #Smaato
     s.dependency 'TradPlusAdSDK/SmaatoAdapter', '9.6.0'
     s.dependency 'smaato-ios-sdk', '22.1.3'
     #Baidu
     s.dependency 'TradPlusAdSDK/BaiduAdapter', '9.6.0'
     s.dependency 'BaiduMobAdSDK','5.300'
     #Tencent Ads
     s.dependency 'TradPlusAdSDK/GDTMobAdapter', '9.6.0'
     s.dependency 'GDTMobSDK', '4.14.31'
     #Pangle
     s.dependency 'TradPlusAdSDK/PangleAdapter', '9.6.0'
     s.dependency 'Ads-Global', '5.2.1.1'
     #穿山甲
     s.dependency 'TradPlusAdSDK/CSJAdapter', '9.6.0'
     s.dependency 'Ads-CN', '5.3.0.4'
     # #KuaiShou
     # s.dependency 'TradPlusAdSDK/KuaiShouAdapter', '9.6.0'
     # s.dependency 'KSAdSDK', '3.3.47'
     # #Sigmob
     # s.dependency 'TradPlusAdSDK/SigmobAdapter', '9.6.0'
     # s.dependency 'SigmobAd-iOS', '4.9.1'
     # #YouDao
     # s.dependency 'TradPlusAdSDK/YouDaoAdapter', '9.6.0'
     # s.dependency 'YDADSDK', '2.16.22'
     # #Maio
     # s.dependency 'TradPlusAdSDK/MaioAdapter', '9.6.0'
     # s.dependency 'MaioSDK', '1.6.3'
     # #MyTarget
     # s.dependency 'TradPlusAdSDK/MyTargetAdapter', '9.6.0'
     # s.dependency 'myTargetSDK', '5.17.5'
     # #Kidoz
     # s.dependency 'TradPlusAdSDK/KidozAdapter', '9.6.0'
     # s.dependency 'TradPlusKidozSDK','8.9.3'
     # #Klevin
     # s.dependency 'TradPlusAdSDK/KlevinAdapter', '9.6.0'
     # s.dependency 'KlevinAdSDK','2.11.0.215'
     # #Start.io
     # s.dependency 'TradPlusAdSDK/StartAppAdapter',  '9.6.0'
     # s.dependency 'StartAppSDK','4.9.1'
     # #Chartboost
     # s.dependency 'TradPlusAdSDK/ChartboostAdapter', '9.6.0'
     # s.dependency 'ChartboostSDK','9.3.0'
     # #Fyber
     # s.dependency 'TradPlusAdSDK/FyberAdapter', '9.6.0'
     # s.dependency 'Fyber_Marketplace_SDK','8.2.2'
     # #SuperAwesome
     # s.dependency 'TradPlusAdSDK/SuperAwesomeAdapter', '9.6.0'
     # s.dependency 'SuperAwesome','9.0.1'
     # #Ogury
     # s.dependency 'TradPlusAdSDK/OguryAdapter', '9.6.0'
     # s.dependency 'OgurySdk', '4.1.2'
     # #Verve
     # s.dependency 'TradPlusAdSDK/VerveAdapter', '9.6.0'
     # s.dependency 'HyBid','2.18.1'
     # #Yandex
     # s.dependency 'TradPlusAdSDK/YandexAdapter', '9.6.0'
     # s.dependency 'YandexMobileAds','5.7.0'
     # #Helium
     # s.dependency 'TradPlusAdSDK/HeliumAdapter', '9.6.0'
     # s.dependency 'ChartboostMediationSDK','4.3.0'
	 # s.dependency 'ChartboostMediationAdapterChartboost','4.9.3.0.0'
     # #Bigo
     # s.dependency 'TradPlusAdSDK/BigoAdapter', '9.6.0'
     # s.dependency 'BigoADS','2.2.0'

  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 arm64' }
end
