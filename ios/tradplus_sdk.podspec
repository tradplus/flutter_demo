  #
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `s.dependency lib lint tradplus_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tradplus_sdk'
  s.version          = '1.2.2'
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

  s.pod_target_xcconfig =   {'OTHER_LDFLAGS' => ['-lObjC']}
  
  s.libraries = 'c++', 'z', 'sqlite3', 'xml2', 'resolv', 'bz2.1.0','bz2','xml2','resolv.9','iconv','c++abi'

  s.vendored_frameworks = 'TradPlusFrameworks/**/*.framework'

  s.static_framework = true
  
  s.vendored_libraries = ['TradPlusFrameworks/GDTMob/GDTSDK/*.a','TradPlusFrameworks/Kidoz/KidozSDK/*.a','TradPlusFrameworks/YouDao/YDSDK/*.a',]
  
  s.resources = ['TradPlusFrameworks/**/*.bundle',"Assets/**/*"]

#   s.dependency 'TradPlusAdSDK', '14.2.0'
#   s.dependency 'TradPlusAdSDK/FacebookAdapter', '14.2.0'
#   s.dependency 'FBAudienceNetwork','6.20.1'
#   s.dependency 'TradPlusAdSDK/AdMobAdapter', '14.2.0'
#   s.dependency 'Google-Mobile-Ads-SDK','12.8.0'
#   s.dependency 'TradPlusAdSDK/UnityAdapter', '14.2.0'
#   s.dependency 'UnityAds','4.15.1'
#   s.dependency 'TradPlusAdSDK/AppLovinAdapter', '14.2.0'
#   s.dependency 'AppLovinSDK','13.3.1'
#   s.dependency 'TradPlusAdSDK/TapjoyAdapter', '14.2.0'
#   s.dependency 'TapjoySDK','13.4.0'
#   s.dependency 'TradPlusAdSDK/VungleAdapter', '14.2.0'
#   s.dependency 'VungleAds', '7.5.1'
#   s.dependency 'TradPlusAdSDK/IronSourceAdapter', '14.2.0'
#   s.dependency 'IronSourceSDK','8.10.0'
#   s.dependency 'TradPlusAdSDK/AdColonyAdapter', '14.2.0'
#   s.dependency 'AdColony','4.9.0'
#   s.dependency 'TradPlusAdSDK/InMobiAdapter', '14.2.0'
#   s.dependency 'InMobiSDK' ,'10.8.3'
#   s.dependency 'TradPlusAdSDK/MintegralAdapter', '14.2.0'
#   s.dependency 'MintegralAdSDK' ,'7.7.8'
#   s.dependency 'MintegralAdSDK/All','7.7.8'
#   s.dependency 'TradPlusAdSDK/KuaiShouAdapter', '14.2.0'
#   s.dependency 'KSAdSDK', '4.6.30.1'
#   s.dependency 'TradPlusAdSDK/SigmobAdapter', '14.2.0'
#   s.dependency 'SigmobAd-iOS', '4.20.0'
#   s.dependency 'TradPlusAdSDK/GDTMobAdapter', '14.2.0'
#   s.dependency 'GDTMobSDK', '4.15.50'
#   s.dependency 'TradPlusAdSDK/PangleAdapter', '14.2.0'
#   s.dependency 'Ads-Global', '7.2.0.5'
#   s.dependency 'TradPlusAdSDK/SmaatoAdapter', '14.2.0'
#   s.dependency 'smaato-ios-sdk', '22.9.3'
#   s.dependency 'TradPlusAdSDK/MaioAdapter', '14.2.0'
#   s.dependency 'MaioSDK-v2', '2.1.6'
#   s.dependency 'TradPlusAdSDK/MyTargetAdapter', '14.2.0'
#   s.dependency 'myTargetSDK', '5.31.2'
#   s.dependency 'TradPlusAdSDK/KidozAdapter', '14.2.0'
#   s.dependency 'TradPlusKidozSDK','8.9.3'
#   s.dependency 'TradPlusAdSDK/StartAppAdapter',  '14.2.0'
#   s.dependency 'StartAppSDK','4.10.0'
#   s.dependency 'TradPlusAdSDK/TPCrossAdapter', '14.2.0'
#   s.dependency 'TradPlusAdSDK/ChartboostAdapter', '14.2.0'
#   s.dependency 'ChartboostSDK','9.9.1'
#   s.dependency 'TradPlusAdSDK/FyberAdapter', '14.2.0'
#   s.dependency 'Fyber_Marketplace_SDK','8.3.8'
#   s.dependency 'TradPlusAdSDK/SuperAwesomeAdapter', '14.2.0'
#   s.dependency 'SuperAwesome','9.0.1'
#   s.dependency 'TradPlusAdSDK/OguryAdapter', '14.2.0'
#   s.dependency 'OgurySdk', '5.0.2'
#   s.dependency 'TradPlusAdSDK/BaiduAdapter', '14.2.0'
#   s.dependency 'BaiduMobAdSDK','5.400'
#   s.dependency 'TradPlusAdSDK/VerveAdapter', '14.2.0'
#   s.dependency 'HyBid','3.6.0'
#   s.dependency 'TradPlusAdSDK/YandexAdapter', '14.2.0'
#   s.dependency 'YandexMobileAds','7.15.0'
#   s.dependency 'TradPlusAdSDK/HeliumAdapter', '14.2.0'
#   s.dependency 'ChartboostMediationSDK','5.3.0'
#   s.dependency 'ChartboostMediationAdapterChartboost','5.9.9.0.0'
#   s.dependency 'TradPlusAdSDK/CSJAdapter', '14.2.0'
#   s.dependency 'Ads-CN/BUAdSDK', '6.9.1.2'
#   s.dependency 'TradPlusAdSDK/BigoAdapter', '14.2.0'
#   s.dependency 'BigoADS','4.8.1'
#   s.dependency 'TradPlusAdSDK/TPGoogleIMAAdapter', '14.2.0'
#   s.dependency 'GoogleAds-IMA-iOS-SDK','3.26.1'
#   s.dependency 'TradPlusAdSDK/TPZMaticooAdapter', '14.2.0'
#   s.dependency 'zMaticoo','1.5.4.3'
#   s.dependency 'TradPlusAdSDK/BeiziAdapter', '14.2.0'
#   s.dependency 'BeiZiSDK-iOS/BeiZiSDK-iOS','4.90.6.1'
#   s.dependency 'TradPlusAdSDK/AmazonAdapter', '14.2.0'
#   s.dependency 'AmazonPublisherServicesSDK','5.2.0'
#   s.dependency 'TradPlusAdSDK/TanxAdapter', '14.2.0'
#   s.dependency 'TradPlusTanXSDK','3.5.6'
#   s.dependency 'TradPlusAdSDK/KwaiAdsAdapter', '14.2.0'
#   s.dependency 'KwaiAdsSDK','1.1.0'
#   s.dependency 'TradPlusAdSDK/YSONetworkAdapter', '14.2.0'
#   s.dependency 'YsoNetworkSDK','1.1.31'
#   s.dependency 'TradPlusAdSDK/TaurusXAdapter', '14.2.0'
#   s.dependency 'TaurusxAdsSDK','1.7.0'

  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 arm64' }
end
