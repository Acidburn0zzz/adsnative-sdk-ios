//
//  ShareThroughNativeAdAdapter.m
//
//  Created by Arvind Bharadwaj on 06/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import "ShareThroughNativeAdAdapter.h"
#import "STRAdHiddenView.h"
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
        
        [self populateNativeAssetsUsingStrAd:strNativeAd];
        
        self.strNativeAd = strNativeAd;
        self.strNativeAd.delegate = self;
    }
    return self;
}

- (void)populateNativeAssetsUsingStrAd:(STRAdvertisement *)strNativeAd {
    NSMutableDictionary *nativeAssets = [NSMutableDictionary dictionary];
    
    if (strNativeAd.title != nil) {
        [nativeAssets setObject:strNativeAd.title forKey:kNativeTitleKey];
    }
    if (strNativeAd.adDescription != nil) {
        [nativeAssets setObject:strNativeAd.adDescription forKey:kNativeTextKey];
    }
    if (strNativeAd.thumbnailImage != nil) {
        [nativeAssets setObject:strNativeAd.thumbnailImage forKey:kNativeMainImageKey];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:strNativeAd.thumbnailImage];
        [strNativeAd setThumbnailImageInView:imageView];
        [nativeAssets setObject:imageView forKey:kNativeMediaViewKey];
    }
    if (strNativeAd.brandLogoImage != nil) {
        [nativeAssets setObject:strNativeAd.brandLogoImage forKey:kNativeIconImageKey];
    }
    if (strNativeAd.advertiser != nil) {
        [nativeAssets setObject:strNativeAd.advertiser forKey:kNativeSponsoredKey];
    }
    
    _nativeAssets = nativeAssets;
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
    
    //Placing prefetched ad into view
    self.strAdView = [[STRAdHiddenView alloc] init];
    [self.sdk placeAdInView:self.strAdView placementKey:self.placementId presentingViewController:[self.delegate viewControllerToPresentModalView] index:0 customProperties:nil delegate:self];
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
    [self populateNativeAssetsUsingStrAd:ad];
    //setting the disclosure button now that ad is placed in view
    [_nativeAssets setObject:self.strAdView.disclosureButton forKey:kNativeAdChoicesKey];
    
    self.strNativeAd = ad;
    self.strNativeAd.delegate = self;
    
    self.strAdView = (STRAdHiddenView *)adView;
    self.strAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if ([self.adView subviews] == nil) {
        self.strAdView.frame = self.adView.bounds;
        [self.adView addSubview:self.strAdView];
        return;
    }
    //The first subview is the content view (be it single native ad or stream ads)
    //Adding ShareThrough's ad view as the content views' subview
    UIView *subView = [[self.adView subviews] firstObject];
    self.strAdView.frame = subView.bounds;
    [subView addSubview:self.strAdView];
}

//Should never get called since ad's been prefetched
- (void)adView:(id<STRAdView>)adView didFailToFetchAdForPlacementKey:(NSString *)placementKey atIndex:(NSInteger)adIndex {
    return;
}
@end
