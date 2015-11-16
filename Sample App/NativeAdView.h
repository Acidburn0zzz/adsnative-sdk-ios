//
//  NativeAdView.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 16/10/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdsNativeSDK/AdsNativeSDK.h>

@interface NativeAdView : UIView <ANAdRendering>

@property (strong, nonatomic) IBOutlet UILabel *adtitle;
@property (strong, nonatomic) IBOutlet UILabel *summary;
@property (strong, nonatomic) IBOutlet UIButton *cta;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UILabel *sponsoredText;

@end
