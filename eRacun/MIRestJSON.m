//
//  MIRestJSON.m
//  eRacun
//
//  Created by Kornelije Sajler on 19.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#define kBackgroundQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kApiURLString [NSString stringWithFormat:@"%@/api", [MIHelper getCustomDomainURL]]

#import "MIRestJSON.h"
#import "MIHelper.h"
#import "MIQuery.h"
#import "Account.h"
#import "Product.h"

@implementation MIRestJSON {
        
}

+ (NSMutableURLRequest *)constructRequestForApiAction:(NSString *)apiActionURL
                                       withJSONValues:(NSDictionary *)jsonValues
                                                error:(NSError *)error {
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonValues
                                                   options:kNilOptions
                                                    error:&error];
    
    NSMutableURLRequest *request = [MIRestJSON _createRequestForApiURL:apiActionURL];
    
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: data];
       
    NSLog(@"JSON data: %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    
    return request;
}

+ (NSMutableURLRequest *)constructRequestForApiAction:(NSString *)apiActionURL
                                                error:(NSError *)error {
    
    NSMutableURLRequest *request = [MIRestJSON _createRequestForApiURL:apiActionURL];
    
    return request;
}

+ (BOOL)callLoginApiAndPersistedAccountForData:(NSData *)data error:(NSError*)error {
    
    MIQuery *query = [[MIQuery alloc] init];
    
    // NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    
    if ([data length] > 0 && error == nil) {
        
        Account *account = (Account *)[NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                                    inManagedObjectContext:[query context]];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        account.id = [NSNumber numberWithInt:[(NSString *)[json objectForKey:@"userId"] intValue]];
        account.fullName = (NSString *)[json objectForKey:@"fullName"];
        account.cashRegister = (NSString *)[json objectForKey:@"cashRegister"];
        account.cashRegisterId = [NSNumber numberWithInt:[(NSString *)[json objectForKey:@"cashRegisterId"] intValue]];
        account.token = (NSString *)[json objectForKey:@"token"];
        
        [MIHelper setAuthToken:account.token];
                
        
        if ([query savedAccountFromJSON:json]) {
            
            return YES;
            
        } else {
            
            return NO;
        }
    }
    
    return NO;
}

+ (BOOL)callProductsApiAndSetProductsArrayForData:(NSData *)data error:(NSError *)error {
    
    // NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    
    MIQuery *query = [[MIQuery alloc] init];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if ([data length] > 0 && error == nil) {
        
        NSMutableArray *result;
        
        for (NSDictionary *item in json) {
            
            Product *product = (Product *)[NSEntityDescription insertNewObjectForEntityForName:@"Product"
                                                                        inManagedObjectContext:[query context]];
            
            // NSLog(@"%@", item);
            
            product.id = [NSNumber numberWithInt:[(NSString *)[item objectForKey:@"id"] intValue]];
            product.name = (NSString *)[item objectForKey:@"name"];
            product.price = [NSNumber numberWithInt:[(NSString *)[item objectForKey:@"price"] intValue]];
            
            [result addObject:product];
        }
        
        return [[query context] save:&error] ?  YES : NO;
    }

    return NO;
}

+ (NSMutableURLRequest *)_createRequestForApiURL:(NSString *)apiActionURL {
    
    NSURL *apiFullURL =  [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kApiURLString, apiActionURL]];
    
    NSLog(@"API full URL: %@", [apiFullURL absoluteString]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiFullURL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:30.f];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

// + (Product *)_createProduct
@end
