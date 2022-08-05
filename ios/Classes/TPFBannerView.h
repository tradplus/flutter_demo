//
//  TPFBannerView.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/14.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPFBannerView : NSObject<FlutterPlatformView>


- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView *)view;
@end

NS_ASSUME_NONNULL_END
