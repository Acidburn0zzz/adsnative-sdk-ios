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

#pragma mark - Init for Native Ads
- (instancetype)initWithPMAdUnitID:(NSString *)adUnitID viewController:(UIViewController *)controller requestType:(PM_REQUEST_TYPE)requestType;

#pragma mark - Init for Banner and Native-Banner Ads
- (instancetype)initWithPMAdUnitID:(NSString *)adUnitID viewController:(UIViewController *)controller requestType:(PM_REQUEST_TYPE)requestType withBannerSize:(CGSize)bannerSize;

#pragma mark - Native and Native-Banner Ad Call
- (void)startWithAdLoader:(GADAdLoader *)gAdLoader;
- (void)startWithAdLoader:(GADAdLoader *)gAdLoader dfpRequest:(DFPRequest *)request;

#pragma mark - Banner Ad Call
- (void)startWithBannerView:(DFPBannerView *)dfpBannerView;
- (void)startWithBannerView:(DFPBannerView *)dfpBannerView dfpRequest:(DFPRequest *)request;

@end
