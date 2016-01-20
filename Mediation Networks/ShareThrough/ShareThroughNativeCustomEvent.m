//
//  ShareThroughNativeCustomEvent.m
//
//  Created by Arvind Bharadwaj on 06/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import "ShareThroughNativeCustomEvent.h"
#import "ShareThroughNativeAdAdapter.h"

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
//    placementID = @"e7244b42";
    
    _placementId = placementID;
    
    if (placementID) {
        self.sdk = [SharethroughSDK sharedInstance];
        //Clearing all cached ads
        [self.sdk clearCachedAdsForPlacement:self.placementId];
        
        [self.sdk prefetchAdForPlacementKey:placementID delegate:self];
        
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Invalid ShareThrough placement ID")];
    }
}

#pragma mark - STRAdViewDelegate
- (void)didPrefetchAdvertisement:(STRAdvertisement *)strAd {
    
    ShareThroughNativeAdAdapter *adAdapter = [[ShareThroughNativeAdAdapter alloc] initWithSTRNativeAd:strAd andSTRSDK:self.sdk withPlacementId:self.placementId];
    
    ANNativeAd *interfaceAd = [[ANNativeAd alloc] initWithAdAdapter:adAdapter];
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    
    if ([[interfaceAd.nativeAssets objectForKey:kNativeIconImageKey] length]) {
        if (![self addURLString:[interfaceAd.nativeAssets objectForKey:kNativeIconImageKey] toURLArray:imageURLs]) {
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForInvalidImageURL()];
        }
    }
    
    if ([[interfaceAd.nativeAssets objectForKey:kNativeMainImageKey] length]) {
        if (![self addURLString:[interfaceAd.nativeAssets objectForKey:kNativeMainImageKey] toURLArray:imageURLs]) {
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForInvalidImageURL()];
        }
    }
    
    [super precacheImagesWithURLs:imageURLs completionBlock:^(NSArray *errors) {
        if (errors) {
            LogDebug(@"%@", errors);
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForImageDownloadFailure()];
        } else {
            [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
        }
    }];
    
}

- (void)didFailToPrefetchForPlacementKey:(NSString *)placementKey
{
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForNoFill()];
}

#pragma mark - helper
- (BOOL)addURLString:(NSString *)urlString toURLArray:(NSMutableArray *)urlArray
{
    if (urlString.length == 0) {
        return NO;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        [urlArray addObject:url];
        return YES;
    } else {
        return NO;
    }
}
@end
