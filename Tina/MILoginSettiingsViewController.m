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

@implementation MILoginSettiingsViewController {
    
}


#pragma mark - View Controller base methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
	[self _bindCustomDomainURLTextFiled];
}

#pragma mark - Action methods

- (IBAction)Save:(id)sender {
    
    NSString *customDomainURL = [self.customDomainURLTextField text];
    
    if ([MIHelper validUrl:customDomainURL]) {
       
        [MIHelper setCustomDomainURL:customDomainURL];
        [self _dismissView];
    }
    else
    {
        [MIHelper showAlerMessageWithTitle:NSLocalizedString(@"Invalid URL format", nil)
                               withMessage:NSLocalizedString(@"Please enter a valid URL e.g. \"http://example.com\".", nil)
                     withCancelButtonTitle:NSLocalizedString(@"OK", nil)];
        [self _resetCustomDomainURLTextFiled];
    }
}

- (IBAction)close:(id)sender {
    
    [self _dismissView];
}

#pragma mark - Private methods

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

- (void)_dismissView {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
