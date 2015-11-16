//
//  InMobiNativeAdAdapter.m
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 07/10/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import "InMobiNativeAdAdapter.h"
#import "IMNative.h"

/*
 * Default keys for InMobi Native Ads
 *
 * These values must correspond to the strings configured with InMobi.
 */
static NSString *gInMobiTitleKey = @"title";
static NSString *gInMobiDescriptionKey = @"description";
static NSString *gInMobiCallToActionKey = @"cta";
static NSString *gInMobiRatingKey = @"rating";
static NSString *gInMobiScreenshotKey = @"screenshots";
static NSString *gInMobiIconKey = @"icon";
// As of 6-25-2014 this key is editable on InMobi's site
static NSString *gInMobiLandingURLKey = @"landingURL";

/*
 * InMobi Key - Do Not Change.
 */
static NSString *const kInMobiImageURL = @"url";

@interface InMobiNativeAdAdapter() <AdDestinationDisplayAgentDelegate>

@property (nonatomic, readonly, strong) IMNative *inMobiNativeAd;

@property (nonatomic, readonly, strong) AdDestinationDisplayAgent *destinationDisplayAgent;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, copy) void (^actionCompletionBlock)(BOOL, NSError *);

@property (nonatomic,strong) UIView *adView;

@end

@implementation InMobiNativeAdAdapter

@synthesize nativeAssets = _nativeAssets;
@synthesize defaultClickThroughURL = _defaultClickThroughURL;
@synthesize isBackupClassRequired = _isBackupClassRequired;

+ (void)setCustomKeyForTitle:(NSString *)key
{
    gInMobiTitleKey = [key copy];
}

+ (void)setCustomKeyForDescription:(NSString *)key
{
    gInMobiDescriptionKey = [key copy];
}

+ (void)setCustomKeyForCallToAction:(NSString *)key
{
    gInMobiCallToActionKey = [key copy];
}

+ (void)setCustomKeyForRating:(NSString *)key
{
    gInMobiRatingKey = [key copy];
}

+ (void)setCustomKeyForScreenshot:(NSString *)key
{
    gInMobiScreenshotKey = [key copy];
}

+ (void)setCustomKeyForIcon:(NSString *)key
{
    gInMobiIconKey = [key copy];
}

+ (void)setCustomKeyForLandingURL:(NSString *)key
{
    gInMobiLandingURLKey = [key copy];
}

- (instancetype)initWithInMobiNativeAd:(IMNative *)nativeAd
{
    self = [super init];
    if (self) {
        _inMobiNativeAd = nativeAd;
        
        NSDictionary *inMobiProperties = [self inMobiProperties];
        NSMutableDictionary *nativeAssets = [NSMutableDictionary dictionary];
        
        if ([inMobiProperties objectForKey:gInMobiRatingKey]) {
            [nativeAssets setObject:[inMobiProperties objectForKey:gInMobiRatingKey] forKey:kNativeStarRatingKey];
        }
        
        if ([[inMobiProperties objectForKey:gInMobiTitleKey] length]) {
            [nativeAssets setObject:[inMobiProperties objectForKey:gInMobiTitleKey] forKey:kNativeTitleKey];
        }
        
        if ([[inMobiProperties objectForKey:gInMobiDescriptionKey] length]) {
            [nativeAssets setObject:[inMobiProperties objectForKey:gInMobiDescriptionKey] forKey:kNativeTextKey];
        }
        
        if ([[inMobiProperties objectForKey:gInMobiCallToActionKey] length]) {
            [nativeAssets setObject:[inMobiProperties objectForKey:gInMobiCallToActionKey] forKey:kNativeCTATextKey];
        }
        
        NSDictionary *iconDictionary = [inMobiProperties objectForKey:gInMobiIconKey];
        
        if ([[iconDictionary objectForKey:kInMobiImageURL] length]) {
            [nativeAssets setObject:[iconDictionary objectForKey:kInMobiImageURL] forKey:kNativeIconImageKey];
        }
        
        NSDictionary *mainImageDictionary = [inMobiProperties objectForKey:gInMobiScreenshotKey];
        
        if ([[mainImageDictionary objectForKey:kInMobiImageURL] length]) {
            [nativeAssets setObject:[mainImageDictionary objectForKey:kInMobiImageURL] forKey:kNativeMainImageKey];
        }
        
        [nativeAssets setObject:@"Sponsored" forKey:kNativeSponsoredKey];
        
        _nativeAssets = nativeAssets;
        
        if ([[inMobiProperties objectForKey:gInMobiLandingURLKey] length]) {
            _defaultClickThroughURL = [NSURL URLWithString:[inMobiProperties objectForKey:gInMobiLandingURLKey]];
        } else {
            // Log a warning if we can't find the landing URL since the key can either be "landing_url", "landingURL", or a custom key depending on the date the property was created.
            LogWarn(@"WARNING: Couldn't find landing url with key: %@ for InMobi network.  Double check your ad property and call setCustomKeyForLandingURL: with the correct key if necessary.", gInMobiLandingURLKey);
        }
        
        _destinationDisplayAgent = [[InstanceProvider sharedProvider] buildAdDestinationDisplayAgentWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [_destinationDisplayAgent cancel];
    [_destinationDisplayAgent setDelegate:nil];
}

- (NSDictionary *)inMobiProperties
{
    NSData *data = [self.inMobiNativeAd.adContent dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSDictionary *propertyDictionary = nil;
    if (data) {
        propertyDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    if (propertyDictionary && !error) {
        return propertyDictionary;
    }
    else {
        return nil;
    }
    return nil;
}

#pragma mark - AdAdapter

- (NSTimeInterval)requiredSecondsForImpression
{
    return 0.0;
}

- (void)willAttachToView:(UIView *)view
{
    _adView = view;
}

- (void)trackImpression
{
    [IMNative bindNative:self.inMobiNativeAd toView:_adView];
}
- (void)trackClick
{
    [self.inMobiNativeAd reportAdClick:nil];
}

- (void)displayContentForURL:(NSURL *)URL rootViewController:(UIViewController *)controller
                  completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    NSError *error = nil;
    
    if (!controller) {
        error = AdNSErrorForContentDisplayErrorMissingRootController();
    }
    
    if (!URL || ![URL isKindOfClass:[NSURL class]] || ![URL.absoluteString length]) {
        error = AdNSErrorForContentDisplayErrorInvalidURL();
    }
    
    if (error) {
        
        if (completionBlock) {
            completionBlock(NO, error);
        }
        return;
    }
    
    self.rootViewController = controller;
    self.actionCompletionBlock = completionBlock;
    [self.destinationDisplayAgent displayDestinationForURL:URL];
}

#pragma mark - <AdDestinationDisplayAgent>

- (UIViewController *)viewControllerToPresentModalView
{
    return self.rootViewController;
}

- (void)displayAgentWillPresentModal
{
    
}

- (void)displayAgentWillLeaveApplication
{
    if (self.actionCompletionBlock) {
        self.actionCompletionBlock(YES, nil);
        self.actionCompletionBlock = nil;
    }
}

- (void)displayAgentDidDismissModal
{
    if (self.actionCompletionBlock) {
        self.actionCompletionBlock(YES, nil);
        self.actionCompletionBlock = nil;
    }
    self.rootViewController = nil;
}
@end

