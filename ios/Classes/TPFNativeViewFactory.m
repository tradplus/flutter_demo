//
//  TPFNativeViewFactory.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/14.
//

#import "TPFNativeViewFactory.h"
#import "TPFNativeView.h"

@implementation TPFNativeViewFactory
{
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
{
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
  return [[TPFNativeView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec
{
    return [FlutterStandardMessageCodec sharedInstance];
}

@end
