//
//  InMobiNativeCustomEvent.m
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 07/10/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import "InMobiNativeCustomEvent.h"
#import "InMobiNativeAdAdapter.h"
#import "IMNativeDelegate.h"
#import "IMNative.h"
#import "IMRequestStatus.h"
#import "IMSdk.h"

static NSString *gAppId = nil;

@interface InMobiNativeCustomEvent () <IMNativeDelegate>

@property (nonatomic, strong) IMNative *inMobiAd;

@end

@implementation InMobiNativeCustomEvent

+ (void)setAppId:(NSString *)appId
{
    gAppId = [appId copy];
}

- (void)dealloc
{
    _inMobiAd.delegate = nil;
}

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    NSString *appId = [info objectForKey:@"placementId"];
    
    if ([appId length] == 0) {
        appId = gAppId;
    }
    
    if ([appId length]) {
        unsigned long long appIdInLong = strtoll([appId UTF8String], NULL, 0);
        
        NSString *accountId = [info objectForKey:@"accountId"];
        
        //Initialize InMobi SDK with your account ID
        [IMSdk initWithAccountID:accountId];
        
        _inMobiAd = [[IMNative alloc] initWithPlacementId:appIdInLong];
        self.inMobiAd.delegate = self;
        [self.inMobiAd load];
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForInvalidAdServerResponse(@"Invalid InMobi app ID")];
    }
}

#pragma mark - IMNativeDelegate

-(void)nativeDidFinishLoading:(IMNative*)native
{
    InMobiNativeAdAdapter *adAdapter = [[InMobiNativeAdAdapter alloc] initWithInMobiNativeAd:native];
    ANNativeAd *interfaceAd = [[ANNativeAd alloc] initWithAdAdapter:adAdapter];
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    
    if ([[interfaceAd.nativeAssets objectForKey:kNativeIconImageKey] length]) {
        if (![self addURLString:[interfaceAd.nativeAssets objectForKey:kNativeIconImageKey] toURLArray:imageURLs]) {
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForInvalidImageURL()];
        }
    }
    
    if ([[interfaceAd.nativeAssets objectForKey:kNativeMainImageKey] length]) {
        if (![self addURLString:[interfaceAd.nativeAssets objectForKey:kNativeMainImageKey] toURLArray:imageURLs]) {
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForInvalidImageURL()];
        }
    }
    
    [super precacheImagesWithURLs:imageURLs completionBlock:^(NSArray *errors) {
        if (errors) {
            LogDebug(@"%@", errors);
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForImageDownloadFailure()];
        } else {
            [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
        }
    }];
}

-(void)native:(IMNative*)native didFailToLoadWithError:(IMRequestStatus*)error
{
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:AdNSErrorForInvalidAdServerResponse(@"InMobi ad load error")];
}

/* Indicates that the native ad is going to present a screen. */
-(void)nativeWillPresentScreen:(IMNative*)native{
    LogDebug(@"Native Ad will present screen");
}

/* Indicates that the native ad has presented a screen. */
-(void)nativeDidPresentScreen:(IMNative*)native{
    LogDebug(@"Native Ad did present screen");
}

/* Indicates that the native ad is going to dismiss the presented screen. */
-(void)nativeWillDismissScreen:(IMNative*)native{
    LogDebug(@"Native Ad will dismiss screen");
}

/* Indicates that the native ad has dismissed the presented screen. */
-(void)nativeDidDismissScreen:(IMNative*)native{
    LogDebug(@"Native Ad did dismiss screen");
}

/* Indicates that the user will leave the app. */
-(void)userWillLeaveApplicationFromNative:(IMNative*)native{
    LogDebug(@"User leave");
}

#pragma mark - helper
- (BOOL)addURLString:(NSString *)urlString toURLArray:(NSMutableArray *)urlArray
{
    if (urlString.length == 0) {
        return NO;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        [urlArray addObject:url];
        return YES;
    } else {
        return NO;
    }
}
@end
