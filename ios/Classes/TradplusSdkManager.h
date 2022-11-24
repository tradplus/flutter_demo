//
//  TradplusSdkManager.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/25.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface TradplusSdkManager : NSObject

+(TradplusSdkManager *)sharedInstance;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
- (void)addGlobalAdImpressionDelegate;
@end

NS_ASSUME_NONNULL_END
