//
//  MIHelper.h
//  eRacun
//
//  Created by Kornelije Sajler on 19.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIHelper : NSObject

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

#define kAuthToken @"authToken"

#define kCurrentUserId @"userid"

#define kCurrentCashRegisterId @"cashRegisterId"

#define kCustomDomainURL @"customDomainURL"

#define kMoreInfoPage @"http://mali-zeleni.hr"

+ (NSString *)getAuthToken;

+ (NSNumber *)getCurrentUserid;

+ (NSNumber *)getCurrentUserCashRegisterId;

+ (void)setAuthToken:(NSString *)token
           AndUserId:(NSNumber *)userid
   AndCashRegisterId:(NSNumber *)cashRegisterId;

+ (NSString *)getCustomDomainURL;

+ (void)setCustomDomainURL:(NSString*)customDomainURL;

+ (void) showAlerMessageWithTitle:(NSString*)title
                      withMessage:(NSString*)message
            withCancelButtonTitle:(NSString*)cancelButtonTitle;

+ (BOOL)validUrl:(NSString *)candidate;

+ (NSString *)truncateString:(NSString *)candidate toNumberOfCharsWithThreeDots:(NSUInteger)truncateLength;

@end
