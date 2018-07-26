//
//  PolymorphDFPBannerCustomEvent.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 24/07/18.
//  Copyright © 2018 AdsNative. All rights reserved.
//

#import "PolymorphDFPBannerCustomEvent.h"

@interface PolymorphDFPBannerCustomEvent() <PMBannerViewDelegate>

@property (nonatomic, strong) PMNativeAd *pmNativeAd;

@end

@implementation PolymorphDFPBannerCustomEvent

- (void)requestBannerAd:(GADAdSize)adSize parameter:(NSString * _Nullable)serverParameter label:(NSString * _Nullable)serverLabel request:(nonnull GADCustomEventRequest *)request {
    PMBannerView *cachedAd = [[PMPrefetchAds getInstance] getBannerAd];
    cachedAd.delegate = self;
    if (cachedAd != nil) {
        [self adViewDidLoadAd:cachedAd];
        
    } else {
        //if cached ad not present, then move on
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"no cached Polymorph ad found" forKey:NSLocalizedDescriptionKey];
        [self.delegate customEventBanner:self didFailAd:[NSError errorWithDomain:@"Polymorph" code:204 userInfo:details]];
    }
}


- (UIViewController *)viewControllerToPresentAdModalView; {
    return self.delegate.viewControllerForPresentingModalView;
}

- (void)adViewDidLoadAd:(PMBannerView *)adView
{
    [self.delegate customEventBanner:self didReceiveAd:adView];
}

- (void)adViewDidFailToLoadAd:(PMBannerView *)view error:(NSError *)error
{
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)willLeaveApplicationFromAd:(PMBannerView *)view
{
    [self.delegate customEventBannerWasClicked:self];
    [self.delegate customEventBannerWillLeaveApplication:self];
}

@end
