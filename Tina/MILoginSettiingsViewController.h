//
//  MILoginSettiingsViewController.h
//  eRacun
//
//  Created by Kornelije Sajler on 19.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MILoginSettiingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *customDomainURLTextField;

- (IBAction)Save:(id)sender;

- (IBAction)close:(id)sender;

@end
