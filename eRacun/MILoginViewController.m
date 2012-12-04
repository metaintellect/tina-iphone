//
//  MILoginViewController.m
//  eRacun
//
//  Created by Kornelije Sajler on 3.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MILoginViewController.h"

@interface MILoginViewController ()

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@end

@implementation MILoginViewController

- (void)viewDidLoad
{
    [[self usernameTextFileld] becomeFirstResponder];
}

- (IBAction)login:(id)sender
{
    [self _validateAndRedirect:sender];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1)
    {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        [self _validateAndRedirect:textField];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if (([textField tag] == 2 && [allTrim([self.usernameTextFileld text]) length] != 0)
        || ( [textField tag] == 1 && [allTrim([self.passwordTextField text]) length] != 0))
    {
        [self.loginButton setEnabled:YES];
    }
    
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self _animateLoginControlsOnYAxis:102 usernameTextField:108 passwordTextField:147 loginButton:194];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.loginButton setEnabled: NO];
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    [self _animateLoginControlsOnYAxis:162 usernameTextField:168 passwordTextField:207 loginButton:254];
}

- (void)_validateAndRedirect:(id)sender
{
    if ([[self.usernameTextFileld text] isEqualToString:@"xajler"]
        && [[self.passwordTextField text] isEqualToString:@"aeon"])
    {
        [self performSegueWithIdentifier:@"LoginSegue" sender:sender];
    }
    else
    {
        [self.passwordTextField setText:@""];
        [self.passwordTextField becomeFirstResponder];
    }
}

- (void)_animateLoginControlsOnYAxis:(CGFloat)yInputImageValue
                   usernameTextField:(CGFloat)yUsernameValue
                   passwordTextField:(CGFloat)yPasswordValue
                         loginButton:(CGFloat)yButtonValue

{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame;
        
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
