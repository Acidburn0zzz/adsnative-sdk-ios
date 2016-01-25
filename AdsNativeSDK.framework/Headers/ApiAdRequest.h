//
//  ApiAdRequest.h
//
//  Created by Arvind Bharadwaj on 08/12/15.
//  Copyright © 2015 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANAdRequestTargeting.h"

@protocol ApiAdRequestDelegate <NSObject>

@optional
- (void)requestDidFinishWithResponse:(NSDictionary *)response;
- (void)requestDidFailWithResponse:(NSDictionary *)response withError:(NSError *)error;

@end

@interface ApiAdRequest : NSObject

@property (nonatomic, strong) NSDictionary *info;

@property (nonatomic, weak) id<ApiAdRequestDelegate> delegate;

- (void)loadAdWithAdUnitId:(NSString *)adUnitId targeting:(ANAdRequestTargeting *)targeting andPostBody:(NSDictionary *)postBody;

@end
