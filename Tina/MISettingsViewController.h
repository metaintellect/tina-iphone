//
//  MISettingsViewController.h
//  eRacun
//
//  Created by Kornelije Sajler on 6.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MISettingsViewController : UIViewController
        <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *settingsItems;

- (IBAction)close:(id)sender;

@end
