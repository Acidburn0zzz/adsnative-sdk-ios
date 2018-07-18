//
//  PMBidder.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 31/07/17.
//  Copyright © 2017 AdsNative. All rights reserved.
//

#import "PMBidder.h"


typedef void(^MPNativeAdRequestHandler)(MPNativeAdRequest *request,
                                        MPNativeAd *response,
                                        NSError *error);

@interface PMBidder()

@property (nonatomic, strong) PMNativeAd *nativeAd;
@property (nonatomic, copy) MPNativeAdRequestHandler handler;
@property (nonatomic, strong) MPNativeAdRequest *mpNativeAdRequest;
@property (nonatomic, strong) NSString *pmAdUnitID;
@end


@implementation PMBidder

- (instancetype)initWithPMAdUnitID:(NSString *)adUnitID
{
    self = [super init];
    self.pmAdUnitID = adUnitID;

    return self;
}

- (void)startWithAdRequest:(MPNativeAdRequest *)mpNativeAdRequest viewController:(UIViewController *)controller completionHandler:(MPNativeAdRequestHandler) handler
{
    self.mpNativeAdRequest = mpNativeAdRequest;
    self.handler = handler;
    
    if (handler == nil) {
        LogWarn(@"Native Ad Request did not start - requires completion handler block.");
        return;
    }
    
    //clear PM ad cache before making a fresh request
    [[PMPrefetchAds getInstance] clearCache];

    self.pmClass = [[PMClass alloc] initWithAdUnitID:self.pmAdUnitID requestType:PM_REQUEST_TYPE_NATIVE withBannerSize:CGSizeMake(0,0)];
    self.pmClass.delegate = self;
    
    ANAdRequestTargeting *targeting = [ANAdRequestTargeting targeting];
    NSMutableArray *keywords = [[NSMutableArray alloc] init];
    [keywords addObject:@"&hb=1"];
    targeting.keywords = keywords;
    
    [self.pmClass loadPMAdWithTargeting:targeting];
}

#pragma mark - <ANNativeAdDelegate>
- (void)anNativeAdDidLoad:(PMNativeAd *)nativeAd
{
    self.nativeAd = nativeAd;
    [[PMPrefetchAds getInstance] setAd:self.nativeAd];
    
    if ([nativeAd.nativeAssets objectForKey:kNativeEcpmKey] != nil) {
        NSString *ecpmAsString = [@"ecpm:" stringByAppendingString:[NSString stringWithFormat:@"%.2f", self.nativeAd.biddingEcpm]];
        
        //Check for existing targeting as well as if ecpm is already being pass in kw
        if (self.mpNativeAdRequest.targeting == nil) {
            MPNativeAdRequestTargeting *targeting = [MPNativeAdRequestTargeting targeting];
            targeting.keywords = ecpmAsString;
            self.mpNativeAdRequest.targeting = targeting;
        } else {
            MPNativeAdRequestTargeting *targeting = self.mpNativeAdRequest.targeting;
            NSString *keywords = self.mpNativeAdRequest.targeting.keywords;
            
            if (keywords != nil) {
                ecpmAsString = [@"," stringByAppendingString:ecpmAsString];
                if ([keywords containsString:@"ecpm"]) {
                    NSError *error = nil;
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@",ecpm:.*" options:NSRegularExpressionCaseInsensitive error:&error];
                    NSString *modifiedString = [regex stringByReplacingMatchesInString:keywords options:0 range:NSMakeRange(0, [keywords length]) withTemplate:ecpmAsString];
                    keywords = modifiedString;
                } else {
                    keywords = [keywords stringByAppendingString:ecpmAsString];
                }
            } else {
                keywords = ecpmAsString;
            }
            targeting.keywords = keywords;
            
            self.mpNativeAdRequest.targeting = targeting;
        }
        
        
    }
    //TODO add targeting criteria to mopub request. Also Check if view controller needs to be passed
    
    [self.mpNativeAdRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (self.handler) {
            self.handler(request, response, error);
        }
    }];
}

- (void)anNativeAd:(PMNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    [self.mpNativeAdRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (self.handler) {
            self.handler(request, response, error);
        }
    }];
}

@end
