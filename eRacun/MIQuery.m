//
//  MIQueries.m
//  eRacun
//
//  Created by Kornelije Sajler on 20.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MIQuery.h"
#import "MIAppDelegate.h"
#import "MIHelper.h"

@implementation MIQuery {
    NSError * __autoreleasing *error;
}

- (id)init {
    
    if (self = [super init]) {
        
        MIAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.context = appDelegate.managedObjectContext;
        self.objectModel = appDelegate.managedObjectModel;
    }
    
    return self;
}

- (BOOL)saveedAccountFromJSON:(NSDictionary*)json {
    
    if (nil == json) { return NO; }
    
    Account *account = (Account *)[NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                                inManagedObjectContext:[self context]];
        
    account.id = [NSNumber numberWithInt:[(NSString *)[json objectForKey:@"userId"] intValue]];
    account.fullName = (NSString *)[json objectForKey:@"fullName"];
    account.cashRegister = (NSString *)[json objectForKey:@"cashRegister"];
    account.cashRegisterId = [NSNumber numberWithInt:[(NSString *)[json objectForKey:@"cashRegisterId"] intValue]];
    account.token = (NSString *)[json objectForKey:@"token"];
    
    [MIHelper setAuthToken:account.token];
    
    return [[self context] save:error] ?  YES : NO;
}

- (NSArray *)getAllProducts {
    
    NSFetchRequest *request = [[self objectModel] fetchRequestTemplateForName:@"GetAllProducts"];
    
    NSArray *result = [[self context] executeFetchRequest:request error:error];
    
    if (nil == result) {
        
        // TODO: Should add message alert of some kind!
    }
    
    return result;
}

- (Product *)getProductById:(NSNumber *)productId {
    
    NSDictionary *var = [NSDictionary dictionaryWithObject:productId forKey:@"PRODUCT_ID"];
    NSFetchRequest *request = [[self objectModel] fetchRequestFromTemplateWithName:@"GetProductById" substitutionVariables:var];
    
    NSArray *result = [[self context] executeFetchRequest:request error:error];
    
    if (nil == result) {
        
        // TODO: Should add message alert of some kind!
    }
    
    if (0 == [result count]) { return nil; }
    
    return (Product *)result[0];
}

@end
