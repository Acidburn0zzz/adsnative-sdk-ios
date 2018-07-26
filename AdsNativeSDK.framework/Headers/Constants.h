//
//  Constants.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 22/09/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define AN_SDK_VERSION              @"3.2.0"

#define AN_IOS_6_0 60000

#define MINIMUM_REFRESH_INTERVAL            10.0
#define DEFAULT_PMBANNER_REFRESH_INTERVAL     60

enum {
    PM_REQUEST_TYPE_NATIVE = 0,
    PM_REQUEST_TYPE_BANNER = 1,
    PM_REQUEST_TYPE_ALL = 2
};
typedef int PM_REQUEST_TYPE;

// Sizing constants.
extern CGSize const POLYMORPH_BANNER_SIZE;
extern CGSize const POLYMORPH_MEDIUM_RECT_SIZE;

extern const CGFloat kStarRatingUniversalScale;
extern const CGFloat kMaxStarRatingValue;
extern const CGFloat kMinStarRatingValue;
extern const NSTimeInterval kDefaultSecondsForImpression;
extern const NSTimeInterval kUpdateCellVisibilityInterval;
extern const NSString *backupClassPrefix;
