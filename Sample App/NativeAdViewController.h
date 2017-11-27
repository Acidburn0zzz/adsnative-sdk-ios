//
//  UIViewTestViewController.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 13/10/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NativeAdView.h"

@interface NativeAdViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *adViewContainer;

@property (strong, nonatomic) IBOutlet UIButton *loadTableViewButton;
@property (strong, nonatomic) IBOutlet UIButton *loadAdButton;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
