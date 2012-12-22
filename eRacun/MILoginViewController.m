//
//  MILoginViewController.m
//  eRacun
//
//  Created by Kornelije Sajler on 3.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MILoginViewController.h"
#import "MIAppDelegate.h"
#import "MIHelper.h"
#import "Account.h"
#import "MIQuery.h"
#import "MIRestJSON.h"

@interface MILoginViewController ()

@end

@implementation MILoginViewController {
    
}

#pragma mark - View Controller base methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.query = [[MIQuery alloc] init];
    [self.usernameTextFileld becomeFirstResponder];
    
    if (![MIHelper validUrl:[MIHelper getCustomDomainURL]]) {
                
        [MIHelper showAlerMessageWithTitle:NSLocalizedString(@"Custom Domain URL missing!", nil)
                               withMessage:NSLocalizedString(@"Please use info button to set Custom Domain URL.", nil)
                     withCancelButtonTitle:NSLocalizedString(@"OK", nil)];
    }        
}

#pragma mark - Action methods

- (IBAction)login:(id)sender {
    
    [self _validateAndRedirect:sender];
}

- (IBAction)openInfoPage:(id)sender {
    
    NSURL *url = [NSURL URLWithString:kMoreInfoPage];
    [[UIApplication sharedApplication] openURL:url];
}


//- (IBAction)createAccount:(id)sender {
//    
//    NSString *phoneNumber = [@"tel:" stringByAppendingString:@"0959108324"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
//}


#pragma mark - Text Field Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [passwordTextField becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
        [self _validateAndRedirect:textField];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                                                       replacementString:(NSString *)string {
    
    if ( ([textField tag] == 2 && [allTrim([self.usernameTextFileld text]) length] != 0)
        || ( [textField tag] == 1 && [allTrim([self.passwordTextField text]) length] != 0)) {
        
        [self.loginButton setEnabled:YES];
    }
    
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    [self _animateLoginControlsOnYAxis:35 inputImageView:102 usernameTextField:108 passwordTextField:147 loginButton:194];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [self.loginButton setEnabled: NO];
    return YES;
}


#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    [self _animateLoginControlsOnYAxis:95 inputImageView:162 usernameTextField:168 passwordTextField:207 loginButton:254];
}


#pragma mark - Private methods

- (void)_validateAndRedirect:(id)sender {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSError *error;
    
    NSDictionary *jsonValues = @{
        @"username" : [self.usernameTextFileld text],
        @"password" : [self.passwordTextField text]
    };
    
    NSMutableURLRequest *request = [MIRestJSON constructRequestForApiAction:@"login" withJSONValues:jsonValues error:error];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               
                if ([MIRestJSON callLoginApiAndPersistedAccountForData:data error:error]) {
                                   
                    [self performSelectorOnMainThread:@selector(_performAuthenticatedLoginSegue)
                                           withObject:nil
                                        waitUntilDone:YES];
                } else {
                    
                    [MIHelper showAlerMessageWithTitle:NSLocalizedString(@"Error", nil)
                                           withMessage:NSLocalizedString(@"Username and/or password are incorrect", nil)
                                 withCancelButtonTitle:NSLocalizedString(@"OK", nil)];
                    
                    [self.passwordTextField setText:@""];
                    [self.passwordTextField becomeFirstResponder];
                }
                               
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       }];            
}


- (void)_performAuthenticatedLoginSegue
{
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

- (void)_animateLoginControlsOnYAxis:(CGFloat)yLogo
                      inputImageView:(CGFloat)yInputImageValue
                   usernameTextField:(CGFloat)yUsernameValue
                   passwordTextField:(CGFloat)yPasswordValue
                         loginButton:(CGFloat)yButtonValue {
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame;
        
        frame = self.logoImage.frame;
        frame.origin.y = yLogo;
        self.logoImage.frame = frame;
        
        frame = self.loginInputImage.frame;
        frame.origin.y = yInputImageValue;
        self.loginInputImage.frame = frame;
        
        frame = self.usernameTextFileld.frame;
        frame.origin.y = yUsernameValue;
        self.usernameTextFileld.frame = frame;
        
        frame = self.passwordTextField.frame;
        frame.origin.y = yPasswordValue;
        self.passwordTextField.frame = frame;
        
        frame = self.loginButton.frame;
        frame.origin.y = yButtonValue;
        self.loginButton.frame = frame;
    }];
}
@end
