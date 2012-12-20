//
//  MIHelper.m
//  eRacun
//
//  Created by Kornelije Sajler on 19.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MIHelper.h"

@implementation MIHelper {
    
}

#pragma mark - NSUserDefaults handling methods

+ (NSString*)getAuthToken {
    
    NSLog(@"GET || Key: %@ :: Token: %@", kAuthToken, [[NSUserDefaults standardUserDefaults] stringForKey:kAuthToken]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
}

+ (void)setAuthToken:(NSString*)token {
    
    NSLog(@"SET || Key: %@ :: Token: %@", kAuthToken, token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kAuthToken];
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
@end
