//
//  FlurryNativeAdAdapter.h
//  Sample App
//
//  Created by Arvind Bharadwaj on 05/11/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdsNativeSDK/AdsNativeSDK.h>
#import "FlurryAdNative.h"

@interface FlurryNativeAdAdapter : NSObject <AdAdapter>

@property (nonatomic, weak) id<AdAdapterDelegate> delegate;

- (instancetype)initWithFlurryNativeAd:(FlurryAdNative *)flurryNativeAd;

@end
