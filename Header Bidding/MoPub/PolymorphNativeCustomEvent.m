//
//  PolymorphNativeAdNetwork.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 01/08/17.
//  Copyright © 2017 AdsNative. All rights reserved.
//

#import "PolymorphNativeCustomEvent.h"
#import "PolymorphNativeAdAdapter.h"

NSString *const kPolymorphPlacementID = @"placementId";

@interface PolymorphNativeCustomEvent() <ANNativeAdDelegate>

@property (nonatomic, strong) PMNativeAd *pmNativeAd;

@end


@implementation PolymorphNativeCustomEvent

- (void) requestAdWithCustomEventInfo:(NSDictionary *)info
{
    NSString *adUnitID = [info objectForKey:kPolymorphPlacementID];
    //adUnitID = @"ping";
    if (!adUnitID) {
        MPLogError(@"Failed native ad fetch. Missing required server extras [Polymorph Placement ID]");
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:[NSError errorWithDomain:MoPubNativeAdsSDKDomain code:MPNativeAdErrorInvalidServerResponse userInfo:nil]];
        return;
    } else {
        MPLogInfo(@"Server info fetched from MoPub for Polymorph. Placement ID: %@.", adUnitID);
    }
    
    PMNativeAd *cachedAd = [[PMPrefetchAds getInstance] getAd];
    if (cachedAd != nil) {
        [self anNativeAdDidLoad:cachedAd];
        
    } else {
        self.pmNativeAd = [[PMNativeAd alloc] initWithAdUnitId:adUnitID];
        self.pmNativeAd.delegate = self;
        [self.pmNativeAd loadAd];
    }
}

#pragma mark - <ANNativeAdDelegate>
- (void)anNativeAdDidLoad:(PMNativeAd *)nativeAd
{
    PolymorphNativeAdAdapter *adAdapter = [[PolymorphNativeAdAdapter alloc] initWithPMNativeAd:nativeAd];
    
    MPNativeAd *interfaceAd = [[MPNativeAd alloc] initWithAdAdapter:adAdapter];
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    
    if ([nativeAd.nativeAssets objectForKey:kNativeMainImageKey]) {
        [imageURLs addObject:[NSURL URLWithString:[nativeAd.nativeAssets objectForKey:kNativeMainImageKey]]];
    }
    
    if ([nativeAd.nativeAssets objectForKey:kNativeIconImageKey]) {
        [imageURLs addObject:[NSURL URLWithString:[nativeAd.nativeAssets objectForKey:kNativeIconImageKey]]];
    }
    
    [super precacheImagesWithURLs:imageURLs completionBlock:^(NSArray *errors) {
        if (errors) {
            MPLogDebug(@"%@", errors);
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:MPNativeAdNSErrorForImageDownloadFailure()];
        } else {
            [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
        }
    }];
}

- (void)anNativeAd:(PMNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    MPLogDebug(@"Polymorph failed to load with error: %@", error.description);
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
}

@end
