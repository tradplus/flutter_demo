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
    NSString *className;
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
      className = args[@"className"];
      bannerControl = [[TPFBannerManager sharedInstance] getBannerWithAdUnitID:adUnitId];
      if(bannerControl != nil)
      {
          if(className != nil
             && ![className isKindOfClass:[NSNull class]]
             && className.length > 0)
          {
              Class class = NSClassFromString(className);
              if(class != nil)
              {
                  bannerControl.banner.customRenderingViewClass = class;
              }
              else
              {
                  MSLogInfo(@"banner no find  native className %@",className);
              }
          }
          else
          {
              bannerControl.banner.customRenderingViewClass = nil;
          }
      }
  }
  return self;
}

- (UIView*)view
{
    if(bannerControl == nil)
    {
        return nil;
    }
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
