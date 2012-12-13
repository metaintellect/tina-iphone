//
//  MIMainViewController.h
//  eRacun
//
//  Created by Kornelije Sajler on 3.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"


@interface MIMainViewController : UIViewController <UITextFieldDelegate,
                                  UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *productCodeTextField;

@property (weak, nonatomic) IBOutlet UILabel *productLabel;

@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UITableView *billTableView;

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSManagedObjectModel *objectModel;

@property (strong, nonatomic) Bill *currentBill;

@property (weak, nonatomic) IBOutlet UIButton *deleteBillButton;

- (IBAction)save:(id)sender;

- (IBAction)deleteBill:(id)sender;
@end
