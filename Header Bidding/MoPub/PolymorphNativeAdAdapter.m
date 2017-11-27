//
//  PolymorphNativeAdAdapter.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 01/08/17.
//  Copyright © 2017 AdsNative. All rights reserved.
//

#import "PolymorphNativeAdAdapter.h"


static const NSTimeInterval kMoPubRequiredSecondsForImpression = 1.0;
static const CGFloat kMoPubRequiredViewVisibilityPercentage = 0.5;

@interface PolymorphNativeAdAdapter() <ANNativeAdDelegate, MPAdDestinationDisplayAgentDelegate, MPStaticNativeAdImpressionTimerDelegate>


@property (nonatomic, readonly) PMNativeAd *nativeAd;
@property (nonatomic, strong) NSDictionary *pmAdproperties;

@property (nonatomic, readonly) MPAdDestinationDisplayAgent *destinationDisplayAgent;
@property (nonatomic) MPStaticNativeAdImpressionTimer *impressionTimer;

@end

@implementation PolymorphNativeAdAdapter

@synthesize properties = _properties;
@synthesize defaultActionURL = _defaultActionURL;


- (instancetype)initWithPMNativeAd:(PMNativeAd *)nativeAd
{
    self = [super init];
    
    if (self) {
        _nativeAd = nativeAd;
        _nativeAd.delegate = self;
        
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        
        NSDictionary *assets = _nativeAd.nativeAssets;
        
        if ([assets objectForKey:kNativeTitleKey]) {
            [properties setObject:[assets objectForKey:kNativeTitleKey] forKey:kAdTitleKey];
        }
        
        if ([assets objectForKey:kNativeTextKey]) {
            [properties setObject:[assets objectForKey:kNativeTextKey] forKey:kAdTextKey];
        }
        
        if ([assets objectForKey:kNativeCTATextKey]) {
            [properties setObject:[assets objectForKey:kNativeCTATextKey] forKey:kAdCTATextKey];
        }
        
        if ([assets objectForKey:kNativeIconImageKey]) {
            [properties setObject:[assets objectForKey:kNativeIconImageKey] forKey:kAdIconImageKey];
        }
        
        if ([assets objectForKey:kNativeMainImageKey]) {
            [properties setObject:[assets objectForKey:kNativeMainImageKey] forKey:kAdMainImageKey];
        }
        
        self.pmAdproperties = properties;
        
        _destinationDisplayAgent = [[MPCoreInstanceProvider sharedProvider] buildMPAdDestinationDisplayAgentWithDelegate:self];
        
        _defaultActionURL = [NSURL URLWithString: [self.nativeAd.nativeAssets objectForKey:kNativeLandingUrlKey]];
        _impressionTimer = [[MPStaticNativeAdImpressionTimer alloc] initWithRequiredSecondsForImpression:kMoPubRequiredSecondsForImpression requiredViewVisibilityPercentage:kMoPubRequiredViewVisibilityPercentage];
        _impressionTimer.delegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    [_destinationDisplayAgent cancel];
    [_destinationDisplayAgent setDelegate:nil];
}

#pragma mark - <MPNativeAdAdapter>

- (NSDictionary *)properties {
    return self.pmAdproperties;
}

- (void)willAttachToView:(UIView *)view
{
    [self.impressionTimer startTrackingView:view];
}

- (void)trackClick {
    [self.nativeAd trackClick];
}
- (void)displayContentForURL:(NSURL *)URL rootViewController:(UIViewController *)controller {
    if (!controller) {
        return;
    }
    
    if (!URL || ![URL isKindOfClass:[NSURL class]] || ![URL.absoluteString length]) {
        return;
    }
    
    [self.destinationDisplayAgent displayDestinationForURL:URL];
}

#pragma mark - <MPStaticNativeAdImpressionTimerDelegate>

- (void)trackImpression
{
    [self.nativeAd trackImpression];
    [self.delegate nativeAdWillLogImpression:self];
}

#pragma mark - <MPAdDestinationDisplayAgentDelegate>

- (UIViewController *)viewControllerForPresentingModalView
{
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)displayAgentWillPresentModal
{
    [self.delegate nativeAdWillPresentModalForAdapter:self];
}

- (void)displayAgentWillLeaveApplication
{
    [self.delegate nativeAdWillLeaveApplicationFromAdapter:self];
}

- (void)displayAgentDidDismissModal
{
    [self.delegate nativeAdDidDismissModalForAdapter:self];
}


@end
