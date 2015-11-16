//
//  UIViewTestViewController.m
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 13/10/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "NativeAdViewController.h"
#import <AdsNativeSDK/ANNativeAd.h>
#import <AdsNativeSDK/ANNativeAdDelegate.h>
#import "TableViewController.h"

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
    
    self.nativeAd = [[ANNativeAd alloc] initWithAdUnitId:@"mZE7zov4RiWtwOWAZpemlRBJVMur26isJ-HexPyk"];
    self.nativeAd.delegate = self;
    [self.nativeAd loadAd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nativeAdDidLoad:(ANNativeAd *)nativeAd {

    //Use this for dynamic layout switching. Make sure your UIView class implements `ANAdRendering` protocol
//    UIView * adView = [nativeAd renderNativeAdWithController:self defaultRenderingClass:[NativeAdView class]];
   
    UIView *adView = [[NativeAdView alloc] init];
 
    CGRect frame = self.adViewContainer.frame;
    //resetting the origin of the frame otherwise subview will be displaced
    frame.origin = CGPointMake(0.0f, 0.0f);
    [adView setFrame:frame];
    
    [nativeAd registerNativeAdWithController:self forView:adView];
    
    //Removing all subviews (adView) from adViewContainer
    [[self.adViewContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.adViewContainer addSubview:adView];
    
    [self.indicator stopAnimating];
    
}

- (void)nativeAd:(ANNativeAd *)nativeAd didFailWithError:(NSError *)error {
    NSLog(@"Native ad request failed with error:%@",error);
    [self.indicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Native ad failed to load"
                                                    message:@"Check console for more details"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)nativeAdDidRecordImpression
{
    NSLog(@"Native Ad Impression Recorded");
}

- (void)nativeAdDidClick
{
    NSLog(@"Native Ad Did Click");
}


- (void)loadNativeAd
{
    [self.indicator startAnimating];
    [self.nativeAd loadAd];
}

- (void)loadTableViewAds
{
    TableViewController *tableViewController = [[TableViewController alloc] init];
    [self presentViewController:tableViewController animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
