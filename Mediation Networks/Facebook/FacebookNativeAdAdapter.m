//
//  FacebookNativeAdAdapter.m
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 08/10/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import "FacebookNativeAdAdapter.h"

@interface FacebookNativeAdAdapter () <FBNativeAdDelegate>

@property (nonatomic, readonly, strong) FBNativeAd *fbNativeAd;

@end

@implementation FacebookNativeAdAdapter

@synthesize nativeAssets = _nativeAssets;
@synthesize defaultClickThroughURL = _defaultClickThroughURL;
@synthesize isBackupClassRequired = _isBackupClassRequired;

- (instancetype)initWithFBNativeAd:(FBNativeAd *)fbNativeAd
{
    if (self = [super init]) {
        _fbNativeAd = fbNativeAd;
        _fbNativeAd.delegate = self;
        
        NSNumber *starRating = nil;
        
        // Normalize star rating to 5 stars.
        if (fbNativeAd.starRating.scale != 0) {
            CGFloat ratio = 0.0f;
            ratio = kStarRatingUniversalScale/fbNativeAd.starRating.scale;
            starRating = [NSNumber numberWithFloat:ratio*fbNativeAd.starRating.value];
        }
        
        NSMutableDictionary *nativeAssets = [NSMutableDictionary dictionary];
        
        if (starRating) {
            [nativeAssets setObject:starRating forKey:kNativeStarRatingKey];
        }
        
        if (fbNativeAd.title) {
            [nativeAssets setObject:fbNativeAd.title forKey:kNativeTitleKey];
        }
        
        if (fbNativeAd.body) {
            [nativeAssets setObject:fbNativeAd.body forKey:kNativeTextKey];
        }
        
        if (fbNativeAd.callToAction) {
            [nativeAssets setObject:fbNativeAd.callToAction forKey:kNativeCTATextKey];
        }
        
        if (fbNativeAd.icon.url.absoluteString) {
            [nativeAssets setObject:fbNativeAd.icon.url.absoluteString forKey:kNativeIconImageKey];
        }
        
        if (fbNativeAd.coverImage.url.absoluteString) {
            [nativeAssets setObject:fbNativeAd.coverImage.url.absoluteString forKey:kNativeMainImageKey];
        }
        
        NSMutableDictionary *customAssets = [[NSMutableDictionary alloc] init];
        
        if (fbNativeAd.placementID) {
            [customAssets setObject:fbNativeAd.placementID forKey:@"placementID"];
        }
        
        if (fbNativeAd.socialContext) {
            [customAssets setObject:fbNativeAd.socialContext forKey:@"socialContext"];
        }
        
        if ([customAssets count] != 0) {
            [nativeAssets setObject:customAssets forKey:kNativeCustomAssetsKey];
        }
        
        //For video ads
        FBMediaView *mediaView = [[FBMediaView alloc] initWithNativeAd:fbNativeAd];
        [nativeAssets setObject:mediaView forKey:kNativeMediaViewKey];
        
        [nativeAssets setObject:@"Sponsored" forKey:kNativeSponsoredByTagKey];
        
        //Ad Choices View
        [nativeAssets setObject:[[FBAdChoicesView alloc] initWithNativeAd:fbNativeAd] forKey:kNativeAdChoicesKey];
        
        _nativeAssets = nativeAssets;
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

- (BOOL)enableThirdPartyImpressionTracking
{
    return YES;
}

- (BOOL)enableThirdPartyClickTracking
{
    return YES;
}

- (void)willAttachToView:(UIView *)view
{
    [self.fbNativeAd registerViewForInteraction:view withViewController:[self.delegate viewControllerToPresentModalView]];
}
- (void)didDetachFromView:(UIView *)view
{
    [self.fbNativeAd unregisterView];
}

#pragma mark - FBNativeAdDelegate

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd
{
    LogDebug(@"Tracking Facebook Click");
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    } else {
        LogWarn(@"Delegate does not implement click tracking callback. Clicks likely not being tracked.");
    }
    
}

- (void)nativeAdWillLogImpression:(FBNativeAd *)nativeAd
{
    LogDebug(@"Tracking Facebook Impression");
    if ([self.delegate respondsToSelector:@selector(nativeAdWillLogImpression:)]) {
        [self.delegate nativeAdWillLogImpression:self];
    } else {
        LogWarn(@"Delegate does not implement impression tracking callback. Impressions likely not being tracked.");
    }
}

#pragma mark - Orientation

- (FBInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
