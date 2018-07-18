//
//  PolymorphDFPNativeAdAdapter.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 16/07/18.
//  Copyright © 2018 AdsNative. All rights reserved.
//

#import "PolymorphDFPNativeAdAdapter.h"

@interface PolymorphDFPNativeAdAdapter()

@property (nonatomic, strong) PMNativeAd *pmNativeAd;

@end


@implementation PolymorphDFPNativeAdAdapter

- (instancetype)initWithPMNativeAd:(PMNativeAd *)nativeAd {
    if (self = [super init]) {
        self.pmNativeAd = nativeAd;
    }
    
    return self;
}

#pragma mark - <GADMediatedNativeAd>
- (id<GADMediatedNativeAdDelegate>)mediatedNativeAdDelegate {
    return self;
}

- (NSDictionary *)extraAssets {
    return NULL;
}


#pragma mark - <GADMediatedNativeContentAd, GADMediatedNativeAppInstallAd>

- (NSString *)advertiser {
    return [[self.pmNativeAd nativeAssets] objectForKey:kNativeSponsoredKey];
}

- (NSString *)body {
    return [[self.pmNativeAd nativeAssets] objectForKey:kNativeTextKey];
}

- (NSString *)callToAction {
    return [[self.pmNativeAd nativeAssets] objectForKey:kNativeCTATextKey];
}

- (NSString *)headline {
    return [[self.pmNativeAd nativeAssets] objectForKey:kNativeTitleKey];
}

//list of images of type GADNativeAdImage
- (NSArray *)images {
    NSString *uri = [[self.pmNativeAd nativeAssets] objectForKey:kNativeMainImageKey];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:uri]]];
    
    return @[[[GADNativeAdImage alloc] initWithImage:image]];
}

//brand image for content ad
- (GADNativeAdImage *)logo {
    NSString *uri = [[self.pmNativeAd nativeAssets] objectForKey:kNativeIconImageKey];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:uri]]];
    
    return [[GADNativeAdImage alloc] initWithImage:image];
}

//icon image for app ad
- (GADNativeAdImage *)icon {
    NSString *uri = [[self.pmNativeAd nativeAssets] objectForKey:kNativeIconImageKey];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:uri]]];
    
    return [[GADNativeAdImage alloc] initWithImage:image];
}

- (NSString *)price {
    return NULL;
}

- (NSDecimalNumber *)starRating {
    NSString *rating = [[self.pmNativeAd nativeAssets] objectForKey:kNativeStarRatingKey];
    return [NSDecimalNumber decimalNumberWithString:rating];
}

- (NSString *)store {
    return NULL;
}

#pragma mark - <GADMediatedNativeAdDelegate>

- (void)mediatedNativeAd:(id<GADMediatedNativeAd>)mediatedNativeAd didRenderInView:(UIView *)view {
    //left empty
}

- (void)mediatedNativeAdDidRecordImpression:(id<GADMediatedNativeAd>)mediatedNativeAd {
    [self.pmNativeAd trackImpression];
}

- (void)mediatedNativeAd:(id<GADMediatedNativeAd>)mediatedNativeAd
didRecordClickOnAssetWithName:(NSString *)assetName
                    view:(UIView *)view
          viewController:(UIViewController *)viewController {
    NSString *landingURL = [[self.pmNativeAd nativeAssets] objectForKey:kNativeLandingUrlKey];
    [self.pmNativeAd displayContentForURL:[NSURL URLWithString:landingURL] completion:nil];
}

@end
