//
//  BillItem.h
//  eRacun
//
//  Created by Kornelije Sajler on 6.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bill;

@interface BillItem : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSSet *bill;
@end

@interface BillItem (CoreDataGeneratedAccessors)

- (void)addBillObject:(Bill *)value;
- (void)removeBillObject:(Bill *)value;
- (void)addBill:(NSSet *)values;
- (void)removeBill:(NSSet *)values;

@end
