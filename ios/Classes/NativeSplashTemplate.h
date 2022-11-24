//
//  NativeSplashTemplate.h
//  TradPlusAds
//
//  Created by xuejun on 2021/8/9.
//  Copyright © 2021 ms-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeSplashTemplate : UIView

@property (nonatomic,weak)IBOutlet UIImageView *mainImageView;
@property (nonatomic,weak)IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak)IBOutlet UIImageView *adChoiceImageView;
@property (nonatomic,weak)IBOutlet UILabel *titleLabel;
@property (nonatomic,weak)IBOutlet UILabel *textLabel;
@property (nonatomic,weak)IBOutlet UILabel *ctaLabel;
@end

NS_ASSUME_NONNULL_END
