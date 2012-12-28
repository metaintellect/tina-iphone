//
//  MIHelper.m
//  eRacun
//
//  Created by Kornelije Sajler on 19.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MIHelper.h"
#import "MIRestJSON.h"

@implementation MIHelper {
    
}

#pragma mark - NSUserDefaults handling methods

+ (NSString*)getAuthToken {
    
    // NSLog(@"GET || Key: %@ :: Token: %@", kAuthToken, [[NSUserDefaults standardUserDefaults] stringForKey:kAuthToken]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
}

+ (NSNumber *)getCurrentUserid {
    
    // NSLog(@"GET || Key: %@ :: UserId: %@", kCurrentUserId, [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserId];
}

+ (NSNumber *)getCurrentUserCashRegisterId {
    
    // NSLog(@"GET || Key: %@ :: CashRegisterId: %@", kCurrentCashRegisterId, [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentCashRegisterId]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentCashRegisterId];
}

+ (void)setAuthToken:(NSString *)token
           AndUserId:(NSNumber *)userid
   AndCashRegisterId:(NSNumber *)cashRegisterId {
    
    // NSLog(@"SET || Key: %@ :: Token: %@", kAuthToken, token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kAuthToken];
    
    // NSLog(@"SET || Key: %@ :: UserId: %@", kCurrentUserId, userid);
    [[NSUserDefaults standardUserDefaults] setObject:userid forKey:kCurrentUserId];
    
    // NSLog(@"SET || Key: %@ :: CashRegisterId: %@", kCurrentCashRegisterId, cashRegisterId);
    [[NSUserDefaults standardUserDefaults] setObject:cashRegisterId forKey:kCurrentCashRegisterId];
}

+ (NSString*)getCustomDomainURL {
    
    // NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:kCustomDomainURL]);
    return [[NSUserDefaults standardUserDefaults] stringForKey:kCustomDomainURL];
}
    
+ (void)setCustomDomainURL:(NSString*)customDomainURL {
    
    [[NSUserDefaults standardUserDefaults] setObject:customDomainURL forKey:kCustomDomainURL];
}

#pragma mark - Misc. methods

+ (void)showAlerMessageWithTitle:(NSString*)title
                     withMessage:(NSString*)messageTitle
           withCancelButtonTitle:(NSString*)cancelButtonTitle {
    
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:messageTitle
                                                     delegate:nil
                                            cancelButtonTitle:cancelButtonTitle
                                            otherButtonTitles:nil];
    [message show];
}

+ (BOOL)validUrl:(NSString *)candidate {
    
    if (nil == candidate || [allTrim(candidate) length] == 0) {
        
        return NO;
    }
    
    NSString *urlRegEx = @"^http(s)?:\\/\\/((\\d+\\.\\d+\\.\\d+\\.\\d+)|(([\\w-]+\\.)+([a-z,A-Z][\\w-]*)))(:[1-9][0-9]*)?(\\/([\\w-.\\/:%+@&=]+[\\w- .\\/?:%+@&=]*)?)?(#(.*))?$";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

+ (NSString *)truncateString:(NSString *)candidate toNumberOfCharsWithThreeDots:(NSUInteger)truncateLength {
    
    if ([candidate length] > truncateLength) {
        
        candidate = [candidate substringToIndex: MIN(truncateLength, [candidate length])];
        
        return [NSString stringWithFormat:@"%@...", candidate];
    }
        
    return candidate;
}
@end
