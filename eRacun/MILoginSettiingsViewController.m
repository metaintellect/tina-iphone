//
//  MILoginSettiingsViewController.m
//  eRacun
//
//  Created by Kornelije Sajler on 19.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MILoginSettiingsViewController.h"
#import "MIHelper.h"

@interface MILoginSettiingsViewController ()

@end

@implementation MILoginSettiingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
	[self _bindCustomDomainURLTextFiled];
}

- (IBAction)Save:(id)sender {
    
    NSString *customDomainURL = [self.customDomainURLTextField text];
    
    if ([MIHelper validUrl:customDomainURL]) {
       
        [MIHelper setCustomDomainURL:customDomainURL];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [MIHelper showAlerMessageWithTitle:NSLocalizedString(@"Invalid URL format", nil)
                               withMessage:NSLocalizedString(@"Please enter a valid URL e.g. \"http://example.com\".", nil)
                     withCancelButtonTitle:NSLocalizedString(@"OK", nil)];
        [self _resetCustomDomainURLTextFiled];
    }
}

#pragma match "Private methods"

- (void)_bindCustomDomainURLTextFiled {
    
    NSString *customDomainURL = [[NSUserDefaults standardUserDefaults] stringForKey:kCustomDomainURL];
    
    if ([MIHelper validUrl:customDomainURL]) {
        
        [self.customDomainURLTextField setText:customDomainURL];
        
    } else {
        
        [self _resetCustomDomainURLTextFiled];
    }
}

- (void)_resetCustomDomainURLTextFiled {
        
    [self.customDomainURLTextField becomeFirstResponder];
    [self.customDomainURLTextField setText:@"http://"];
}
@end
