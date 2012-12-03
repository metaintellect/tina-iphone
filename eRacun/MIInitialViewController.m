//
//  MIInitialViewController.m
//  eRacun
//
//  Created by Kornelije Sajler on 3.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MIInitialViewController.h"

@interface MIInitialViewController ()

@end

@implementation MIInitialViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [super initWithCenterViewController:[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"]
                            leftViewController:[storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"]];
    if (self) {
        // Add any extra init code here
    }
    return self;
}

@end
