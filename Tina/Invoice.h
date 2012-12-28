//
//  Invoice.h
//  eRacun
//
//  Created by Kornelije Sajler on 6.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InvoiceItem;

@interface Invoice : NSManagedObject

@property (nonatomic, retain) NSNumber * totalPrice;
@property (nonatomic, retain) NSMutableSet * items;
@end

@interface Invoice (CoreDataGeneratedAccessors)

- (void)addItemsObject:(InvoiceItem *)value;
- (void)removeItemsObject:(InvoiceItem *)value;
- (void)addItems:(NSMutableSet *)values;
- (void)removeItems:(NSMutableSet *)values;

@end
