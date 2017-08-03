//
//  PMBidder.h
//  Sample App
//
//  Created by Arvind Bharadwaj on 31/07/17.
//  Copyright © 2017 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AdsNativeSDK/AdsNativeSDK.h>

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#else
#import "MPNativeAdRequest.h"
#import "MPNativeAd.h"
#import "MPNativeAdRequestTargeting.h"
#endif


@interface PMBidder : NSObject <ANNativeAdDelegate>

- (instancetype)initWithPMAdUnitID:(NSString *)adUnitID;
- (void)startWithAdRequest:(MPNativeAdRequest *)mpNativeAdRequest viewController:(UIViewController *)controller completionHandler:(MPNativeAdRequestHandler)handler;
@end
