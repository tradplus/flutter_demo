#import <Flutter/Flutter.h>

@interface TradplusSdkPlugin : NSObject<FlutterPlugin>

+ (void)callbackWithEventName:(NSString *)name adUnitID:(NSString *)adUnitID adInfo:(NSDictionary *)adInfo error:(NSError *)error;

+ (void)callbackWithEventName:(NSString *)name adUnitID:(NSString *)adUnitID adInfo:(NSDictionary *)adInfo error:(NSError *)error exp:(NSDictionary *)exp;
@end
