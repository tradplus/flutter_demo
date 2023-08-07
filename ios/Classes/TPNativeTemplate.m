

#import "TPNativeTemplate.h"

@interface TPNativeTemplate()

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

- (UIImageView *)nativeMainImageView
{
    return self.imageView;
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
    NSBundle *resourceBundle = [NSBundle bundleForClass:self];
    return [UINib nibWithNibName:@"TPNativeTemplate" bundle:resourceBundle];
}
@end
