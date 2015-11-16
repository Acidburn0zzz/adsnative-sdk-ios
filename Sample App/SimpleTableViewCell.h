//
//  UITestTableViewCell.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 06/10/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
