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

- (void)viewDidLoad
{
    [self.productCodeTextField becomeFirstResponder];
    // Initial values 100, 109, 140
    [self _animateBottomViewOnYAxis:46]; // totalLabel:59 billTableView:90];
    [super viewDidLoad];
}

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

- (IBAction)save:(id)sender {
}



- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.addButton setEnabled: NO];
    return YES;
}

- (void)_animateBottomViewOnYAxis:(CGFloat)yTotalImageValue
//                            totalLabel:(CGFloat)yTotalLabelValue
//                         billTableView:(CGFloat)yTableValue


{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame;
        
        frame = self.bottomView.frame;
        frame.origin.y = yTotalImageValue;
        self.bottomView.frame = frame;
        
//        frame = self.totalLabel.frame;
//        frame.origin.y = yTotalImageValue;
//        self.totalLabel.frame = frame;
        
//        frame = self.billTableView.frame;
//        frame.origin.y = yTotalImageValue;
//        self.billTableView.frame = frame;
    }];
}
@end
