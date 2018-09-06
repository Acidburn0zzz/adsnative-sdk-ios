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

@property (nonatomic, strong) FBAdIconView *iconImageView;
@property (nonatomic, strong) FBMediaView *fbMediaView;

@end

@implementation FacebookNativeAdAdapter

@synthesize nativeAssets = _nativeAssets;
@synthesize defaultClickThroughURL = _defaultClickThroughURL;
@synthesize isBackupClassRequired = _isBackupClassRequired;

- (instancetype)initWithFBNativeAd:(FBNativeAd *)fbNativeAd withInfo:(NSDictionary *)info
{
    if (self = [super init]) {
        _fbNativeAd = fbNativeAd;
        _fbNativeAd.delegate = self;
        
        NSMutableDictionary *nativeAssets = [NSMutableDictionary dictionary];
        
        if (fbNativeAd.headline) {
            [nativeAssets setObject:fbNativeAd.headline forKey:kNativeTitleKey];
        }

        if (fbNativeAd.bodyText) {
            [nativeAssets setObject:fbNativeAd.bodyText forKey:kNativeTextKey];
        }
        
        if (fbNativeAd.callToAction) {
            [nativeAssets setObject:fbNativeAd.callToAction forKey:kNativeCTATextKey];
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
        
        if (fbNativeAd.advertiserName) {
            [nativeAssets setObject:fbNativeAd.advertiserName forKey:kNativeSponsoredKey];
        }
        
        if ([info objectForKey:kNativeEcpmKey] != nil) {
            [nativeAssets setObject:[info objectForKey:kNativeEcpmKey] forKey:kNativeEcpmKey];
        }

        self.iconImageView = [[FBAdIconView alloc] init];
        [nativeAssets setObject:self.iconImageView forKey:kNativeIconImageKey];
        
        [nativeAssets setObject:@"Sponsored By" forKey:kNativeSponsoredByTagKey];
        
        //For FB cover/main/carousell images and video ads
        FBMediaView *mediaView = [[FBMediaView alloc] init];
        [nativeAssets setObject:mediaView forKey:kNativeMediaViewKey];
        
        //Ad Choices View
        FBAdChoicesView *adChoicesView = [[FBAdChoicesView alloc] init];
        adChoicesView.nativeAd = fbNativeAd;
        adChoicesView.rootViewController = nil;
        adChoicesView.corner = UIRectCornerTopRight;
        [nativeAssets setObject:adChoicesView forKey:kNativeAdChoicesKey];
        
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
    [self.fbNativeAd registerViewForInteraction:view mediaView:[self.nativeAssets objectForKey:kNativeMediaViewKey] iconView:self.iconImageView viewController:[self.delegate viewControllerToPresentModalView]];
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
    if ([self.delegate respondsToSelector:@selector(nativeAdWillLeaveApplication:)]) {
        [self.delegate nativeAdWillLeaveApplication:self];
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
