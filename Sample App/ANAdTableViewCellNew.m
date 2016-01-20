//
//  ANAdTableViewCell2.m
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 09/10/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "ANAdTableViewCellNew.h"

@implementation ANAdTableViewCellNew

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutAdAssets:(ANNativeAd *)adObject
{
    [adObject loadTitleIntoLabel:self.titleLabel];
    [adObject loadTextIntoLabel:self.mainTextLabel];
    [adObject loadCallToActionTextIntoButton:self.callToActionButton];
    [adObject loadIconIntoImageView:self.iconImageView];
}

+ (CGSize)sizeWithMaximumWidth:(CGFloat)maximumWidth
{
    return CGSizeMake(maximumWidth, 78);
}

// You MUST implement this method if YourNativeAdCell uses a nib
+ (NSString *)nibForAd
{
    return @"ANAdTableViewCellNew";
}

@end
