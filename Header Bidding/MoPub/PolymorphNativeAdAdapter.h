//
//  PolymorphNativeAdAdapter.h
//  Sample App
//
//  Created by Arvind Bharadwaj on 01/08/17.
//  Copyright © 2017 AdsNative. All rights reserved.
//

#import <AdsNativeSDK/AdsNativeSDK.h>

#import "MPNativeAdAdapter.h"
#import "MPNativeAdConstants.h"
#import "MPAdDestinationDisplayAgent.h"
#import "MPCoreInstanceProvider.h"
#import "MPLogging.h"
#import "MPStaticNativeAdImpressionTimer.h"


@class ANNativeAd;
@class MPAdConfiguration;

@interface PolymorphNativeAdAdapter : NSObject <MPNativeAdAdapter>

@property (nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;
@property (nonatomic) MPAdConfiguration *adConfiguration;

- (instancetype)initWithPMNativeAd:(ANNativeAd *)nativeAd;


@end
