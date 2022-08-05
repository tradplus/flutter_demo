

#import "TPNativeTemplate.h"
#import <TradPlusAds/TradPlusNativeAdRendering.h>

@interface TPNativeTemplate()<TradPlusNativeAdRendering>

@end

@implementation TPNativeTemplate

- (UILabel *)nativeTitleTextLabel
{
    return self.titleLabel;
}

- (UILabel *)nativeMainTextLabel
{
    return self.textLabel;
}

- (UIImageView *)nativeIconImageView
{
    return self.iconImageView;
}

- (UIView *)nativeMediaView
{
    return self.mainView;
}

- (UILabel *)nativeCallToActionTextLabel
{
    return self.ctaLabel;
}

- (UIImageView *)nativePrivacyInformationIconImageView
{
    return self.adChoiceImageView;
}

+ (UINib *)nibForAd
{
    return [UINib nibWithNibName:@"TPNativeTemplate" bundle:nil];
}
@end
