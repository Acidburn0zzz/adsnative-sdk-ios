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
@property (nonatomic, strong) PMBannerView *pmBannerView;
@property (nonatomic, strong) ANAdRequestTargeting *targeting;

@property (nonatomic, strong) GADAdLoader *gAdLoader;
@property (nonatomic, strong) DFPRequest *dfpRequest;
@property (nonatomic, strong) NSString *pmAdUnitID;
@property (nonatomic, weak) id<GADAdLoaderDelegate> delegate;

@property (nonnull, strong) DFPBannerView *dfpBannerView;

@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, assign) PM_REQUEST_TYPE requestType;
@end

static NSString *EcpmKey = @"ecpm";

@implementation PMBidder

#pragma mark - Init for Native Ads
- (instancetype)initWithPMAdUnitID:(NSString *)adUnitID viewController:(UIViewController *)controller requestType:(PM_REQUEST_TYPE)requestType
{
    return [self initWithPMAdUnitID:adUnitID viewController:controller requestType:requestType withBannerSize:CGSizeMake(0, 0)];
}

#pragma mark - Init for Banner and Native-Banner Ads
- (instancetype)initWithPMAdUnitID:(NSString *)adUnitID viewController:(UIViewController *)controller requestType:(PM_REQUEST_TYPE)requestType withBannerSize:(CGSize)bannerSize
{
    self = [super init];
    if (self) {
        self.pmAdUnitID = adUnitID;
        self.controller = controller;
        self.requestType = requestType;

        //Initialize the PM SDK
        self.pmClass = [[PMClass alloc] initWithAdUnitID:self.pmAdUnitID requestType:self.requestType withBannerSize:bannerSize];
        self.pmClass.delegate = self;
        //Disable banner refresh
        if (self.requestType == PM_REQUEST_TYPE_BANNER)
            [self.pmClass stopAutomaticallyRefreshingContents];

        //Set PM targeting
        self.targeting = [ANAdRequestTargeting targeting];
        NSMutableArray *keywords = [[NSMutableArray alloc] init];
        [keywords addObject:@"&hb=1"];
        self.targeting.keywords = keywords;
    }
    return self;
}

#pragma mark - Native and Native-Banner Ad Call
- (void)startWithAdLoader:(GADAdLoader *)gAdLoader
{
    [self startWithAdLoader:gAdLoader dfpRequest:[DFPRequest request]];
}

- (void)startWithAdLoader:(GADAdLoader *)gAdLoader dfpRequest:(DFPRequest *)request
{
    assert((self.requestType == PM_REQUEST_TYPE_NATIVE) ||  (self.requestType == PM_REQUEST_TYPE_ALL));

    self.gAdLoader = gAdLoader;
    self.dfpRequest = request;
    
    //clear PM ad cache before making a fresh request
    [[PMPrefetchAds getInstance] clearCache];

    [self.pmClass loadPMAdWithTargeting:self.targeting];
}

#pragma mark - Banner Ad Call

- (void)startWithBannerView:(DFPBannerView *)dfpBannerView
{
    [self startWithBannerView:dfpBannerView dfpRequest:[DFPRequest request]];
}

- (void)startWithBannerView:(DFPBannerView *)dfpBannerView dfpRequest:(DFPRequest *)request
{
    assert(self.requestType == PM_REQUEST_TYPE_BANNER);

    self.dfpBannerView = dfpBannerView;
    self.dfpRequest = request;
    
    //clear PM ad cache before making a fresh request
    [[PMPrefetchAds getInstance] clearCache];
    
    [self.pmClass loadPMAdWithTargeting:self.targeting];
}

#pragma mark - <PMCLassDelegate>
- (void)pmNativeAdDidLoad:(PMNativeAd *)nativeAd
{
    self.nativeAd = nativeAd;
    [[PMPrefetchAds getInstance] setAd:self.nativeAd];
    
    if ([nativeAd.nativeAssets objectForKey:kNativeEcpmKey] != nil) {
        NSString *ecpmAsString = [NSString stringWithFormat:@"%.2f", self.nativeAd.biddingEcpm];
        
        LogDebug(@"Making DFP request with ecpm: %@", ecpmAsString);
        
        NSMutableDictionary *targeting = [NSMutableDictionary dictionaryWithDictionary:(self.dfpRequest.customTargeting ? self.dfpRequest.customTargeting : @{})];
        [targeting setObject:ecpmAsString forKey:EcpmKey];

        self.dfpRequest.customTargeting = targeting;
    } else {
        LogDebug(@"Ecpm not present in Polymorph response. Loading default DFP ad.");
    }
    
    [self.gAdLoader loadRequest:self.dfpRequest];
    
}

- (void)pmNativeAd:(PMNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    [self.gAdLoader loadRequest:self.dfpRequest];
}

- (void)pmBannerAdDidLoad:(PMBannerView *)adView
{
    self.pmBannerView = adView;
    [[PMPrefetchAds getInstance] setBannerAd:self.pmBannerView];
    
    if (self.pmBannerView.biddingEcpm != -1) {
        NSString *ecpmAsString = [NSString stringWithFormat:@"%.2f", self.pmBannerView.biddingEcpm];
        
        LogDebug(@"Making DFP request with ecpm: %@", ecpmAsString);
        
        NSMutableDictionary *targeting = [NSMutableDictionary dictionaryWithDictionary:(self.dfpRequest.customTargeting ? self.dfpRequest.customTargeting : @{})];
        [targeting setObject:ecpmAsString forKey:EcpmKey];

        self.dfpRequest.customTargeting = targeting;
    } else {
        LogDebug(@"Ecpm not present in Polymorph response. Loading default DFP ad.");
    }
    [self.dfpBannerView loadRequest:self.dfpRequest];
}

- (void)pmBannerAdDidFailToLoad:(PMBannerView *)view withError:(NSError *)error
{
    [self.dfpBannerView loadRequest:self.dfpRequest];
}

- (UIViewController *)pmViewControllerForPresentingModalView {
    return self.controller;
}

@end
