//
//  ANAdTableViewCell2.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 09/10/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdsNativeSDK/AdsNativeSDK.h>

@interface ANAdTableViewCellNew : UITableViewCell <ANAdRendering>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *callToActionButton;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

@end
