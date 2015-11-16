//
//  MoPubHiddenView.m
//  Sample App
//
//  Created by Arvind Bharadwaj on 04/11/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import "MoPubHiddenView.h"

@implementation MoPubHiddenView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end
