
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTDUID2Manager : NSObject

+(TTDUID2Manager *)sharedInstance;
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
