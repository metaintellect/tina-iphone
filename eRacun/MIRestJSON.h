//
//  MIRestJSON.h
//  eRacun
//
//  Created by Kornelije Sajler on 19.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIRestJSON : NSObject

+ (NSMutableURLRequest *)constructRequestForApiAction:(NSString*)apiAction
                                       withJSONValues:(NSDictionary *)jsonValues
                                                error:(NSError *)error;

+ (NSMutableURLRequest *)constructRequestForApiAction:(NSString *)apiActionURL
                                                error:(NSError *)error;

+ (BOOL)callLoginApiAndPersistedAccountForData:(NSData*)data error:(NSError*)error;

+ (void)callProductsApiAndSetProductsArrayForToken:(NSString *)authToken;

+ (void)callInvoicesApiWithJSONData:(NSDictionary *)json forToken:(NSString *)authToken;

@end
