//
//  FlurryNativeCustomEvent.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 05/11/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "FlurryNativeCustomEvent.h"
#import "FlurryAdNativeDelegate.h"
#import "FlurryAdNative.h"
#import "FlurryNativeAdAdapter.h"
#import "Flurry.h"

@interface FlurryNativeCustomEvent () <FlurryAdNativeDelegate>

@property (nonatomic,strong) FlurryAdNative *flurryNativeAd;

@end

NSString *sessionId;

@implementation FlurryNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    if (sessionId == nil) {
        sessionId = [info objectForKey:@"flurryApiKey"];
        
        if (!sessionId) {
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Invalid Flurry API KEY")];
        }
        [Flurry startSession:sessionId];
    }
    
    NSString *placementID = [info objectForKey:@"placementId"];
    
    if (placementID) {
        
        _flurryNativeAd = [[FlurryAdNative alloc] initWithSpace:placementID];
        
        _flurryNativeAd.adDelegate = self;
       
        [_flurryNativeAd fetchAd];
        
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Invalid Flurry placement ID")];
    }
}

#pragma mark - FlurryAdNativeDelegate

- (void) adNativeDidFetchAd:(FlurryAdNative*) nativeAd
{
    FlurryNativeAdAdapter *adAdapter = [[FlurryNativeAdAdapter alloc] initWithFlurryNativeAd:nativeAd];
 
    ANNativeAd *interfaceAd = [[ANNativeAd alloc] initWithAdAdapter:adAdapter];
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    
    if ([interfaceAd.nativeAssets objectForKey:kNativeMainImageKey]) {
        NSString *mainImage =[interfaceAd.nativeAssets objectForKey:kNativeMainImageKey];
        [imageURLs addObject:[NSURL URLWithString:[mainImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    if ([interfaceAd.nativeAssets objectForKey:kNativeIconImageKey]) {
        NSString *iconImage =[interfaceAd.nativeAssets objectForKey:kNativeIconImageKey];
        [imageURLs addObject:[NSURL URLWithString:[iconImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    [super precacheImagesWithURLs:imageURLs completionBlock:^(NSArray *errors) {
        if (errors) {
            LogDebug(@"%@", errors);
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForImageDownloadFailure()];
        } else {
            [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
        }
    }];

}

- (void) adNative:(FlurryAdNative*) nativeAd adError:(FlurryAdError) adError errorDescription:(NSError*) errorDescription
{
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: errorDescription];
}
@end
