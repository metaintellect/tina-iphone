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

@property (weak, nonatomic) IBOutlet UITextField *productCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UILabel *productLabel;

@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UITableView *billTableView;

@property (strong, nonatomic) Bill *curruntBill;

@property (strong, nonatomic) NSManagedObjectContext *context;

- (IBAction)revealLeftMenu:(UIBarButtonItem *)sender;

- (IBAction)next:(id)sender;

- (IBAction)add:(id)sender;

- (IBAction)save:(id)sender;
@end
