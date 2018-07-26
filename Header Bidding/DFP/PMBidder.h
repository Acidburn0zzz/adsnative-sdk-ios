//
//  PMBidder.h
//  Sample App
//
//  Created by Arvind Bharadwaj on 13/07/18.
//  Copyright © 2018 AdsNative. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AdsNativeSDK/AdsNativeSDK.h>

@protocol PMBidderDelegate;

@interface PMBidder : NSObject <PMClassDelegate>

- (instancetype)initWithPMAdUnitID:(NSString *)adUnitID;

/** Native Ads **/
- (void)startWithAdLoader:(GADAdLoader *)gAdLoader viewController:(UIViewController *)controller;
- (void)startWithAdLoader:(GADAdLoader *)gAdLoader viewController:(UIViewController *)controller dfpRequest:(DFPRequest *)request;

/** Banner Ads **/
- (void)startWithBannerView:(DFPBannerView *)dfpBannerView viewController:(UIViewController *)controller withBannerSize:(CGSize)bannerSize;
- (void)startWithBannerView:(DFPBannerView *)dfpBannerView viewController:(UIViewController *)controller dfpRequest:(DFPRequest *)request withBannerSize:(CGSize)bannerSize;
@end
