//
//  ShareThroughNativeAdAdapter.h
//
//  Created by Arvind Bharadwaj on 06/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SharethroughSDK/SharethroughSDK.h>
#import <AdsNativeSDK/AdsNativeSDK.h>


@interface ShareThroughNativeAdAdapter : NSObject  <AdAdapter>

@property (nonatomic, weak) id<AdAdapterDelegate> delegate;

- (instancetype)initWithSTRNativeAd:(STRAdvertisement *)strNativeAd andSTRSDK:(SharethroughSDK *)sdk withPlacementId:(NSString *)placementId;

@end
