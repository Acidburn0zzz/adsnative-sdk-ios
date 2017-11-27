//
//  ShareThroughNativeAdAdapter.h
//
//  Created by Arvind Bharadwaj on 06/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SharethroughSDK/SharethroughSDK.h>
#import "STRAdHiddenView.h"
//#import <AdsNativeSDK/AdsNativeSDK.h>
#import "AdAdapter.h"
#import "AdAssets.h"
#import "AdAdapterDelegate.h"
#import "Logging.h"

@interface ShareThroughNativeAdAdapter : NSObject  <AdAdapter>

@property (nonatomic, weak) id<AdAdapterDelegate> delegate;

- (instancetype)initWithSTRNativeAd:(STRAdvertisement *)strNativeAd andSTRSDK:(SharethroughSDK *)sdk withPlacementId:(NSString *)placementId;

@end
