//
//  ANNativeAdDelegate.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 20/10/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//


@class ANNativeAd;
/**
 * This is the delegate of an `ANNativeAd` object must adopt the `ANNativeAdDelegate` protocol. It must
 * implement `nativeAdDidLoad` and `nativeAd:didFailWithError:` methods.
 * This protocol is to be implemented by the app developer for ad request callbacks. 
 *
 * It is used for implementing single native ad requests and can be ignore for stream content.
 */
@protocol ANNativeAdDelegate <NSObject>

@required

/**
 * Tells the delegate when a native ad request has succeeded
 *
 * @param nativeAd: The `ANNativeAd` object containing the ad response
 */
- (void)nativeAdDidLoad:(ANNativeAd *)nativeAd;

/**
 * Tells the delegate when a native ad request has failed
 *
 * @param nativeAd: Will be nil in this case
 * @param error: An error describing the failure.
 */
- (void)nativeAd:(ANNativeAd *)nativeAd didFailWithError:(NSError *)error;

@optional

/**
 * Tells the delegate when an impression for a native ad has been recorded
 */
- (void) nativeAdDidRecordImpression;

/**
 * Tells the delegate when a click for a native ad has been recorded
 */
- (void) nativeAdDidClick;

@end
