//
//  Account.h
//  eRacun
//
//  Created by Kornelije Sajler on 19.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * cashRegister;
@property (nonatomic, retain) NSNumber * cashRegisterId;
@property (nonatomic, retain) NSString * token;

@end
