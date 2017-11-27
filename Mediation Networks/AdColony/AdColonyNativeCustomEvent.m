//
//  AdColonyNativeCustomEvent.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 07/03/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import "AdColonyNativeCustomEvent.h"
#import "AdColonyNativeAdAdapter.h"

@interface AdColonyNativeCustomEvent() <AdColonyDelegate>

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, assign) BOOL hasReceivedAd;
@end

static int x = 0;

@implementation AdColonyNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    NSString *placementID = [info objectForKey:@"placementId"];
//    placementID = @"vz7c0765ee52af4d67b9"; //for testing
    
    if (placementID) {
        
        _viewController = [info objectForKey:@"viewController"];
        
        if (x == 0) {
            //Configure AdColony once
            NSString *appId = [info objectForKey:@"appId"];
//            appId = @"app2086517932ad4b608a"; //for testing
            [AdColony configureWithAppID:appId zoneIDs:@[placementID] delegate:self logging:YES];
            x = 1;
        } else {
            AdColonyNativeAdView *adView = [AdColony getNativeAdForZone:placementID presentingViewController:self.viewController];
            if (!adView) {
                LogInfo(@"AdColony returned an invalid ad view for zone: %@", placementID);
                
                [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Ad Request failed")];
                
                return;
            } else {
                [self adViewLoaded:adView];
            }
        }
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Invalid AdColony zone ID")];
    }
}

- (void)adViewLoaded:(AdColonyNativeAdView *)adView
{
    AdColonyNativeAdAdapter *adAdapter = [[AdColonyNativeAdAdapter alloc] initWithAdColonyNativeAdView:adView];
    
    PMNativeAd *interfaceAd = [[PMNativeAd alloc] initWithAdAdapter:adAdapter];
    
    [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
}

#pragma mark - AdColonyDelegate
- (void)onAdColonyAdAvailabilityChange:(BOOL)available inZone:(NSString *)zoneID
{
    if (!available) {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForNoFill()];
        return;
    }
    if (self.hasReceivedAd) {
        return;
    }
    self.hasReceivedAd = YES;
    //The returned ad view can be nil in some cases so we need to check that
    //we have a valid ad view before we update our data source and table view
    AdColonyNativeAdView *adView = [AdColony getNativeAdForZone:zoneID presentingViewController:self.viewController];
    if (!adView) {
        LogInfo(@"AdColony returned an invalid ad view for zone: %@", zoneID);
        
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Ad Request failed")];
        
        return;
    } else {
        [self adViewLoaded:adView];
    }
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
