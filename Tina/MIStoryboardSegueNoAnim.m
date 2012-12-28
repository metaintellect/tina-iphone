//
//  MIStoryboardSegueNoAnim.m
//  eRacun
//
//  Created by Kornelije Sajler on 19.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MIStoryboardSegueNoAnim.h"

@implementation MIStoryboardSegueNoAnim

- (void)perform {
    
    [self.sourceViewController presentModalViewController:self.destinationViewController animated:NO];
}

@end
