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

- (void)layoutAdAssets:(ANNativeAd *)adObject
{
    [adObject loadTitleIntoLabel:self.adtitle];
    [adObject loadTextIntoLabel:self.summary];
    [adObject loadCallToActionTextIntoButton:self.cta];
    [adObject loadIconIntoImageView:self.iconImage];
    [adObject loadSponsoredTagIntoLabel:self.sponsoredText];
    //For video ads
    [adObject loadMediaIntoView:self.mediaView];
    
    //Optional: some third party sdks mandate it
    [adObject loadAdChoicesIconIntoView:self.adChoicesView];

}

// You MUST implement this method if YourNativeAdCell uses a nib
+ (NSString *)nibForAd
{
    return @"NativeAdView";
}
@end
