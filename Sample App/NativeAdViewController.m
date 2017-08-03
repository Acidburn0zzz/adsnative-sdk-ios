//
//  UIViewTestViewController.m
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 13/10/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "NativeAdViewController.h"
#import "TableViewController.h"

#import <AdsNativeSDK/AdsNativeSDK.h>

#import "PMBidder.h"

#import "MPNativeAdRequest.h"
#import "MPNativeAd.h"
#import "MPNativeAdRenderer.h"
#import "MPNativeAdRendererConfiguration.h"
#import "MoPubNativeAdView.h"
#import "MPStaticNativeAdRendererSettings.h"
#import "MPStaticNativeAdRenderer.h"
#import "MPNativeAdDelegate.h"
#import "MPLogging.h"

@interface NativeAdViewController () <MPNativeAdDelegate>

@property (nonatomic, strong) ANNativeAd *nativeAd;

@property (nonatomic, strong) MPNativeAd *mpNativeAd;
@property (nonatomic, strong) MPNativeAdRequest *mpNativeAdRequest;

@property (nonatomic, strong) PMBidder *bidder;

@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    
    [_loadTableViewButton addTarget:self action:@selector(loadTableViewAds) forControlEvents:UIControlEventTouchUpInside];
    [_loadNativeAdButton addTarget:self action:@selector(loadNativeAd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.indicator stopAnimating];
    /****** MoPub code for ad call ******/
    MPStaticNativeAdRendererSettings *settings = [[MPStaticNativeAdRendererSettings alloc] init];
    settings.renderingViewClass = [MoPubNativeAdView class];
    
    
    MPNativeAdRendererConfiguration *config = [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:settings];
    NSMutableArray *supportedCustomEvents = [[NSMutableArray alloc] initWithArray:config.supportedCustomEvents];
    [supportedCustomEvents addObject:@"PolymorphNativeCustomEvent"];
    //List of supported networks that mopub can render into
    config.supportedCustomEvents = supportedCustomEvents;
    
    self.mpNativeAdRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:@"918839774b5e495885d47bb08d0a8758" rendererConfigurations:@[config]];
    
    self.bidder = [[PMBidder alloc] initWithPMAdUnitID:@"ping"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNativeAd
{
    //Removing all subviews (adView) from adViewContainer
    [[self.adViewContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.indicator startAnimating];
    
    [self.bidder startWithAdRequest:self.mpNativeAdRequest viewController:self  completionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        [self.indicator stopAnimating];
        if (error) {
            // Handle error.
        } else {
            self.mpNativeAd = response;
            self.mpNativeAd.delegate = self;
            UIView *nativeAdView = [response retrieveAdViewWithError:nil];
            nativeAdView.frame = self.adViewContainer.bounds;
            [self.adViewContainer addSubview:nativeAdView];
        }
    }];
}

- (void)loadTableViewAds
{
    TableViewController *tableViewController = [[TableViewController alloc] init];
    [self presentViewController:tableViewController animated:YES completion:nil];
}


#pragma mark - <MPNativeAdDelegate>
- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}
@end
