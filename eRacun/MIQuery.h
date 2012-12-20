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


- (BOOL)saveedAccountFromJSON:(NSDictionary*)json;

- (NSArray *)getAllProducts;

- (Product *)getProductById:(NSNumber *)productId;

@end
