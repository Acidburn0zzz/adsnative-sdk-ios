//
//  MoPubNativeAdView.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 31/07/17.
//  Copyright © 2017 AdsNative. All rights reserved.
//

#import "MoPubNativeAdView.h"

@implementation MoPubNativeAdView

- (void)layoutSubviews
{
    [super layoutSubviews];
    // layout your views
}

- (UILabel *)nativeMainTextLabel
{
    return self.mainTextLabel;
}

- (UILabel *)nativeTitleTextLabel
{
    return self.titleLabel;
}

- (UILabel *)nativeCallToActionTextLabel
{
    return self.callToActionLabel;
}

- (UIImageView *)nativeIconImageView
{
    return self.iconImageView;
}

- (UIImageView *)nativeMainImageView
{
    return self.mainImageView;
}

- (UIImageView *)nativePrivacyInformationIconImageView
{
    return self.privacyInformationIconImageView;
}

+ (UINib *)nibForAd
{
    return [UINib nibWithNibName:@"MoPubNativeAdView" bundle:nil];
}

@end
