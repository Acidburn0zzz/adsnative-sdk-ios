//
//  MoPubNativeAdAdapter.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 03/11/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "MoPubNativeAdAdapter.h"

@interface MoPubNativeAdAdapter() <MPNativeAdDelegate>

@property (nonatomic,strong) MPNativeAd *mpNativeAd;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, copy) void (^actionCompletionBlock)(BOOL, NSError *);

@property (nonatomic,strong) UIView *anAdView;
@property (nonatomic,strong) UIView *mpAdView;

@end

@implementation MoPubNativeAdAdapter

@synthesize nativeAssets = _nativeAssets;
@synthesize defaultClickThroughURL = _defaultClickThroughURL;
@synthesize isBackupClassRequired = _isBackupClassRequired;

- (instancetype)initWithMPNativeAd:(MPNativeAd *)mpNativeAd
{
    if (self = [super init]) {
        _mpNativeAd = mpNativeAd;
        _mpNativeAd.delegate = self;
        
        NSMutableDictionary *nativeAssets = [[NSMutableDictionary alloc] init];
        
        if ([mpNativeAd.properties objectForKey:kAdTitleKey] != nil) {
            [nativeAssets setObject:[mpNativeAd.properties objectForKey:kAdTitleKey] forKey:kNativeTitleKey];
        }
        
        if ([mpNativeAd.properties objectForKey:kAdTextKey] != nil) {
            [nativeAssets setObject:[mpNativeAd.properties objectForKey:kAdTextKey] forKey:kNativeTextKey];
        }
        
        if ([mpNativeAd.properties objectForKey:kAdMainImageKey] != nil) {
            [nativeAssets setObject:[mpNativeAd.properties objectForKey:kAdMainImageKey] forKey:kNativeMainImageKey];
        }
        
        if ([mpNativeAd.properties objectForKey:kAdIconImageKey] != nil) {
            [nativeAssets setObject:[mpNativeAd.properties objectForKey:kAdIconImageKey] forKey:kNativeIconImageKey];
        }
        
        if ([mpNativeAd.properties objectForKey:kAdCTATextKey] != nil) {
            [nativeAssets setObject:[mpNativeAd.properties objectForKey:kAdCTATextKey] forKey:kNativeCTATextKey];
        }
        
        if ([mpNativeAd.properties objectForKey:kAdStarRatingKey] != nil) {
            [nativeAssets setObject:[mpNativeAd.properties objectForKey:kAdStarRatingKey] forKey:kNativeStarRatingKey];
        }
        
        [nativeAssets setObject:@"Sponsored" forKey:kNativeSponsoredKey];
        
        _nativeAssets = nativeAssets;
        
    }
    return self;
}


#pragma mark - AdAdapter

- (NSURL *)defaultClickThroughURL
{
    return nil;
}

- (void)willAttachToView:(UIView *)view
{
    _anAdView = view;
    
    UIView *nativeAdView = [_mpNativeAd retrieveAdViewWithError:nil];
    
    //Ad Frame would be empty if implementing single native ad and registering view
    //without setting frame
    if (CGRectEqualToRect(_anAdView.frame, CGRectMake(0, 0, 0, 0))) {
        LogWarn(@"Please set the frame for your Ad UIView instance before calling `registerNativeAdWithController:forView:` for the best user experience. If you're calling `renderNativeAdWithController:defaultRenderingClass:` then set the frame in the init method of the class for the best user experience.");
    }
    
    CGRect frame = _anAdView.frame;
    frame.origin = CGPointMake(0.0f, 0.0f);
    nativeAdView.frame = frame;
    
    _mpAdView = nativeAdView;
    
    [view addSubview:nativeAdView];
}

- (void)trackImpression
{
    //Set frame if mpAdView's frame is empty
    if (CGRectEqualToRect(_mpAdView.frame, CGRectMake(0, 0, 0, 0))) {
        _mpAdView.frame = _anAdView.frame;
    }
    
    LogDebug(@"Impression Tracked");
}


#pragma mark - MPNativeAdDelegate
- (UIViewController *)viewControllerForPresentingModalView
{
    return [self.delegate viewControllerToPresentModalView];
}

- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd
{
    LogDebug(@"Tracking MoPub Click");
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    } else {
        LogWarn(@"Delegate does not implement click tracking callback. Clicks likely not being tracked.");
    }
}

@end
