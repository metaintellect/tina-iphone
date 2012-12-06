//
//  MIMainViewController.m
//  eRacun
//
//  Created by Kornelije Sajler on 3.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MIMainViewController.h"
#import <ViewDeck/IIViewDeckController.h>

@interface MIMainViewController ()

@end

@implementation MIMainViewController
{
    NSArray *products;
}


#pragma mark - View Controller methods

- (void)viewDidLoad
{
    //[self.productCodeTextField becomeFirstResponder];
    [self _animateBottomViewOnYAxis:46];
    [super viewDidLoad];
}


#pragma mark - IBAction methods

- (IBAction)revealLeftMenu:(UIBarButtonItem *)sender
{
    self.viewDeckController.leftLedge = 50.0;
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)next:(id)sender
{
    [self.nextButton setHidden:YES];
    [self.productCodeTextField setHidden:YES];
    [self.productLabel setHidden:NO];
    [self.productLabel setText:@"Kikiriki 1kg 25,00"];
    [self _animateBottomViewOnYAxis:85];
    [self.quantityTextField becomeFirstResponder];
}

- (IBAction)add:(id)sender
{
    //Bill *bill =
}

- (IBAction)save:(id)sender {
}


#pragma mark - Text Field Delegate methods

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.addButton setEnabled: NO];
    return YES;
}


#pragma mark - TableView Data Source Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
 
    NSLog(@"%d", [indexPath row]);
    [[cell textLabel] setText:@"Kikiriki 5x"];
    return cell;
}


#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - Private methods

- (void)_animateBottomViewOnYAxis:(CGFloat)yTotalImageValue
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame;
        
        frame = self.bottomView.frame;
        frame.origin.y = yTotalImageValue;
        self.bottomView.frame = frame;        
    }];
}


#pragma mark - Core Data Queries private methods
@end
