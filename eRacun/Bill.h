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

@property (nonatomic, retain) NSDecimalNumber * totalPrice;
@property (nonatomic, retain) BillItem *items;

@end
