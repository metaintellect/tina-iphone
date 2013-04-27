//
//  MIConnectionDetector.m
//  Tina
//
//  Created by Kornelije Sajler on 5.1.2013.
//  Copyright (c) 2013 Metaintellect. All rights reserved.
//

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <CoreFoundation/CoreFoundation.h>

#import "MIConnectionDetector.h"

static void PrintConnectiorDetectorFlags(SCNetworkReachabilityFlags    flags, const char* comment) {
    
#if kShouldPrintReachabilityFlags
    
    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
          (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
          
          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
          comment
          );
#endif
}

@implementation MIConnectionDetector

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    //NSCAssert([(NSObject*) CFBridgingRelease(info isKindOfClass: [MIConnectionDetector class]], @"info was wrong class in ConnectionDetectorCallback");
    //NSCAssert([(NSObject*) info isKindOfClass: [MIConnectionDetector class]], @"info was wrong class in ConnectionDetectorCallback");

    
    MIConnectionDetector* noteObject = (__bridge MIConnectionDetector*) info;
               
    // Post a notification to notify the client that the network reachability changed.
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: noteObject];
}

@end
