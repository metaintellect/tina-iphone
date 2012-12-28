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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.settingsItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCellItem"];
    
    NSString *labelText = [self.settingsItems objectAtIndex:[indexPath row]];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:labelText];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = [indexPath row];
    
    if (0 == row) {
        
        [self _syncProductsFromServer];
        
    } else if (1 == row) {
        
        [self _logOutFromApplication];
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
    
  //  [MIHelper setAuthToken:nil AndUserId:nil AndCashRegisterId:nil];
    
    //[MIHelper getAuthToken];
    MILoginViewController *loginController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                       instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self presentViewController:loginController animated:YES completion:nil];
}

@end
