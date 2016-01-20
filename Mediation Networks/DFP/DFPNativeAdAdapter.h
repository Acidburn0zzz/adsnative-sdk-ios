//
//  DFPNativeAdAdapter.h
//  Sample App
//
//  Created by Arvind Bharadwaj on 08/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import <AdsNativeSDK/AdsNativeSDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface DFPNativeAdAdapter : NSObject <AdAdapter>

@property (nonatomic, weak) id<AdAdapterDelegate> delegate;

- (instancetype)initWithDFPNativeAd:(GADNativeAd *)dfpNativeAd;

@end
