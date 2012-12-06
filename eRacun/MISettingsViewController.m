//
//  MISettingsViewController.m
//  eRacun
//
//  Created by Kornelije Sajler on 6.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MISettingsViewController.h"
#import "MILoginViewController.h"

@interface MISettingsViewController ()

@end

@implementation MISettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.settingsItems = [self _createSettingItems];
}

- (IBAction)close:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settingsItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

-(NSArray *)_createSettingItems {
    
    NSString *syncProductsString = NSLocalizedString(@"Sync Products", nil);
    NSString *logoutString = NSLocalizedString(@"Log Out", nil);
    
    NSArray *result = @[syncProductsString, logoutString];
    
    for (NSString *text in result) {
        NSLog(@"%@", text);
    }
    
    return result;
}

-(void)_syncProductsFromServer {
    
    NSLog(@"Doing syncing");
}

-(void)_logOutFromApplication {
    MILoginViewController *loginController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                       instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self presentViewController:loginController animated:YES completion:nil];
}

@end
