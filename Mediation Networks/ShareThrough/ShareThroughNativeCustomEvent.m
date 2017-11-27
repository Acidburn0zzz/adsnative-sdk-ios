//
//  ShareThroughNativeCustomEvent.m
//
//  Created by Arvind Bharadwaj on 06/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import "ShareThroughNativeCustomEvent.h"
#import "ShareThroughNativeAdAdapter.h"
#import "STRAdHiddenView.h"

@interface ShareThroughNativeCustomEvent () <STRAdViewDelegate>

@property (nonatomic, readwrite, strong) STRAdvertisement *strNativeAd;
@property (nonatomic, strong) SharethroughSDK *sdk;
@property (nonatomic, strong) NSString *placementId;
@end

@implementation ShareThroughNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    NSString *placementID = [info objectForKey:@"placementId"];

    /* May be used to testing */
//    placementID = @"c1a0a591";
    
    _placementId = placementID;
    
    if (placementID) {
//        self.sdk = [SharethroughSDK sharedTestSafeInstanceWithAdType:STRFakeAdTypeYoutube];
        self.sdk = [SharethroughSDK sharedInstance];
        
        //Clearing all cached ads
//        [self.sdk clearCachedAdsForPlacement:self.placementId];
        
        [self.sdk prefetchAdForPlacementKey:placementID customProperties:nil delegate:self];
        
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Invalid ShareThrough placement ID")];
    }
}

#pragma mark - STRAdViewDelegate
- (void)didPrefetchAdvertisement:(STRAdvertisement *)strAd {
    
    ShareThroughNativeAdAdapter *adAdapter = [[ShareThroughNativeAdAdapter alloc] initWithSTRNativeAd:strAd andSTRSDK:self.sdk withPlacementId:self.placementId];
    
    PMNativeAd *interfaceAd = [[PMNativeAd alloc] initWithAdAdapter:adAdapter];

    [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
}

- (void)didFailToPrefetchForPlacementKey:(NSString *)placementKey
{
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForNoFill()];
}
@end
