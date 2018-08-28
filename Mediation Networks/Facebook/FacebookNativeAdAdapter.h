//
//  FacebookNativeAdAdapter.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 08/10/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <AdsNativeSDK/AdsNativeSDK.h>

@class FBNativeAd;

@interface FacebookNativeAdAdapter : NSObject <AdAdapter>

@property (nonatomic, weak) id<AdAdapterDelegate> delegate;

- (instancetype)initWithFBNativeAd:(FBNativeAd *)fbNativeAd withInfo:(NSDictionary *)info;

@end
