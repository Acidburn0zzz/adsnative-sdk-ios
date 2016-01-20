//
//  MoPubNativeAdAdapter.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 03/11/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "MoPubNativeAdAdapter.h"
#import "MoPubHiddenView.h"

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
        
        [nativeAssets setObject:@"Sponsored" forKey:kNativeSponsoredByTagKey];
        
        UIView *nativeAdView = [_mpNativeAd retrieveAdViewWithError:nil];
        self.mpAdView = nativeAdView;
        self.mpAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        for (UIView *subView in [self.mpAdView subviews]) {
            
            if ([subView isKindOfClass:[MoPubHiddenView class]]) {
                MoPubHiddenView *view = (MoPubHiddenView *)subView;
                //Setting MoPub's privacy image icon
                if (view.privacyIconImage) {
                    [nativeAssets setObject:view.privacyIconImage forKey:kNativeAdChoicesKey];
                }
            }
        }
        
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
    self.anAdView = view;
    
    //The first subview is the content view (be it single native ad or stream ads)
    //Adding MoPub's ad view as the content views' subview
    for (UIView *v in [self.anAdView subviews]) {
        self.mpAdView.frame = v.bounds;
        [v addSubview:self.mpAdView];
        break;
    }
    if ([self.anAdView subviews] == nil) {
        self.mpAdView.frame = self.anAdView.bounds;
        [self.anAdView addSubview:self.mpAdView];
    }
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

- (void)willLeaveApplicationFromNativeAd:(MPNativeAd *)nativeAd
{
    LogDebug(@"Tracking MoPub Click");
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    } else {
        LogWarn(@"Delegate does not implement click tracking callback. Clicks likely not being tracked.");
    }
}

@end
