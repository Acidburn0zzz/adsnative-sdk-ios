//
//  STRAdHiddenView.h
//
//  Created by Arvind Bharadwaj on 06/01/16.
//  Copyright © 2016 AdsNative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SharethroughSDK/SharethroughSDK.h>

@interface STRAdHiddenView : UIView <STRAdView>

@property (nonatomic, strong) UILabel *strAdTitle;
@property (nonatomic, strong) UILabel *strAdDescription;
@property (nonatomic, strong) UILabel *strAdSponsoredText;
@property (nonatomic, strong) UIButton *strAdDisclosureButton;
@property (nonatomic, strong) UIImageView *strAdMainImage;
@property (nonatomic, strong) UIImageView *strAdIconImage;

@end
