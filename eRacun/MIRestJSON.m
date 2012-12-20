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

@implementation MIRestJSON {
    BOOL authenticated;
}

+ (NSMutableURLRequest *)constructRequestForApiAction:(NSString*)apiAction
                                       withJSONValues:(NSDictionary *)jsonValues
                                                error:(NSError *)error {
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonValues
                                                   options:kNilOptions
                                                    error:&error];
    
    NSURL *apiFullURL =  [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kApiURLString, apiAction]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiFullURL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:30.f];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: data];
    
    NSLog(@"API full URL: %@", [apiFullURL absoluteString]);    
    NSLog(@"JSON data: %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    
    return request;

}

@end
