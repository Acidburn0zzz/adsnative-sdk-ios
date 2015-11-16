//
//  MoPubNativeAdAdapter.h
//  Sample App
//
//  Created by Arvind Bharadwaj on 03/11/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdsNativeSDK/AdsNativeSDK.h>
#import "MoPub.h"

@interface MoPubNativeAdAdapter : NSObject <AdAdapter>

@property (nonatomic, weak) id<AdAdapterDelegate> delegate;

- (instancetype)initWithMPNativeAd:(MPNativeAd *)fbNativeAd;

@end
