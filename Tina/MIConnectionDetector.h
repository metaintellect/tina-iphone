//
//  MIConnectionDetector.h
//  Tina
//
//  Created by Kornelije Sajler on 5.1.2013.
//  Copyright (c) 2013 Metaintellect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
} NetworkStatus;

#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

@interface MIConnectionDetector : NSObject {
    
    BOOL localWiFiRef;
    SCNetworkReachabilityRef reachabilityRef;
}

//connectionDetectorWithHostName- Use to check the reachability of a particular host name.
+ (MIConnectionDetector*) connectionDetectorWithHostName: (NSString*) hostName;

//connectionDetectorWithAddress- Use to check the reachability of a particular IP address.
+ (MIConnectionDetector*) connectionDetectorWithAddress: (const struct sockaddr_in*) hostAddress;

//cennectionDetectorForInternetConnection- checks whether the default route is available.
//  Should be used by applications that do not connect to a particular host
+ (MIConnectionDetector*) connectionDetectorForInternetConnection;

//connectionDetectorForLocalWiFi- checks whether a local wifi connection is available.
+ (MIConnectionDetector*) connectionDetectorForLocalWiFi;

//Start listening for connection detector notifications on the current run loop
- (BOOL) startNotifier;

- (void) stopNotifier;

- (NetworkStatus) currentReachabilityStatus;
//WWAN may be available, but not active until a connection has been established.
//WiFi may require a connection for VPN on Demand.
- (BOOL) connectionRequired;
@end
