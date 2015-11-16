//
//  ViewController.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 16/09/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) IBOutlet UITableView *tableView;

- (IBAction)dismissViewController:(id)sender;
@end

