//
//  AdColonyNativeAdAdapter.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 07/03/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import "AdColonyNativeAdAdapter.h"

@interface AdColonyNativeAdAdapter() <AdColonyNativeAdDelegate>

@property (nonatomic,strong) AdColonyNativeAdView *adColonyNativeAdView;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, copy) void (^actionCompletionBlock)(BOOL, NSError *);

@end

@implementation AdColonyNativeAdAdapter

@synthesize nativeAssets = _nativeAssets;
@synthesize defaultClickThroughURL = _defaultClickThroughURL;
@synthesize isBackupClassRequired = _isBackupClassRequired;

- (instancetype)initWithAdColonyNativeAdView:(AdColonyNativeAdView *)adColonyNativeAdView
{
    if (self = [super init]) {
        _adColonyNativeAdView = adColonyNativeAdView;
        _adColonyNativeAdView.delegate = self;
        
        NSMutableDictionary *nativeAssets = [[NSMutableDictionary alloc] init];
        
        if (adColonyNativeAdView.adTitle != nil) {
            [nativeAssets setObject:adColonyNativeAdView.adTitle forKey:kNativeTitleKey];
        }
        
        if (adColonyNativeAdView.adDescription != nil) {
            [nativeAssets setObject:adColonyNativeAdView.adDescription forKey:kNativeTextKey];
        }
        
        if (adColonyNativeAdView.advertiserIcon != nil) {
            [nativeAssets setObject:adColonyNativeAdView.advertiserIcon forKey:kNativeIconImageKey];
        }
        
        [nativeAssets setObject:adColonyNativeAdView forKey:kNativeMediaViewKey];
        
        if (adColonyNativeAdView.advertiserName != nil) {
            [nativeAssets setObject:@"Sponsored By" forKey:kNativeSponsoredByTagKey];
            [nativeAssets setObject:adColonyNativeAdView.advertiserName forKey:kNativeSponsoredKey];
        } else {
            [nativeAssets setObject:@"Sponsored" forKey:kNativeSponsoredByTagKey];
        }
        
        _nativeAssets = nativeAssets;
        
    }
    return self;
}


#pragma mark - AdAdapter
- (BOOL)enableThirdPartyClickTracking
{
    return YES;
}

- (BOOL)isMediaView
{
    return YES;
}

- (BOOL)handleMediaViewVisibility
{
    return YES;
}

- (void)mediaDidComeIntoView
{
    LogDebug(@"Media Did Come Into View and resumed");
    [self.adColonyNativeAdView resume];
}

- (void)mediaDidGoOutOfView
{
    LogDebug(@"Media Did Go Out Of View and paused");
    [self.adColonyNativeAdView pause];
}

#pragma mark - AdColonyNativeAdDelegate
-(void)onAdColonyNativeAdEngagementPressed:(AdColonyNativeAdView*)ad expanded:(BOOL)expanded
{
    LogDebug(@"Tracking AdColony Click");
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    } else {
        LogWarn(@"Delegate does not implement click tracking callback. Clicks likely not being tracked.");
    }
}
@end
