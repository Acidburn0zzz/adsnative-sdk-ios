//
//  AdAssets.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 17/09/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/** Native Asset Keys */
extern const NSString *kNativeTitleKey;
extern const NSString *kNativeTextKey;
extern const NSString *kNativeIconImageKey;
extern const NSString *kNativeMainImageKey;
extern const NSString *kNativeCTATextKey;
extern const NSString *kNativeStarRatingKey;
//May be nil.
extern const NSString *kNativeMediaViewKey;

//Eg: "Sponsored", "Promoted"
extern const NSString *kNativeSponsoredKey;

//The Tag to be attached to `kNativeSponsoredKey` Eg: 'By advertiser'
extern const NSString *kNativeSponsoredByTagKey;

//May be nil. This returns a dictionary of developer defined custom assests. Only for AdsNative direct demand.
extern const NSString *kNativeCustomAssetsKey;