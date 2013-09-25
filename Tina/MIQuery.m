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


#pragma mark - Init

- (id)init {
    
    if (self = [super init]) {
        
        MIAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.context = appDelegate.managedObjectContext;
        self.objectModel = appDelegate.managedObjectModel;
    }
    
    return self;
}


#pragma mark - Command methods

- (BOOL)savedAccountFromJSON:(NSDictionary*)json {
    
    if (nil == json) { return NO; }
    
    Account *account = (Account *)[NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                                inManagedObjectContext:[self context]];
        
    account.id = @([(NSString *)json[@"userId"] intValue]);
    account.fullName = (NSString *)json[@"fullName"];
    account.cashRegister = (NSString *)json[@"cashRegister"];
    account.cashRegisterId = @([(NSString *)json[@"cashRegisterId"] intValue]);
    account.token = (NSString *)json[@"token"];
            
    [MIHelper setAuthToken:[account token] AndUserId:[account id] AndCashRegisterId:[account cashRegisterId]];
    
    return [self.context save:error] ?  YES : NO;
}

- (BOOL)removeAllProducts {
        
    for (Product *product in [self getAllProducts]) {
        
        [self.context deleteObject:product];
    }
    
    return [self.context save:error] ?  YES : NO;
}


#pragma mark - Query methods

- (NSUInteger)getProductsCount {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context]];
    
    NSUInteger result = [self.context countForFetchRequest:request error:error];
    
    if (result == NSNotFound) {
        // Handle error
    }
    
    return result;
}

- (NSArray *)getAllProducts {
    
    NSFetchRequest *request = [self.objectModel fetchRequestTemplateForName:@"GetAllProducts"];
    
    NSArray *result = [self.context executeFetchRequest:request error:error];
    
    return result;
}

- (Product *)getProductById:(NSNumber *)productId {
    
    NSDictionary *var = @{@"PRODUCT_ID": productId};
    NSFetchRequest *request = [self.objectModel fetchRequestFromTemplateWithName:@"GetProductById"
                                                           substitutionVariables:var];
    
    NSArray *result = [self.context executeFetchRequest:request error:error];
    
    if (nil == result) {
        
        // TODO: Should add message alert of some kind!
    }
    
    if (0 == [result count]) { return nil; }
    
    return (Product *)result[0];
}

- (NSArray *)getAccountByUserId:(NSNumber *)userId {
    
    NSDictionary *var = @{@"USER_ID": userId};
    NSFetchRequest *request = [self.objectModel fetchRequestFromTemplateWithName:@"GetAccountsByUserId"
                                                           substitutionVariables:var];
    
    NSArray *result = [self.context executeFetchRequest:request error:error];
    
    if (nil == result) {
        
        // TODO: Should add message alert of some kind!
    }
    
    if (0 == [result count]) { return nil; }
    
    return result;
}

- (Account *)getAccountByToken:(NSString *)authToken {
    
    NSDictionary *var = @{@"AUTH_TOKEN": authToken};
    NSFetchRequest *request = [self.objectModel fetchRequestFromTemplateWithName:@"GetAccountByToken"
                                                           substitutionVariables:var];
    
    NSArray *result = [self.context executeFetchRequest:request error:error];
    
    if (nil == result) {
        
        // TODO: Should add message alert of some kind!
    }
    
    if (0 == [result count]) { return nil; }
    
    return (Account *)result[0];
}

- (void)_removeAllExistingAccountsForUser:(NSArray *)userAccounts {
        
    for (Account *account in userAccounts) {
        
        [self.context deleteObject:account];
    }
}

@end
