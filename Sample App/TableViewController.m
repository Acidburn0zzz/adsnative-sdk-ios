//
//  ViewController.m
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 16/09/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import "TableViewController.h"
#import "SimpleTableViewCell.h"

#import "ANAdTableViewCell.h"
#import "ANAdTableViewCellNew.h"

#import <AdsNativeSDK/AdsNativeSDK.h>

@interface TableViewController ()

@property (nonatomic,strong) NSArray *tableData;
@property (nonatomic,strong) NSArray *thumbnails;
@property (nonatomic,strong) NSArray *prepTimes;

@property (nonatomic,strong) ANTableViewAdPlacer *placer;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initialize table data
    _tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];

    // Initialize thumbnails
    _thumbnails = [NSArray arrayWithObjects:@"egg_benedict.jpg", @"mushroom_risotto.jpg", @"full_breakfast.jpg", @"hamburger.jpg", @"ham_and_egg_sandwich.jpg", @"creme_brelee.jpg", @"white_chocolate_donut.jpg", @"starbucks_coffee.jpg", @"vegetable_curry.jpg", @"instant_noodle_with_egg.jpg", @"noodle_with_bbq_pork.jpg", @"japanese_noodle_with_pork.jpg", @"green_tea.jpg", @"thai_shrimp_cake.jpg", @"angry_birds_cake.jpg", @"ham_and_cheese_panini.jpg", nil];
    
    //initialize prep times
    _prepTimes = [NSArray arrayWithObjects:@"30min",@"25min",@"40min",@"15min",@"10min",@"45min",@"40min",
                  @"10min",@"15min",@"5min",@"15min",@"20min",@"5min",@"50min",@"55min",@"30min",nil];

    ANServerAdPositions *serverAdPositions = [[ANServerAdPositions alloc] init];
    
    //The defaultRenderingClass can be switched to `ANAdTableViewCellNew` dynamically by specifying it in the AdsNative UI
    self.placer = [ANTableViewAdPlacer placerWithTableView:self.tableView viewController:self adPositions:serverAdPositions defaultAdRenderingClass:[ANAdTableViewCell class]];
    
    [self.placer loadAdsForAdUnitID:@"I6jzxM3nheJk4RVIstiPKGN7YHOBKag-Q_5b0AnV"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableViewCell *cell = (SimpleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.text = [_tableData objectAtIndex:indexPath.row];
    cell.thumbnailImageView.image = [UIImage imageNamed:[_thumbnails objectAtIndex:indexPath.row]];
    cell.prepTimeLabel.text = [_prepTimes objectAtIndex:indexPath.row];;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (IBAction)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
