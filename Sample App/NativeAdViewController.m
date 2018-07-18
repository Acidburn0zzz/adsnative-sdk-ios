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

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "DFPNativeAdView.h"
#import "DFPNativeContentAdView.h"
#import "PMBidder.h"

@interface NativeAdViewController () <GADAdLoaderDelegate, GADNativeAppInstallAdLoaderDelegate, GADNativeContentAdLoaderDelegate>

@property (nonatomic, strong) PMNativeAd *nativeAd;
@property (nonatomic, strong) PMBannerView *pmBannerView;

@property (nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, strong) PMBidder *bidder;
@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_loadAdButton addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.indicator stopAnimating];
    
    GADNativeAdImageAdLoaderOptions *options = [[GADNativeAdImageAdLoaderOptions alloc] init];
    options.disableImageLoading = NO;
    options.shouldRequestMultipleImages = NO;
    
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:@"/21666124832/pm_test" rootViewController:self adTypes:@[kGADAdLoaderAdTypeNativeAppInstall, kGADAdLoaderAdTypeNativeContent] options:@[options]];
    
    self.adLoader.delegate = self;
    
    self.bidder = [[PMBidder alloc] initWithPMAdUnitID:@"NosADe7KvUy4b326YAeoGdVcIhxIwhKFAlje1GWv"];
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
    [self.bidder startWithAdLoader:self.adLoader viewController:self];
}

#pragma mark - <GADAdLoaderDelegate>
- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    NSLog(@"Native ad request failed with error:%@",error);
    [self.indicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Native ad failed to load"
                                                    message:@"Check console for more details"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - <GADNativeAppInstallAdLoaderDelegate>
- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveNativeAppInstallAd:(nonnull GADNativeAppInstallAd *)nativeAppInstallAd {
    NSLog(@"Received DFP app install ad");
    [self.indicator stopAnimating];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DFPNativeAdView" owner:nil options:nil];
    DFPNativeAdView *nibView = [nibObjects objectAtIndex:0];
    nibView.nativeAppInstallAd = nativeAppInstallAd;
    
    ((UILabel *)nibView.headlineView).text = nativeAppInstallAd.headline;
    ((UILabel *)nibView.bodyView).text = nativeAppInstallAd.body;
    [((UIButton *)nibView.callToActionView)setTitle:nativeAppInstallAd.callToAction
                                           forState:UIControlStateNormal];
    
    GADNativeAdImage *firstImage = nativeAppInstallAd.images.firstObject;
    ((UIImageView *)nibView.imageView).image = firstImage.image;
    ((UIImageView *)nibView.iconView).image = nativeAppInstallAd.icon.image;
    
    nibView.callToActionView.userInteractionEnabled = NO;
    
    [self.adViewContainer addSubview:nibView];
}

#pragma mark - <GADNativeContentAdLoaderDelegate>
- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveNativeContentAd:(nonnull GADNativeContentAd *)nativeContentAd {
    NSLog(@"Received DFP content ad");
    [self.indicator stopAnimating];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DFPNativeContentAdView" owner:nil options:nil];
    DFPNativeContentAdView *nibView = [nibObjects objectAtIndex:0];
    nibView.nativeContentAd = nativeContentAd;
    
    ((UILabel *)nibView.headlineView).text = nativeContentAd.headline;
    ((UILabel *)nibView.bodyView).text = nativeContentAd.body;
    [((UIButton *)nibView.callToActionView)setTitle:nativeContentAd.callToAction
                                           forState:UIControlStateNormal];
    
    GADNativeAdImage *firstImage = nativeContentAd.images.firstObject;
    ((UIImageView *)nibView.imageView).image = firstImage.image;
    ((UIImageView *)nibView.logoView).image = nativeContentAd.logo.image;
    
    nibView.callToActionView.userInteractionEnabled = NO;
    
    [self.adViewContainer addSubview:nibView];
}


@end
