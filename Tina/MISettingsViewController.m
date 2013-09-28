//
//  MISettingsViewController.m
//  eRacun
//
//  Created by Kornelije Sajler on 6.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MISettingsViewController.h"
#import "MIHelper.h"
#import "MILoginViewController.h"
#import "MIRestJSON.h"
#import "MIProductsViewController.h"


@interface MISettingsViewController ()

@end

@implementation MISettingsViewController {
    
    MIQuery *query;
}


#pragma mark - View Controller base methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    query = [[MIQuery alloc] init];
    self.settingsItems = [self _createSettingItems];
}

#pragma mark - Action methods

- (IBAction)close:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 1;
    if (section == 1) return [self.settingsItems count];
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"";
    if (section == 1) return @"";
    return @"Other";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCellItem"];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"Products List", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        NSString *labelText = (self.settingsItems)[[indexPath row]];
        
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:labelText];
    }
        
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = [indexPath row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (row) {
        case 0:
            if (indexPath.section == 0) {
               [self _showAllProductsView];
            } else {
                [self _syncProductsFromServer];
            }
            
            break;
        case 1:
            [self _logOutFromApplication];
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

#pragma mark - Private methods

- (NSArray *)_createSettingItems {
    
    NSString *syncProductsString = NSLocalizedString(@"Sync Products", nil);
    NSString *logoutString = NSLocalizedString(@"Log Out", nil);
    
    NSArray *result = @[syncProductsString, logoutString];
    
    return result;
}

- (void)_syncProductsFromServer {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [query removeAllProducts];

    
    [MIRestJSON callProductsApiAndSetProductsArrayForToken:[MIHelper getAuthToken]];
}

- (void)_logOutFromApplication {
    
    [MIHelper setAuthToken:nil AndUserId:nil AndCashRegisterId:nil];
    
    //[MIHelper getAuthToken];
    MILoginViewController *loginController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                       instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void)_showAllProductsView {
    
    MIProductsViewController *productsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                              instantiateViewControllerWithIdentifier:@"ProductsViewController"];
    
    [self.navigationController pushViewController:productsController animated:YES];
}

@end
