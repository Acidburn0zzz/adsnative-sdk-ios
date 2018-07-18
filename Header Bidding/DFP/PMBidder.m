//
//  PMBidder.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 13/07/18.
//  Copyright © 2018 AdsNative. All rights reserved.
//
#import "PMBidder.h"

@interface PMBidder()

@property (nonatomic, strong) PMNativeAd *nativeAd;
@property (nonatomic, strong) PMClass *pmClass;

@property (nonatomic, strong) GADAdLoader *gAdLoader;
@property (nonatomic, strong) DFPRequest *dfpRequest;
@property (nonatomic, strong) NSString *pmAdUnitID;
@property (nonatomic, weak) id<GADAdLoaderDelegate> delegate;

@property (nonatomic, strong) UIViewController *controller;
@end


@implementation PMBidder

- (instancetype)initWithPMAdUnitID:(NSString *)adUnitID
{
    self = [super init];
    self.pmAdUnitID = adUnitID;
    
    return self;
}

- (void)startWithAdLoader:(GADAdLoader *)gAdLoader viewController:(UIViewController *)controller
{
    [self startWithAdLoader:gAdLoader viewController:controller dfpRequest:nil];
}

- (void)startWithAdLoader:(GADAdLoader *)gAdLoader viewController:(UIViewController *)controller dfpRequest:(DFPRequest *)request
{
    self.gAdLoader = gAdLoader;
    self.controller = controller;
    self.dfpRequest = request;
 
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

#pragma mark - <PMCLassDelegate>
- (void)pmNativeAdDidLoad:(PMNativeAd *)nativeAd
{
    self.nativeAd = nativeAd;
    [[PMPrefetchAds getInstance] setAd:self.nativeAd];
    
    if ([nativeAd.nativeAssets objectForKey:kNativeEcpmKey] != nil) {
        NSString *ecpmAsString = [NSString stringWithFormat:@"%.2f", self.nativeAd.biddingEcpm];
        
        LogDebug(@"Making DFP request with ecpm: %@", ecpmAsString);
        if (self.dfpRequest != NULL) {
            if (self.dfpRequest.customTargeting != NULL) {
                NSMutableDictionary *targeting = [[NSMutableDictionary alloc] initWithDictionary:self.dfpRequest.customTargeting];
                [targeting setObject:ecpmAsString forKey:@"ecpm"];
                self.dfpRequest.customTargeting = targeting;
            } else {
                self.dfpRequest.customTargeting = @{@"ecpm": ecpmAsString};
            }
        } else {
            self.dfpRequest = [DFPRequest request];
            self.dfpRequest.customTargeting = @{@"ecpm": ecpmAsString};
        }
    } else {
        LogDebug(@"Ecpm not present in Polymorph response. Loading default DFP ad.");
    }

    [self.gAdLoader loadRequest:self.dfpRequest];
    
}

- (void)pmNativeAd:(PMNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    [self.gAdLoader loadRequest:[DFPRequest request]];
}

- (UIViewController *)pmViewControllerForPresentingModalView {
    return self.controller;
}

@end
