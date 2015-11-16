//
//  InMobiNativeCustomEvent.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 07/10/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdsNativeSDK/AdsNativeSDK.h>

@interface InMobiNativeCustomEvent : CustomEvent

/**
 * Registers an InMobi app ID to be used when making ad requests.
 *
 * When making ad requests, the InMobi SDK requires you to provide your app ID. When
 * integrating InMobi using a MoPub custom event, this ID is typically configured via your
 * InMobi network settings on the MoPub website. However, if you wish, you may use this method to
 * manually provide the custom event with your ID.
 */
+ (void)setAppId:(NSString *)appId;

@end
