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
       
     // NSLog(@"JSON data: %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    
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
    
    if ((nil != data || [data length] > 0)
        && error == nil) {
                
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if ([query savedAccountFromJSON:json]) {
            
            return YES;
            
        } else {
            
            return NO;
        }
    }
    
    return NO;
}

+ (void)callProductsApiAndSetProductsArrayForToken:(NSString *)authToken {
    
    NSError *error = nil;
    MIQuery *query = [[MIQuery alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"products/%@/%@", [MIHelper getCurrentUserid], [MIHelper getAuthToken]];
    
    NSMutableURLRequest *request = [MIRestJSON constructRequestForApiAction:url error:error];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               
           if ((nil != data || [data length] > 0)
               && error == nil) {
               
               NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:&error];
               
               NSMutableArray *result;
               
               for (NSDictionary *item in json) {
                   
                   Product *product = (Product *)[NSEntityDescription insertNewObjectForEntityForName:@"Product"
                                                                               inManagedObjectContext:[query context]];
                   
                   // NSLog(@"%@", item);
                   
                   product.id = @([(NSString *)item[@"id"] intValue]);
                   product.name = (NSString *)item[@"name"];
                   product.price = @([(NSString *)item[@"price"] intValue]);
                   
                   [result addObject:product];
               }
               
               if ([[query context] save:&error]) {
                   
                   [self performSelectorOnMainThread:@selector(_showProductsSyncedAlertMessage)
                                          withObject:nil
                                       waitUntilDone:YES];
               } else {
                   
                   [self performSelectorOnMainThread:@selector(_showProductsNotSyncedAlertMessage)
                                          withObject:nil
                                       waitUntilDone:YES];
               }                                   
           }
           
           [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       }];
    
}

+ (void)callInvoicesApiWithJSONData:(NSDictionary *)json forToken:(NSString *)authToken {
    
    NSError *error = nil;
    
    NSString *url = [NSString stringWithFormat:@"invoices/%@/%@/%@", [MIHelper getCurrentUserid],
                     [MIHelper getCurrentUserCashRegisterId], [MIHelper getAuthToken]];
    
    NSMutableURLRequest *request = [MIRestJSON constructRequestForApiAction:url
                                                             withJSONValues:json
                                                                      error:error];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               
                               // NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
                               
                               if ((nil != data || [data length] > 0)
                                   && error == nil) {
                                   
                                   [self performSelectorOnMainThread:@selector(_showInvoiceSavedAlertMessage)
                                                          withObject:nil
                                                       waitUntilDone:YES];
    
                               } else {
                                
                                   [self performSelectorOnMainThread:@selector(_showInvoiceNotSavedAlertMessage)
                                                          withObject:nil
                                                       waitUntilDone:YES];
                               }
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           }];
    
}

+ (NSMutableURLRequest *)_createRequestForApiURL:(NSString *)apiActionURL {
    
    NSURL *apiFullURL =  [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kApiURLString, apiActionURL]];
    
    // NSLog(@"API full URL: %@", [apiFullURL absoluteString]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiFullURL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:30.f];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

+ (void)_showProductsSyncedAlertMessage {
    
    [MIHelper showAlerMessageWithTitle:NSLocalizedString(@"Products Synced", nil)
                           withMessage:NSLocalizedString(@"Products are synced with server!", nil)
                 withCancelButtonTitle:NSLocalizedString(@"OK", nil)];
}

+ (void)_showProductsNotSyncedAlertMessage {
    
    [MIHelper showAlerMessageWithTitle:NSLocalizedString(@"Error", nil)
                           withMessage:NSLocalizedString(@"Problem syncing Products from the server!", nil)
                 withCancelButtonTitle:NSLocalizedString(@"OK", nil)];
}

+ (void)_showInvoiceSavedAlertMessage {
    
    [MIHelper showAlerMessageWithTitle:NSLocalizedString(@"Invoice saved", nil)
                           withMessage:NSLocalizedString(@"The Invoice is saved!", nil)
                 withCancelButtonTitle:NSLocalizedString(@"OK", nil)];
}

+ (void)_showInvoiceNotSavedAlertMessage {
    
    [MIHelper showAlerMessageWithTitle:NSLocalizedString(@"Invoice not saved", nil)
                           withMessage:NSLocalizedString(@"The Invoice is not saved!", nil)
                 withCancelButtonTitle:NSLocalizedString(@"OK", nil)];
}
@end
