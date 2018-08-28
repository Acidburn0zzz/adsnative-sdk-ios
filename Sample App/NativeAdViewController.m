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

@interface NativeAdViewController () <GADAdLoaderDelegate, GADNativeAppInstallAdLoaderDelegate, GADNativeContentAdLoaderDelegate, GADBannerViewDelegate, DFPBannerAdLoaderDelegate>

@property (nonatomic, strong) PMNativeAd *nativeAd;
@property (nonatomic, strong) PMBannerView *pmBannerView;

@property (nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, strong) DFPBannerView *dfpBannerView;
@property (nonatomic, strong) PMBidder *bidder;
@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *pm_adunit = @"pm_adunit";
    NSString *dfp_adunit = @"dfp_adunit";
 
    [_loadAdButton addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.indicator stopAnimating];
    LogSetLevel(LogLevelDebug);
    GADNativeAdImageAdLoaderOptions *options = [[GADNativeAdImageAdLoaderOptions alloc] init];
    options.disableImageLoading = NO;
    options.shouldRequestMultipleImages = NO;

    //DFP Native Request
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:dfp_adunit rootViewController:self adTypes:@[kGADAdLoaderAdTypeNativeAppInstall, kGADAdLoaderAdTypeNativeContent] options:@[options]];

    //DFP Native-Banner Request
    //self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:dfp_adunit rootViewController:self adTypes:@[kGADAdLoaderAdTypeNativeContent,kGADAdLoaderAdTypeDFPBanner, kGADAdLoaderAdTypeNativeAppInstall] options:@[options]];
    self.adLoader.delegate = self;
    
    //DFP Banner Request
    //self.dfpBannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    //self.dfpBannerView.adUnitID = dfp_adunit;
    //self.dfpBannerView.rootViewController = self;
    //self.dfpBannerView.delegate = self;
    

    //Polymorph PMBidder init
    self.bidder = [[PMBidder alloc] initWithPMAdUnitID:pm_adunit];
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
    
    //DFP Native Request through Polymorph
    [self.bidder startWithAdLoader:self.adLoader viewController:self];
    
    //DFP Native-Banner Request through Polymorph
    //[self.bidder startWithAdLoader:self.adLoader viewController:self withBannerSize:kPMAdSizeMobileLeaderboard];
    
    //DFP Banner Request through Polymorph
    //[self.bidder startWithBannerView:self.dfpBannerView viewController:self withBannerSize:kPMAdSizeMobileLeaderboard];
    
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
    //important if both GADMediaView and imageview are accepted
    [nibView bringSubviewToFront:nibView.imageView];
    
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
    //important if both GADMediaView and imageview are accepted
    [nibView bringSubviewToFront:nibView.imageView];
    
    ((UIImageView *)nibView.logoView).image = nativeContentAd.logo.image;
    
    nibView.callToActionView.userInteractionEnabled = NO;
    
    [self.adViewContainer addSubview:nibView];
}

#pragma mark - <GADBannerViewDelegate>
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    [self.indicator stopAnimating];
    [self.adViewContainer addSubview:bannerView];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Banner ad request failed with error:%@",error);
    [self.indicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Banner ad failed to load"
                                                    message:@"Check console for more details"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    NSLog(@"Banner ad about to leave application");
}

#pragma mark - <DFPBannerAdLoaderDelegate>
- (NSArray<NSValue *> *)validBannerSizesForAdLoader:(GADAdLoader *)adLoader
{
    return @[
             @(kGADAdSizeBanner)
             ];
}

/// Tells the delegate that a DFP banner ad was received.
- (void)adLoader:(GADAdLoader *)adLoader didReceiveDFPBannerView:(DFPBannerView *)bannerView
{
    [self.indicator stopAnimating];
    [self.adViewContainer addSubview:bannerView];
}
@end
