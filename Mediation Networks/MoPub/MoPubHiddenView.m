//
//  MoPubHiddenView.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 04/11/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "MoPubHiddenView.h"

@implementation MoPubHiddenView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.privacyIconImage = [[UIImageView alloc] init];
    }
    return self;
}

- (UIImageView *)nativePrivacyInformationIconImageView
{
    return self.privacyIconImage;
}

@end
