//
//  PMPrefetchAds.h
//  Sample App
//
//  Created by Arvind Bharadwaj on 31/07/17.
//  Copyright © 2017 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANNativeAd.h"

@interface PMPrefetchAds : NSObject

+ (instancetype)getInstance;
- (void)setAd:(ANNativeAd *)nativeAd;
- (ANNativeAd *)getAd;
- (void)clearCache;
- (void)getSize;

@end
