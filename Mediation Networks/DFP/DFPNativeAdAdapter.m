//
//  DFPNativeAdAdapter.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 08/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import "DFPNativeAdAdapter.h"

@interface DFPNativeAdAdapter () <GADNativeAdDelegate>

@property (nonatomic, strong) GADNativeAd *dfpNativeAd;

@property (nonatomic, strong) GADNativeAppInstallAd *dfpNativeAppInstallAd;
@property (nonatomic, strong) GADNativeAppInstallAdView *dfpNativeAppInstallAdView;

@property (nonatomic, strong) GADNativeContentAd *dfpNativeContentAd;
@property (nonatomic, strong) GADNativeContentAdView *dfpNativeContentAdView;

@property (nonatomic, strong) UIView *anAdView;
@end

@implementation DFPNativeAdAdapter

@synthesize nativeAssets = _nativeAssets;
@synthesize defaultClickThroughURL = _defaultClickThroughURL;
@synthesize isBackupClassRequired = _isBackupClassRequired;

- (instancetype)initWithDFPNativeAd:(GADNativeAd *)dfpNativeAd
{
    if (self = [super init]) {
        _dfpNativeAd = dfpNativeAd;
        _dfpNativeAd.delegate = self;
        
        
        if ([dfpNativeAd isKindOfClass:[GADNativeAppInstallAd class]]) {
            self.dfpNativeAppInstallAd = (GADNativeAppInstallAd *)dfpNativeAd;
            _nativeAssets = [self nativeAssetsForAppInstall];
        } else if ([dfpNativeAd isKindOfClass:[GADNativeContentAd class]]) {
            self.dfpNativeContentAd = (GADNativeContentAd *)dfpNativeAd;
            _nativeAssets = [self nativeAssetsForAdContent];
        }
        
    }
    
    return self;
}

- (NSMutableDictionary *)nativeAssetsForAppInstall
{
    NSMutableDictionary *assets = [NSMutableDictionary dictionary];
    
    NSNumber *starRating = self.dfpNativeAppInstallAd.starRating;
    [assets setObject:starRating forKey:kNativeStarRatingKey];
    
    if (self.dfpNativeAppInstallAd.headline != nil) {
        [assets setObject:self.dfpNativeAppInstallAd.headline forKey:kNativeTitleKey];
    }
    if (self.dfpNativeAppInstallAd.callToAction != nil) {
        [assets setObject:self.dfpNativeAppInstallAd.callToAction forKey:kNativeCTATextKey];
    }
    if ([self.dfpNativeAppInstallAd.icon.imageURL absoluteString] != nil) {
        [assets setObject:[self.dfpNativeAppInstallAd.icon.imageURL absoluteString] forKey:kNativeIconImageKey];
    }
    if (self.dfpNativeAppInstallAd.body != nil) {
        [assets setObject:self.dfpNativeAppInstallAd.body forKey:kNativeTextKey];
    }
    
    if ([self.dfpNativeAppInstallAd.images count] > 0) {
        GADNativeAdImage *image = self.dfpNativeAppInstallAd.images[0];
        [assets setObject:[image.imageURL absoluteString] forKey:kNativeMainImageKey];
    }
    
    NSMutableDictionary *customAssets = [[NSMutableDictionary alloc] init];
    
    if (self.dfpNativeAppInstallAd.price != nil) {
        [customAssets setObject:self.dfpNativeAppInstallAd.price forKey:@"price"];
    }
    
    if (self.dfpNativeAppInstallAd.store != nil) {
        [customAssets setObject:self.dfpNativeAppInstallAd.store forKey:@"store"];
    }
    
    if ([customAssets count] != 0) {
        [assets setObject:customAssets forKey:kNativeCustomAssetsKey];
    }
    
    self.dfpNativeAppInstallAdView =  [self createAppInstallAdView];
    
    return assets;
}

- (NSMutableDictionary *)nativeAssetsForAdContent
{
    NSMutableDictionary *assets = [NSMutableDictionary dictionary];
    
    if (self.dfpNativeContentAd.headline != nil) {
        [assets setObject:self.dfpNativeContentAd.headline forKey:kNativeTitleKey];
    }
    if (self.dfpNativeContentAd.body != nil) {
        [assets setObject:self.dfpNativeContentAd.body forKey:kNativeTextKey];
    }
    if (self.dfpNativeContentAd.callToAction != nil) {
        [assets setObject:self.dfpNativeContentAd.callToAction forKey:kNativeCTATextKey];
    }
    if (self.dfpNativeContentAd.advertiser != nil) {
        [assets setObject:self.dfpNativeContentAd.advertiser forKey:kNativeSponsoredKey];
    }
    
    if ([self.dfpNativeContentAd.logo.imageURL absoluteString] != nil) {
        [assets setObject:[self.dfpNativeContentAd.logo.imageURL absoluteString] forKey:kNativeIconImageKey];
    }
    if ([self.dfpNativeContentAd.images count] > 0) {
        GADNativeAdImage *image = self.dfpNativeContentAd.images[0];
        [assets setObject:[image.imageURL absoluteString] forKey:kNativeMainImageKey];
    }
    
    self.dfpNativeContentAdView = [self createContentAdView];
    
    return assets;
}

#pragma mark - Ad View Creation

- (GADNativeAppInstallAdView *)createAppInstallAdView
{
    GADNativeAppInstallAdView *adView = [[GADNativeAppInstallAdView alloc] init];
    adView.nativeAppInstallAd = (GADNativeAppInstallAd *)self.dfpNativeAd;
    
    adView.backgroundColor = [UIColor clearColor];
    
    UIImageView *mainImage = [[UIImageView alloc] init];
    adView.imageView = mainImage;
    adView.imageView.frame = adView.bounds;
    adView.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [adView addSubview:adView.imageView];
    
    adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return adView;
}

- (GADNativeContentAdView *)createContentAdView
{
    GADNativeContentAdView *adView = [[GADNativeContentAdView alloc] init];
    adView.nativeContentAd = (GADNativeContentAd *)self.dfpNativeAd;
    
    adView.backgroundColor = [UIColor clearColor];
    
    UIImageView *mainImage = [[UIImageView alloc] init];
    adView.imageView = mainImage;
    adView.imageView.frame = adView.bounds;
    adView.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [adView addSubview:adView.imageView];
    
    adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return adView;
}

#pragma mark - AdAdapter
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

- (void)willAttachToView:(UIView *)view
{
    self.anAdView = view;
    
    if ([self.dfpNativeAd isKindOfClass:[GADNativeAppInstallAd class]]) {
        self.dfpNativeAppInstallAdView.frame = view.bounds;
        [view addSubview:self.dfpNativeAppInstallAdView];
    } else if ([self.dfpNativeAd isKindOfClass:[GADNativeContentAd class]]) {
        self.dfpNativeContentAdView.frame = view.bounds;
        [view addSubview:self.dfpNativeContentAdView];
    }
}

#pragma mark - GADNativeAdDelegate
- (void)nativeAdWillLeaveApplication:(GADNativeAd *)nativeAd
{
    LogDebug(@"Tracking DFP Click");
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    } else {
        LogWarn(@"Delegate does not implement click tracking callback. Clicks likely not being tracked.");
    }
}
@end
