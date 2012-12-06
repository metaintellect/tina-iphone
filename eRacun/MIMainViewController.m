//
//  MIMainViewController.m
//  eRacun
//
//  Created by Kornelije Sajler on 3.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MIMainViewController.h"
#import <ViewDeck/IIViewDeckController.h>
#import "MIAppDelegate.h"
#import "Product.h"
#import "Bill.h"
#import "BillItem.h"

@interface MIMainViewController ()

@end

@implementation MIMainViewController {
    
    NSArray *products;
    NSString *totalString;
    Product *currentProduct;
    #define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]
}


#pragma mark - View Controller methods

- (void)viewDidLoad {
    
    MIAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    self.objectModel = appDelegate.managedObjectModel;    
    [self.productCodeTextField becomeFirstResponder];
    [self _animateBottomViewOnYAxis:46];
    products = [self _getAllProductsFetchRequest];
    self.currentBill = (Bill *)[NSEntityDescription insertNewObjectForEntityForName:@"Bill"
                                                             inManagedObjectContext:[self context]];
    [self _setTotalPriceLabel:0];
    [super viewDidLoad];
}


#pragma mark - IBAction methods

- (IBAction)revealLeftMenu:(UIBarButtonItem *)sender {
    
    self.viewDeckController.leftLedge = 50.0;
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)next:(id)sender {
    
    NSNumber *productId = [NSNumber numberWithInt:[[self.productCodeTextField text] intValue]];
    
    if ([productId intValue] > 0) {
        
        currentProduct = [self _getProductById:productId];
        
        if (nil != currentProduct) {
            
            [self.productLabel setText:[NSString stringWithFormat:@"%@ %.2f", [currentProduct name], [currentProduct price]]];
            [self.nextButton setHidden:YES];
            [self.productCodeTextField setHidden:YES];
            [self.productLabel setHidden:NO];
            [self _animateBottomViewOnYAxis:85];
            [self.quantityTextField becomeFirstResponder];
        }
    }
}

- (IBAction)add:(id)sender {
    
    NSUInteger idFromItemsCount = [[self.currentBill items] count] + 1;
    NSNumber *quantity = [NSNumber numberWithInt:[[self.quantityTextField text] intValue]];
    NSString *productName = allTrim([currentProduct name]);
    
    if (idFromItemsCount > 0 && [quantity intValue] > 0
        && currentProduct != nil
        && [[currentProduct id] intValue] > 0
        && [productName length] != 0) {
        
        BillItem *item = (BillItem *)[NSEntityDescription insertNewObjectForEntityForName:@"BillItem"
                                                                   inManagedObjectContext:[self context]];
        [item setId:[NSNumber numberWithInt:idFromItemsCount]];
        [item setProductId:[currentProduct id]];
        [item setQuantity:quantity];
        [item setProductName:productName];
        
        [self.currentBill addItemsObject:item];
        double totalPrice = [self.currentBill totalPrice] + ([currentProduct price] * [quantity intValue]);
        [self.currentBill setTotalPrice: totalPrice];
        [self _setTotalPriceLabel:[self.currentBill totalPrice]];
        
        [self.nextButton setHidden:NO];
        [self.productCodeTextField setHidden:NO];
        [self.productLabel setHidden:YES];
        [self _animateBottomViewOnYAxis:46];
        [self.productCodeTextField becomeFirstResponder];

       // [self.billTableView numberOfRowsInSection:[self.currentBill.items count]];
        
    } else {
        
        // TODO: alert message
    }
    
    [self.billTableView reloadData];
}

- (IBAction)save:(id)sender {
}


#pragma mark - Text Field Delegate methods

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [self.addButton setEnabled: NO];
    return YES;
}


#pragma mark - TableView Data Source Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = [[self.currentBill items] count];
    NSLog(@"No. of rows: %d", rows);
    
    if (0 == rows) { [self.saveButton setEnabled:NO];
   
    } else {
    
        [self.saveButton setEnabled:YES];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillItemCell"];    
        
    NSArray *items = [[self.currentBill items] allObjects];
    
    if (items != nil && [items count] > 0) {

        UILabel *label;
        BillItem *item = [items objectAtIndex:[indexPath row]];
        
        label = (UILabel *)[cell viewWithTag:1];
        [label setText:[item productName]];
        
        label = (UILabel *)[cell viewWithTag:2];
        [label setText:[NSString stringWithFormat:@"%@x", [item quantity]]];
        NSLog(@"Id: %@ :: ProductName: %@ :: Quantity: %@", [item id], [item productName], [item quantity]);
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell.backgroundColor = (indexPath.row%2)?[UIColor lightGrayColor]:[UIColor grayColor];
    cell.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"cell_bg.png"]];
}


#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - Private methods

- (void)_animateBottomViewOnYAxis:(CGFloat)yTotalImageValue {
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame;        
        frame = self.bottomView.frame;
        frame.origin.y = yTotalImageValue;
        self.bottomView.frame = frame;        
    }];
}

- (void)_setTotalPriceLabel:(double)totalPrice {
    
    totalString = NSLocalizedString(@"Total", nil);
    [self.totalLabel setText:[NSString stringWithFormat:@"%@: %.2f", totalString, totalPrice]];
}


#pragma mark - Core Data Queries private methods

-(NSArray *)_getAllProductsFetchRequest {
    
    NSFetchRequest *request = [[self objectModel] fetchRequestTemplateForName:@"GetAllProducts"];
    
    NSError *error = nil;
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
    
    if (nil == result) {
        NSLog(@"Huston, we have a problem!\n%@", error);
        
        // TODO: Should add message alert of some kind!
    }
    
    return result;
}

-(Product *)_getProductById:(NSNumber *)productId {
    
    NSLog(@"Product Id: %@", productId);
    NSDictionary *var = [NSDictionary dictionaryWithObject:productId forKey:@"PRODUCT_ID"];
    NSFetchRequest *request = [[self objectModel] fetchRequestFromTemplateWithName:@"GetProductById" substitutionVariables:var];
    
    NSError *error = nil;
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
    
    if (nil == result) {
        NSLog(@"Huston, we have a problem!\n%@", error);
        
        // TODO: Should add message alert of some kind!
    }
    
    if (0 == [result count]) { return nil; }
    
    return (Product *)result[0];
}
@end
