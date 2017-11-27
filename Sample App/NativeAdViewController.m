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

@interface NativeAdViewController () <PMClassDelegate>

@property (nonatomic, strong) PMClass *pmClass;
@property (nonatomic, strong) PMNativeAd *nativeAd;
@property (nonatomic, strong) PMBannerView *pmBannerView;

@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    
    [_loadTableViewButton addTarget:self action:@selector(loadTableViewAds) forControlEvents:UIControlEventTouchUpInside];
    [_loadAdButton addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.indicator startAnimating];
    
    /****** Polymorph code for ad call ******/
    LogSetLevel(LogLevelDebug);
    self.pmClass = [[PMClass alloc] initWithAdUnitID:@"ping" requestType:PM_REQUEST_TYPE_NATIVE withBannerSize:CGSizeMake(0, 0)];
    
    //For banner requests
//    self.pmClass  = [[PMClass alloc] initWithAdUnitID:@"pUW7n6VJQesm68GmdYyDA4IZhNzjm8CC3KrDVzLU" requestType:PM_REQUEST_TYPE_BANNER withBannerSize:self.adViewContainer.bounds.size];

    self.pmClass.delegate = self;
    
    [self.indicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAd
{
    //Removing all subviews (adView) from adViewContainer
    [[self.adViewContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.indicator startAnimating];
    [self.pmClass loadPMAd];
}

- (void)loadTableViewAds
{
    TableViewController *tableViewController = [[TableViewController alloc] init];
    [self presentViewController:tableViewController animated:YES completion:nil];
}

#pragma mark - <PMClassDelegate>
- (void)pmNativeAdDidLoad:(PMNativeAd *)nativeAd {
    [self.indicator stopAnimating];
    
    //have a strong retain of the native ad instance
    self.nativeAd = nativeAd;
    
    //Use this for dynamic layout switching. Make sure your UIView class implements `ANAdRendering` protocol
    UIView *adView =[nativeAd renderNativeAdWithDefaultRenderingClass:[NativeAdView class] withBounds:self.adViewContainer.bounds];
    
    /* You may call this instead of `renderNativeAdWithDefaultRenderingClass` if you wish to pass the ad view directly.*/
//    [nativeAd registerNativeAdForView:adView];
    
    
    [self.adViewContainer addSubview:adView];
       
}

- (void)pmNativeAd:(PMNativeAd *)nativeAd didFailWithError:(NSError *)error {
    NSLog(@"Native ad request failed with error:%@",error);
    [self.indicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Native ad failed to load"
                                                    message:@"Check console for more details"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)pmNativeAdDidRecordImpression
{
    NSLog(@"Native Ad Impression Recorded");
}

- (BOOL)pmNativeAdDidClick:(PMNativeAd *)nativeAd
{
    NSLog(@"Native Ad Did Click");
//    NSString *landingUrl = [nativeAd.nativeAssets objectForKey:kNativeLandingUrlKey];
//    NSLog(@"Landing url:%@",landingUrl);
//    if ([nativeAd.providerName isEqualToString:@"adsnative"]) {
//
//        /** Handle Click **/
//        return YES;
//    } else {
//        return NO;
//    }
    
    return NO;
}

- (void)pmBannerAdDidLoad:(PMBannerView *)adView
{
    [self.indicator stopAnimating];
    [self.adViewContainer addSubview:adView];
    NSLog(@"Banner loaded");
}

- (void)pmBannerAdDidFailToLoad:(PMBannerView *)view withError:(NSError *)error
{
    [self.indicator stopAnimating];
    NSLog(@"Banner failed to load %@", error);
}

- (UIViewController *)pmViewControllerForPresentingModalView
{
    return self;
}
@end
