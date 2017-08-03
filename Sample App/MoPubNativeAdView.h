//
//  MoPubNativeAdView.h
//  Sample App
//
//  Created by Arvind Bharadwaj on 31/07/17.
//  Copyright © 2017 AdsNative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPNativeAdRendering.h"


@interface MoPubNativeAdView : UIView <MPNativeAdRendering>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *callToActionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UIImageView *privacyInformationIconImageView;

@end
