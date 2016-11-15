//
//  STRAdHiddenView.m
//
//  Created by Arvind Bharadwaj on 06/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import "STRAdHiddenView.h"

@implementation STRAdHiddenView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.strAdTitle = [[UILabel alloc] init];
        self.strAdSponsoredText = [[UILabel alloc] init];
        self.strAdDescription = [[UILabel alloc] init];
        self.strAdMainImage = [[UIImageView alloc] init];
        self.strAdMainImage.userInteractionEnabled = YES;
        self.strAdIconImage = [[UIImageView alloc] init];
        self.strAdDisclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        self.strAdDisclosureButton.userInteractionEnabled = YES;
    }
    return self;
}

- (UILabel *)adTitle
{
    return self.strAdTitle;
}

- (UIImageView *)adThumbnail
{
    return self.strAdMainImage;
}

- (UILabel *)adSponsoredBy
{
    return self.strAdSponsoredText;
}

- (UIButton *)disclosureButton
{
    return self.strAdDisclosureButton;
}

- (UILabel *)adDescription
{
    return self.strAdDescription;
}

- (UIImageView *)adBrandLogo
{
    return self.strAdIconImage;
}
@end
