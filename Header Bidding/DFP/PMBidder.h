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
- (void)startWithAdLoader:(GADAdLoader *)gAdLoader viewController:(UIViewController *)controller;

@end