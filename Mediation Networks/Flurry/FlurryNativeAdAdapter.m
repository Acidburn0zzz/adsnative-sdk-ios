//
//  FlurryNativeAdAdapter.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 05/11/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "FlurryNativeAdAdapter.h"
#import "FlurryAdNativeDelegate.h"

@interface FlurryNativeAdAdapter () <FlurryAdNativeDelegate>

@property (nonatomic, strong) FlurryAdNative *flurryNativeAd;

@end

@implementation FlurryNativeAdAdapter

@synthesize nativeAssets = _nativeAssets;
@synthesize defaultClickThroughURL = _defaultClickThroughURL;
@synthesize isBackupClassRequired = _isBackupClassRequired;

- (instancetype)initWithFlurryNativeAd:(FlurryAdNative *)flurryNativeAd
{
    if (self = [super init]) {
        _flurryNativeAd = flurryNativeAd;
        _flurryNativeAd.adDelegate = self;
        
        NSMutableDictionary *nativeAssets = [[NSMutableDictionary alloc] init];
        BOOL isAppAd = NO;
        BOOL isAdvertiserNamePresent = NO;
        
        for (int ix = 0; ix < flurryNativeAd.assetList.count; ++ix) {
            
            FlurryAdNativeAsset* asset = [flurryNativeAd.assetList objectAtIndex:ix];
            
            //If app rating is present, then it is an app ad
            if ([asset.name isEqualToString:@"appRating"]) {
                NSString *ratingString = asset.value;
                NSRange end = [asset.value rangeOfString:@"/100"];
                
                ratingString = [ratingString substringToIndex:end.location];
                
                CGFloat ratingValue = [ratingString floatValue]/20.0f;
                
                NSNumber *rating = [NSNumber numberWithFloat:ratingValue];
                
                [nativeAssets setObject:rating forKey:kNativeStarRatingKey];
                
                isAppAd = YES;
                
            }
            
            if ([asset.name isEqualToString:@"appCategory"]) {
                isAppAd = YES;
            }
            
            if ([asset.name isEqualToString:@"headline"]) {
                [nativeAssets setObject:asset.value forKey:kNativeTitleKey];
            }
            if ([asset.name isEqualToString:@"summary"]) {
                [nativeAssets setObject:asset.value forKey:kNativeTextKey];
            }
            
            if ([asset.name isEqualToString:@"source"] && asset.value != nil && [asset.value isKindOfClass:[NSString class]]) {
                [nativeAssets setObject:asset.value forKey:kNativeSponsoredKey];
                
                isAdvertiserNamePresent = YES;
            }
            
            if ([asset.name isEqualToString:@"secHqImage"]) {
                [nativeAssets setObject:asset.value forKey:kNativeMainImageKey];
            }
            
            if ([asset.name isEqualToString:@"secImage"]) {
                [nativeAssets setObject:asset.value forKey:kNativeIconImageKey];
            }
        }
        
        if (isAppAd) {
            [nativeAssets setObject:@"Install Now" forKey:kNativeCTATextKey];
        } else {
            [nativeAssets setObject:@"Read More" forKey:kNativeCTATextKey];
        }
        
        if (isAdvertiserNamePresent) {
            [nativeAssets setObject:@"Sponsored By" forKey:kNativeSponsoredByTagKey];
        } else {
            [nativeAssets setObject:@"Sponsored" forKey:kNativeSponsoredByTagKey];
        }
        _nativeAssets = nativeAssets;
    }
    
    
    return self;
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
    _flurryNativeAd.trackingView = view;
    _flurryNativeAd.viewControllerForPresentation = [self.delegate viewControllerToPresentModalView];
}
- (void)didDetachFromView:(UIView *)view
{
    [_flurryNativeAd removeTrackingView];
}

#pragma mark - FlurryAdNativeDelegate

- (void)adNativeDidLogImpression:(FlurryAdNative*) nativeAd
{
    LogDebug(@"Tracking Flurry Impression");
    if ([self.delegate respondsToSelector:@selector(nativeAdWillLogImpression:)]) {
        [self.delegate nativeAdWillLogImpression:self];
    } else {
        LogWarn(@"Delegate does not implement impression tracking callback. Impressions likely not being tracked.");
    }
}

- (void)adNativeDidReceiveClick:(FlurryAdNative*) nativeAd
{
    LogDebug(@"Tracking Flurry Click");
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    } else {
        LogWarn(@"Delegate does not implement click tracking callback. Clicks likely not being tracked.");
    }
    
}
@end
