//
//  MIQueries.h
//  eRacun
//
//  Created by Kornelije Sajler on 20.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "Product.h"

@interface MIQuery : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSManagedObjectModel *objectModel;


- (BOOL)savedAccountFromJSON:(NSDictionary*)json;

- (BOOL)removeAllProducts;

- (NSUInteger)getProductsCount;

- (NSArray *)getAllProducts;

- (NSArray *)getAllProductsSortedById;

- (Product *)getProductById:(NSNumber *)productId;

- (NSArray *)getAccountByUserId:(NSNumber *)userId;

- (Account *)getAccountByToken:(NSString *)authToken;

@end
