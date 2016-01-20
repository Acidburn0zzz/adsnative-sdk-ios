//
//  ANAdTableViewCell.m
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 06/10/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import "ANAdTableViewCell.h"

@implementation ANAdTableViewCell

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
    [adObject loadSponsoredTagIntoLabel:self.sponsoredText];
    [adObject loadImageIntoImageView:self.mainImageView];
    
}

+ (CGSize)sizeWithMaximumWidth:(CGFloat)maximumWidth
{
    return CGSizeMake(maximumWidth, 230);
}

// You MUST implement this method if YourNativeAdCell uses a nib
+ (NSString *)nibForAd
{
    return @"ANAdTableViewCell";
}

@end
