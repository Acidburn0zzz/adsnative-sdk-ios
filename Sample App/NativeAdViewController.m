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

@interface NativeAdViewController () <ANNativeAdDelegate>

@property (nonatomic, strong) ANNativeAd *nativeAd;

@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    
    [_loadTableViewButton addTarget:self action:@selector(loadTableViewAds) forControlEvents:UIControlEventTouchUpInside];
    [_loadNativeAdButton addTarget:self action:@selector(loadNativeAd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.indicator startAnimating];
    
    self.nativeAd = [[ANNativeAd alloc] initWithAdUnitId:@"_WSCwPg4czQD8NRuCC0v9qVObfyDj7FnQoZPW0uF" viewController:self];
    self.nativeAd.delegate = self;
    [self.nativeAd loadAd];
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
    [self.nativeAd loadAd];
}

- (void)loadTableViewAds
{
    TableViewController *tableViewController = [[TableViewController alloc] init];
    [self presentViewController:tableViewController animated:YES completion:nil];
}

#pragma mark - <ANNativeAdDelegate>
- (void)anNativeAdDidLoad:(ANNativeAd *)nativeAd {
    [self.indicator stopAnimating];
    
    //have a strong retain of the native ad instance
    self.nativeAd = nativeAd;
    
    //Use this for dynamic layout switching. Make sure your UIView class implements `ANAdRendering` protocol
    UIView *adView =[nativeAd renderNativeAdWithDefaultRenderingClass:[NativeAdView class]];
    
    adView.frame = self.adViewContainer.bounds;
    
    /* You may call this instead of `renderNativeAdWithDefaultRenderingClass` if you wish to pass the ad view directly.*/
//    [nativeAd registerNativeAdForView:adView];
    
    
    [self.adViewContainer addSubview:adView];
       
}

- (void)anNativeAd:(ANNativeAd *)nativeAd didFailWithError:(NSError *)error {
    NSLog(@"Native ad request failed with error:%@",error);
    [self.indicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Native ad failed to load"
                                                    message:@"Check console for more details"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)anNativeAdDidRecordImpression
{
    NSLog(@"Native Ad Impression Recorded");
}

- (BOOL)anNativeAdDidClick:(ANNativeAd *)nativeAd
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

@end
