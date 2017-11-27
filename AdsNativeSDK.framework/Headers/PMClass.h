//
//  PMClass.h
//
//  Created by Arvind Bharadwaj on 15/11/17.
//  Copyright © 2017 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ANAdRequestTargeting.h"
#import "Constants.h"

@protocol PMClassDelegate;
@class PMNativeAd;
@class PMBannerView;

@interface PMClass : NSObject

@property (nonatomic, weak) id<PMClassDelegate> delegate;
@property (nonatomic, strong) NSString *adUnitID;

/*
 * default requestType is REQUEST_TYPE_NATIVE. 
 * If request type is REQUEST_TYPE_BANNER or REQUEST_TYPE_ALL, then size needs to be passed
 */
- (instancetype)initWithAdUnitID:(NSString *)adUnitId requestType:(PM_REQUEST_TYPE)requestType withBannerSize:(CGSize)size;
- (void)loadPMAd;
- (void)loadPMAdWithTargeting:(ANAdRequestTargeting *)targeting;

#pragma mark - PM_REQUEST_TYPE_BANNER ONLY
/* The following methods are for banner requests only. It will be ignored if the request type is not PM_REQUEST_TYPE_BANNER */
/**
 * Stops the ad view from periodically loading new advertisements.
 *
 * By default, an ad view is allowed to automatically load new advertisements if a refresh interval
 * has been configured on the Polymorph website. This method prevents new ads from automatically loading,
 * even if a refresh interval has been specified.
 *
 * As a best practice, you should call this method whenever the ad view will be hidden from the user
 * for any period of time, in order to avoid unnecessary ad requests. You can then call
 * `startAutomaticallyRefreshingContents` to re-enable the refresh behavior when the ad view becomes
 * visible.
 *
 * @see startAutomaticallyRefreshingContents
 */
- (void)stopAutomaticallyRefreshingContents;

/**
 * Causes the ad view to periodically load new advertisements in accordance with user-defined
 * refresh settings on the Polymorph website.
 *
 * Calling this method is only necessary if you have previously stopped the ad view's refresh
 * behavior using `stopAutomaticallyRefreshingContents`. By default, an ad view is allowed to
 * automatically load new advertisements if a refresh interval has been configured on the Polymorph
 * website. This method has no effect if a refresh interval has not been set.
 *
 * @see stopAutomaticallyRefreshingContents
 */
- (void)startAutomaticallyRefreshingContents;

/**
 * Cancels any existing ad requests and requests a new ad from the Polymorph ad server.
 */
- (void)forceRefreshAd;
@end


@protocol PMClassDelegate <NSObject>

@required
- (UIViewController *)pmViewControllerForPresentingModalView;

@optional
/*
 * The following methods are conditionally mandatory. If the request type is PM_REQUEST_TYPE_NATIVE,
 * then the banner methods can be ignored and vice-versa.
 */

/* Banner Methods */
/* @required if request type is anything but PM_REQUEST_TYPE_NATIVE */
- (void)pmBannerAdDidLoad:(PMBannerView *)adView;
- (void)pmBannerAdDidFailToLoad:(PMBannerView *)view withError:(NSError *)error;
/* optional */
- (void)pmWillLeaveApplicationFromBannerAd:(PMBannerView *)view;

/* Native Methods */
/* @required if request type is anything but PM_REQUEST_TYPE_BANNER */
- (void)pmNativeAdDidLoad:(PMNativeAd *)nativeAd;
- (void)pmNativeAd:(PMNativeAd *)nativeAd didFailWithError:(NSError *)error;
/* optional */
- (void)pmNativeAdDidRecordImpression;
- (BOOL)pmNativeAdDidClick:(PMNativeAd *)nativeAd;

@end
