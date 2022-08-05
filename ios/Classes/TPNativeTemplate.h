

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPNativeTemplate : UIView

@property (nonatomic,weak)IBOutlet UIView *mainView;
@property (nonatomic,weak)IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak)IBOutlet UIImageView *adChoiceImageView;
@property (nonatomic,weak)IBOutlet UILabel *titleLabel;
@property (nonatomic,weak)IBOutlet UILabel *textLabel;
@property (nonatomic,weak)IBOutlet UILabel *ctaLabel;
@end

NS_ASSUME_NONNULL_END
