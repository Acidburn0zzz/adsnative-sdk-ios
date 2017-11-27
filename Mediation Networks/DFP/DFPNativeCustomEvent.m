//
//  DFPNativeCustomEvent.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 08/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import "DFPNativeCustomEvent.h"
#import "DFPNativeAdAdapter.h"

@interface DFPNativeCustomEvent () <GADAdLoaderDelegate,GADNativeAppInstallAdLoaderDelegate,GADNativeContentAdLoaderDelegate>

@property (nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation DFPNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    NSString *placementID = [info objectForKey:@"placementId"];
    
    /* PlacementId used for testing*/
    placementID = @"/6499/example/native";
    
    if (placementID) {
        self.viewController = (UIViewController *)[info objectForKey:@"viewController"];
        
        GADNativeAdImageAdLoaderOptions *options = [[GADNativeAdImageAdLoaderOptions alloc] init];
        options.disableImageLoading = YES;
        options.shouldRequestMultipleImages = NO;
        
        self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:placementID rootViewController:self.viewController adTypes:@[kGADAdLoaderAdTypeNativeAppInstall,kGADAdLoaderAdTypeNativeContent] options:@[options]];
        self.adLoader.delegate = self;
        
        [self.adLoader loadRequest:[DFPRequest request]];
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Invalid DFP placement ID")];
    }
}

- (void)adLoadedWithInterfaceAd:(ANNativeAd *)interfaceAd
{
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
#pragma mark - GADLoaderDelegate
- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: error];
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd
{
    DFPNativeAdAdapter *adAdapter = [[DFPNativeAdAdapter alloc] initWithDFPNativeAd:nativeAppInstallAd];
    PMNativeAd *interfaceAd = [[PMNativeAd alloc] initWithAdAdapter:adAdapter];
    [self adLoadedWithInterfaceAd:interfaceAd];
    
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd
{
    DFPNativeAdAdapter *adAdapter = [[DFPNativeAdAdapter alloc] initWithDFPNativeAd:nativeContentAd];
    ANNativeAd *interfaceAd = [[ANNativeAd alloc] initWithAdAdapter:adAdapter];
    [self adLoadedWithInterfaceAd:interfaceAd];
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
