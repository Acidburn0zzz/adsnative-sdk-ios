//
//  MoPubNativeCustomEvent.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 03/11/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "MoPubNativeCustomEvent.h"
#import "MoPubNativeAdAdapter.h"
#import "MoPubHiddenView.h"

@interface MoPubNativeCustomEvent()

@property (strong, nonatomic) MPNativeAd *nativeAd;
@end

@implementation MoPubNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    NSString *placementID = [info objectForKey:@"placementId"];
    
    if (placementID) {
        
        MPStaticNativeAdRendererSettings *settings = [[MPStaticNativeAdRendererSettings alloc] init];
        settings.renderingViewClass = [MoPubHiddenView class];
        
        MPNativeAdRendererConfiguration *config = [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:settings];
        
        MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:placementID rendererConfigurations:@[config]];

        [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
            if (error) {
                // Handle error.
                [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Ad Request failed")];
            } else {
                self.nativeAd = response;
                
                MoPubNativeAdAdapter *adAdapter = [[MoPubNativeAdAdapter alloc] initWithMPNativeAd:response];
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
        }];
        
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Invalid MoPub placement ID")];
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
