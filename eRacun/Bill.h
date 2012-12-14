//
//  Bill.h
//  eRacun
//
//  Created by Kornelije Sajler on 6.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillItem;

@interface Bill : NSManagedObject

@property (nonatomic, retain) NSNumber * totalPrice;
@property (nonatomic, retain) NSMutableSet * items;
@end

@interface Bill (CoreDataGeneratedAccessors)

- (void)addItemsObject:(BillItem *)value;
- (void)removeItemsObject:(BillItem *)value;
- (void)addItems:(NSMutableSet *)values;
- (void)removeItems:(NSMutableSet *)values;

@end
