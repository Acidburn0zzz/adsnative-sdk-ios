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
    self.gAdLoader = gAdLoader;
    self.controller = controller;
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
    
    DFPRequest *request = [DFPRequest request];
    if ([nativeAd.nativeAssets objectForKey:kNativeEcpmKey] != nil) {
        NSString *ecpmAsString = [NSString stringWithFormat:@"%.2f", self.nativeAd.biddingEcpm];
        request.customTargeting = @{@"ecpm": ecpmAsString};
        LogDebug(@"Making DFP request with ecpm: %@", ecpmAsString);
    } else {
        LogDebug(@"Ecpm not present in Polymorph response. Loading default DFP ad.");
    }
    request.testDevices = @[@"9E608075-8B96-417E-9C77-D5E3A4BB8CED"];
    [self.gAdLoader loadRequest:request];
    
}

- (void)pmNativeAd:(PMNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    [self.gAdLoader loadRequest:[DFPRequest request]];
}

- (UIViewController *)pmViewControllerForPresentingModalView {
    return self.controller;
}

@end
