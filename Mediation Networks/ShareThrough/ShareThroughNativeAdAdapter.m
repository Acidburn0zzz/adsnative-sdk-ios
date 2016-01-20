//
//  ShareThroughNativeAdAdapter.m
//
//  Created by Arvind Bharadwaj on 06/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import "ShareThroughNativeAdAdapter.h"
#import "STRAdHiddenView.h"
#import <AdsNativeSDK/AdsNativeSDK.h>
#import <SharethroughSDK/STRAdvertisementDelegate.h>

@interface ShareThroughNativeAdAdapter () <STRAdViewDelegate, STRAdvertisementDelegate>

@property (nonatomic, strong) SharethroughSDK *sdk;
@property (nonatomic, strong) NSString *placementId;

@property (nonatomic, strong) STRAdHiddenView *strAdView;
@property (nonatomic, strong) UIView *adView;

@property (nonatomic, strong) UIButton *disclosureButton;

@property (nonatomic, readwrite, strong) STRAdvertisement *strNativeAd;

@end

@implementation ShareThroughNativeAdAdapter

@synthesize nativeAssets = _nativeAssets;
@synthesize defaultClickThroughURL = _defaultClickThroughURL;
@synthesize isBackupClassRequired = _isBackupClassRequired;

- (instancetype)initWithSTRNativeAd:(STRAdvertisement *)strNativeAd andSTRSDK:(SharethroughSDK *)sdk withPlacementId:(NSString *)placementId
{
    if (self = [super init]) {
        self.sdk = sdk;
        self.placementId = placementId;
        
        self.strAdView = [[STRAdHiddenView alloc] init];
        
        NSMutableDictionary *nativeAssets = [NSMutableDictionary dictionary];
        
        if (strNativeAd.title != nil) {
            [nativeAssets setObject:strNativeAd.title forKey:kNativeTitleKey];
        }
        if (strNativeAd.adDescription != nil) {
            [nativeAssets setObject:strNativeAd.adDescription forKey:kNativeTextKey];
        }
        if ([strNativeAd.thumbnailURL absoluteString] != nil) {
            [nativeAssets setObject:[strNativeAd.thumbnailURL absoluteString] forKey:kNativeMainImageKey];
        }
        if ([strNativeAd.brandLogoURL absoluteString] != nil) {
            [nativeAssets setObject:[strNativeAd.brandLogoURL absoluteString] forKey:kNativeIconImageKey];
        }
        if (strNativeAd.advertiser != nil) {
            [nativeAssets setObject:strNativeAd.advertiser forKey:kNativeSponsoredKey];
        }
        
        //setting the disclosure button temporarily. It will be filled later
        [nativeAssets setObject:self.strAdView.disclosureButton forKey:kNativeAdChoicesKey];
        
        _nativeAssets = nativeAssets;
        
        self.strNativeAd = strNativeAd;
        self.strNativeAd.delegate = self;
    }
    return self;
}

#pragma mark - AdAdapter
- (BOOL)isMediaView
{
    return YES;
}

- (NSTimeInterval)requiredSecondsForImpression
{
    return 0.0;
}

- (NSURL *)defaultClickThroughURL
{
    return nil;
}

- (BOOL)enableThirdPartyClickTracking
{
    return YES;
}

- (BOOL)enableThirdPartyImpressionTracking
{
    return YES;
}

- (void)willAttachToView:(UIView *)view
{
    self.adView = view;
    //This call will never fail as ad has already been prefetched
    [self.sdk placeAdInView:self.strAdView placementKey:self.placementId presentingViewController:[self.delegate viewControllerToPresentModalView] index:0 delegate:self];
}

#pragma mark - STRAdvertisementDelegate
- (void)adWillLogImpression:(STRAdvertisement *)StrAd
{
    LogDebug(@"Tracking ShareThrough Impression for ShareThrough Ad");
    
    if ([self.delegate respondsToSelector:@selector(nativeAdWillLogImpression:)]) {
        [self.delegate nativeAdWillLogImpression:self];
    } else {
        LogWarn(@"Delegate does not implement impression tracking callback. Impressions likely not being tracked.");
    }
}

- (void)adDidClick:(STRAdvertisement *)StrAd
{
    LogDebug(@"Tracking ShareThrough Click for ShareThrough Ad");
    
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    } else {
        LogWarn(@"Delegate does not implement click tracking callback. Clicks likely not being tracked.");
    }
}

#pragma mark - STRAdViewDelegate
- (void)adView:(id<STRAdView>)adView didFetchAd:(STRAdvertisement*)ad ForPlacementKey:(NSString *)placementKey atIndex:(NSInteger)adIndex
{
    self.strNativeAd = ad;
    self.strNativeAd.delegate = self;
    
    self.strAdView = (STRAdHiddenView *)adView;
    self.strAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //The first subview is the content view (be it single native ad or stream ads)
    //Adding ShareThrough's ad view as the content views' subview
    for (UIView *v in [self.adView subviews]) {
        self.strAdView.frame = v.bounds;
        [v addSubview:self.strAdView];
        break;
    }
    if ([self.adView subviews] == nil) {
        self.strAdView.frame = self.adView.bounds;
        [self.adView addSubview:self.strAdView];
    }
    
}
@end
