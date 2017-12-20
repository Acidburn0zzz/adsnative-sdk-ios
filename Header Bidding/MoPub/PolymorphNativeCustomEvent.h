//
//  PolymorphNativeAdNetwork.h
//  Sample App
//
//  Created by Arvind Bharadwaj on 01/08/17.
//  Copyright © 2017 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#else
#import "MPNativeCustomEvent.h"
#import "MPLogging.h"
#import "MPNativeAdError.h"
#import "MPNativeAd.h"

#endif

#import <AdsNativeSDK/AdsNativeSDK.h>

@interface PolymorphNativeCustomEvent : MPNativeCustomEvent

@end
