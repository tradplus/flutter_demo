//
//  TPFNativeView.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/14.
//

#import "TPFBannerView.h"
#import "TPFBannerManager.h"

@interface TPFBannerView()
{
    NSString *adUnitId;
    TPFBanner *bannerControl;
}

@end

@implementation TPFBannerView{
    
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init])
  {
      adUnitId = args[@"adUnitId"];
      bannerControl = [[TPFBannerManager sharedInstance] getBannerWithAdUnitID:adUnitId];
  }
  return self;
}

- (UIView*)view
{
    if(bannerControl.banner.isAutoRefresh)
    {
        if(!bannerControl.banner.autoShow)
        {
            [bannerControl showAd];
        }
    }
    else
    {
        [bannerControl showAd];
    }
    return bannerControl.banner;
}
@end
