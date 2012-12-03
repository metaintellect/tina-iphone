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

- (IBAction)revealLeftMenu:(UIBarButtonItem *)sender
{
    self.viewDeckController.leftLedge = 50.0;
    [self.viewDeckController toggleLeftViewAnimated:YES];
}
@end
