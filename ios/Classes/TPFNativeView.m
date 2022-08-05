//
//  TPFNativeView.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/14.
//

#import "TPFNativeView.h"
#import "TPFNativeManager.h"

@interface TPFNativeView()
{
    UIView *bgView;
    NSString *className;
    NSString *adUnitId;
    NSDictionary *extraMap;
    CGFloat height;
    CGFloat width;
    NSString *sceneId;
    TradPlusAdNativeObject *nativeObject;
}

@end

@implementation TPFNativeView

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init])
  {
      adUnitId = args[@"adUnitId"];
      className = args[@"className"];
      extraMap = args[@"extraMap"];
      height = [args[@"height"] floatValue];
      width = [args[@"width"] floatValue];
      sceneId = args[@"sceneId"];
  }
  return self;
}

- (UIView*)view
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    TPFNative *native = [[TPFNativeManager sharedInstance] getNativeWithAdUnitID:adUnitId];
    nativeObject = native.getReadyNativeObject;
    if(nativeObject == nil)
    {
        return nil;
    }
    if(className != nil
       && ![className isKindOfClass:[NSNull class]]
       && className.length > 0)
    {
        Class class = NSClassFromString(className);
        if(class != nil)
        {
            bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            bgView.backgroundColor = [UIColor clearColor];
            [nativeObject showADWithRenderingViewClass:class subview:bgView sceneId:sceneId];
            return bgView;
        }
    }
    if(extraMap != nil && ![extraMap isKindOfClass:[NSNull class]])
    {
        TradPlusNativeRenderer *nativeRenderer = [self setupAdViewWithExtraMap:extraMap];
        [nativeObject showADWithNativeRenderer:nativeRenderer subview:bgView sceneId:sceneId];
        return bgView;
    }
    return nil;
}

- (TradPlusNativeRenderer *)setupAdViewWithExtraMap:(NSDictionary *)extraMap
{
    TradPlusNativeRenderer *nativeRenderer = [[TradPlusNativeRenderer alloc] init];
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    UIView *adView = [[UIView alloc] init];
    NSDictionary *parent = extraMap[@"parent"];
    NSDictionary *appIcon = extraMap[@"appIcon"];
    NSDictionary *cta = extraMap[@"cta"];
    NSDictionary *desc = extraMap[@"desc"];
    NSDictionary *mainImage = extraMap[@"mainImage"];
    NSDictionary *mainTitle = extraMap[@"mainTitle"];
    NSDictionary *adLogo = extraMap[@"adLogo"];
    if(parent != nil)
    {
        BOOL isCustomClick = [parent[@"isCustomClick"] boolValue];
        [self setupView:adView viewInfo:parent];
        [nativeRenderer setAdView:adView canClick:isCustomClick];
        bgView.frame = adView.bounds;
    }
    if(mainImage != nil)
    {
        BOOL isCustomClick = [mainImage[@"isCustomClick"] boolValue];
        UIImageView *mainImageView = [[UIImageView alloc] init];
        mainImageView.userInteractionEnabled = YES;
        [self setupView:mainImageView viewInfo:mainImage];
        [adView addSubview:mainImageView];
        [nativeRenderer setMainImageView:mainImageView canClick:isCustomClick];
    }
    if(appIcon != nil)
    {
        BOOL isCustomClick = [appIcon[@"isCustomClick"] boolValue];
        UIImageView *appIconImageView = [[UIImageView alloc] init];
        appIconImageView.userInteractionEnabled = YES;
        [self setupView:appIconImageView viewInfo:appIcon];
        [adView addSubview:appIconImageView];
        [nativeRenderer setIconView:appIconImageView canClick:isCustomClick];
    }
    if(adLogo != nil)
    {
        BOOL isCustomClick = [adLogo[@"isCustomClick"] boolValue];
        UIImageView *adLogoImageView = [[UIImageView alloc] init];
        adLogoImageView.userInteractionEnabled = YES;
        [self setupView:adLogoImageView viewInfo:adLogo];
        [adView addSubview:adLogoImageView];
        [nativeRenderer setAdChoiceImageView:adLogoImageView canClick:isCustomClick];
    }
    if(mainTitle != nil)
    {
        BOOL isCustomClick = [mainTitle[@"isCustomClick"] boolValue];
        UILabel *mainTitleLabel = [[UILabel alloc] init];
        mainTitleLabel.userInteractionEnabled = YES;
        [self setupLabel:mainTitleLabel viewInfo:mainTitle];
        [adView addSubview:mainTitleLabel];
        [nativeRenderer setTitleLable:mainTitleLabel canClick:isCustomClick];
    }
    if(desc != nil)
    {
        BOOL isCustomClick = [desc[@"isCustomClick"] boolValue];
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.userInteractionEnabled = YES;
        [self setupLabel:descLabel viewInfo:desc];
        [adView addSubview:descLabel];
        [nativeRenderer setTextLable:descLabel canClick:isCustomClick];
    }
    if(cta != nil)
    {
        BOOL isCustomClick = [cta[@"isCustomClick"] boolValue];
        UILabel *ctaLabel = [[UILabel alloc] init];
        ctaLabel.userInteractionEnabled = YES;
        [self setupLabel:ctaLabel viewInfo:cta];
        [adView addSubview:ctaLabel];
        [nativeRenderer setCtaLable:ctaLabel canClick:isCustomClick];
    }
    return nativeRenderer;
}

- (void)setupLabel:(UILabel *)label viewInfo:(NSDictionary *)viewInfo
{
    [self setupView:label viewInfo:viewInfo];
    NSString *textColorStr = viewInfo[@"textColorStr"];
    if(textColorStr != nil && textColorStr.length > 0)
    {
        label.textColor = [self colorWithString:textColorStr];
    }
    NSInteger textSize = [viewInfo[@"textSize"] integerValue];
    label.font = [UIFont systemFontOfSize:textSize];
}

- (void)setupView:(UIView *)view viewInfo:(NSDictionary *)viewInfo
{
    CGFloat x = [viewInfo[@"x"] floatValue];
    CGFloat y = [viewInfo[@"y"] floatValue];
    CGFloat height = [viewInfo[@"height"] floatValue];
    CGFloat width = [viewInfo[@"width"] floatValue];
    NSString *backgroundColorStr = viewInfo[@"backgroundColorStr"];
    view.frame = CGRectMake(x, y, width, height);
    if(backgroundColorStr != nil && backgroundColorStr.length > 0)
    {
        view.backgroundColor = [self colorWithString:backgroundColorStr];
    }
}

- (UIColor *)colorWithString:(NSString *)colorStr
{
    if([colorStr isEqualToString:@"clearColor"])
    {
        return [UIColor clearColor];
    }
    colorStr = [colorStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if(colorStr.length <= 6)
    {
        return [self colorWithHexString:colorStr alpha:1];
    }
    else if(colorStr.length == 8)
    {
        NSRange range;
        range.location = 0;
        range.length = 2;
        //alpha
        NSString *aString = [colorStr substringToIndex:2];
        unsigned int a;
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        if(a == 0)
        {
            return [UIColor clearColor];
        }
        else
        {
            NSString *rgbString = [colorStr substringFromIndex:2];
            return [self colorWithHexString:rgbString alpha:((float) a / 255.0f)];
        }
    }
    return [UIColor clearColor];
}

- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha
{
    NSRange range;
    range.location = 0;
    range.length = 2;
    if(hexString.length < 6)
    {
        hexString = @"000000";
    }
    //R、G、B
    NSString *rString = [hexString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [hexString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [hexString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}
@end
