//
//  InvoiceItem.h
//  eRacun
//
//  Created by Kornelije Sajler on 6.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Invoice;

@interface InvoiceItem : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSNumber * productPrice;
@property (nonatomic, retain) Invoice *invoice;

@end
