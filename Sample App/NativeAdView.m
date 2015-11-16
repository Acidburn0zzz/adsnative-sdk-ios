//
//  NativeAdView.m
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 16/10/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "NativeAdView.h"
#import <CoreGraphics/CoreGraphics.h>
@implementation NativeAdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutAdAssets:(ANNativeAd *)adObject
{
    [adObject loadTitleIntoLabel:self.adtitle];
    [adObject loadTextIntoLabel:self.summary];
    [adObject loadCallToActionTextIntoButton:self.cta];
    [adObject loadIconIntoImageView:self.iconImage];
    [adObject loadSponsoredTagIntoLabel:self.sponsoredText];

    //For video ads in place of main image
    UIView *mediaView = [adObject.nativeAssets objectForKey:kNativeMediaViewKey];
    if (mediaView != nil) {
        mediaView.frame = self.mainImage.frame;
        [self addSubview:mediaView];
    } else {
        [adObject loadImageIntoImageView:self.mainImage];
    }
}

// You MUST implement this method if YourNativeAdCell uses a nib
+ (NSString *)nibForAd
{
    return @"NativeAdView";
}
@end
