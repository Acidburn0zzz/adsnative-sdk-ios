//
//  AdColonyNativeAdAdapter.h
//  Sample App
//
//  Created by Arvind Bharadwaj on 07/03/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdColony/AdColony.h>
#import <AdColony/AdColonyNativeAdView.h>
#import <AdsNativeSDK/AdsNativeSDK.h>
//#import "AdAdapter.h"
//#import "AdAssets.h"
//#import "AdAdapterDelegate.h"
//#import "Logging.h"
//#import "AdErrors.h"

@interface AdColonyNativeAdAdapter : NSObject <AdAdapter>

@property (nonatomic, weak) id<AdAdapterDelegate> delegate;

- (instancetype)initWithAdColonyNativeAdView:(AdColonyNativeAdView *)adColonyNativeAdView;

@end
