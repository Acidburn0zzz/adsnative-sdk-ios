//
//  FacebookNativeCustomEvent.m
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 08/10/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import "FacebookNativeCustomEvent.h"
#import "FacebookNativeAdAdapter.h"

static const NSInteger FacebookNoFillErrorCode = 1001;

@interface FacebookNativeCustomEvent () <FBNativeAdDelegate>

@property (nonatomic, readwrite, strong) FBNativeAd *fbNativeAd;

@end

@implementation FacebookNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    NSString *placementID = [info objectForKey:@"placementId"];
    
    if (placementID) {
        _fbNativeAd = [[FBNativeAd alloc] initWithPlacementID:placementID];
        self.fbNativeAd.delegate = self;
        [self.fbNativeAd loadAd];
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Invalid Facebook placement ID")];
    }
}

#pragma mark - FBNativeAdDelegate

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    FacebookNativeAdAdapter *adAdapter = [[FacebookNativeAdAdapter alloc] initWithFBNativeAd:nativeAd];
    ANNativeAd *interfaceAd = [[ANNativeAd alloc] initWithAdAdapter:adAdapter];
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    
    if (nativeAd.icon.url) {
        [imageURLs addObject:nativeAd.icon.url];
    }
    
    if (nativeAd.coverImage.url) {
        [imageURLs addObject:nativeAd.coverImage.url];
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

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    if (error.code == FacebookNoFillErrorCode) {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForNoFill()];
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError: AdNSErrorForInvalidAdServerResponse(@"Facebook ad load error")];
    }
}
@end
