//
//  MIMainViewController.m
//  eRacun
//
//  Created by Kornelije Sajler on 3.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MIMainViewController.h"
#import "MIAppDelegate.h"
#import "Product.h"
#import "Bill.h"
#import "BillItem.h"

@interface MIMainViewController ()

@end

@implementation MIMainViewController {
    
    NSArray *products;
    Product *currentProduct;
    BillItem *selectedItem;
    UIToolbar *numberToolbar;
    NSMutableArray *billItems;
    #define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]
}


#pragma mark - View Controller methods

- (void)viewDidLoad {
    
    [super viewDidLoad];    
    MIAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    self.objectModel = appDelegate.managedObjectModel;
    [self _animateBottomViewOnYAxis:46];	
    products = [self _getAllProducts];

    self.currentBill = (Bill *)[NSEntityDescription insertNewObjectForEntityForName:@"Bill"
                                                             inManagedObjectContext:[self context]];
    
    billItems = [NSMutableArray arrayWithArray:[[self.currentBill items] allObjects]];
    
    [self _setTotalPriceLabel:@0.00];
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    [self _showAndFocusProductCode];
    
    [numberToolbar sizeToFit];
    self.productCodeTextField.inputAccessoryView = numberToolbar;
    self.quantityTextField.inputAccessoryView = numberToolbar;
}


#pragma mark - Command methods

- (void)nextNumberPad {
    
    NSNumber *productId = [NSNumber numberWithInt:[[self.productCodeTextField text] intValue]];
    
    if ([productId intValue] > 0) {
        
        currentProduct = [self _getProductById:productId];
        
        if (nil != currentProduct) {
            [self _setProductLabelAndShowQuantityWithName:[currentProduct name] andPrice:[currentProduct price] isNewItem:YES];
        }
    }
}

- (void)addNumberPad {
    
    BOOL isNewItem = NO;
    NSUInteger idFromItemsCount = [[self.currentBill items] count] + 1;
    NSNumber *quantity = [NSNumber numberWithInt:[[self.quantityTextField text] intValue]];
    NSString *productName = allTrim([currentProduct name]);
    NSNumber *productPrice = [currentProduct price];
    
    if (idFromItemsCount > 0 && [quantity intValue] > 0
        && currentProduct != nil
        && [[currentProduct id] intValue] > 0
        && [productName length] != 0
        && productPrice > 0) {
        
        if (nil == selectedItem) {
            
            isNewItem = YES;
            selectedItem = (BillItem *)[NSEntityDescription insertNewObjectForEntityForName:@"BillItem"
                                                                   inManagedObjectContext:[self context]];
        }
        
        [selectedItem setId:[NSNumber numberWithInt:idFromItemsCount]];
        [selectedItem setProductId:[currentProduct id]];
        [selectedItem setQuantity:quantity];
        [selectedItem setProductName:productName];
        [selectedItem setProductPrice:productPrice];
        
        if (isNewItem) {
            [self.currentBill addItemsObject:selectedItem];
        }

        NSNumber *totalPrice = [[NSNumber alloc] initWithDouble:[[self.currentBill totalPrice] doubleValue] + ([[currentProduct price] doubleValue] * [quantity intValue])];
        [self.currentBill setTotalPrice: totalPrice];
        [self _setTotalPriceLabel:[self.currentBill totalPrice]];        
        
        [self _showAndFocusProductCode];
        
        [self _cleanAndReloadBillItemsForTableView:[self.currentBill items]];
                       
        [self.billTableView reloadData];
        
        selectedItem = nil;
        
    } else {
        
        // TODO: alert message
    }        
}

- (void)cancelNumberPad {
    
    [self _showAndFocusProductCode];
}

- (IBAction)save:(id)sender {
    
    [self _clearAndSetBillItemInstance];
}

- (IBAction)deleteBill:(id)sender {
    
    [self _clearAndSetBillItemInstance];
    [self _setTotalPriceLabel:@0.00];
}

#pragma mark - Text Field Delegate methods

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    // NSLog(@"tag: %@", [self.quantityTextField text]);
    
    if ([[self.quantityTextField text] length] != 0) {
        
        //[self.addButton setEnabled:YES];
    }
    
    return YES;
}


#pragma mark - TableView Data Source Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = [billItems count];
    // NSLog(@"No. of rows: %d", rows);
    
    if (0 == rows) {
        
        [self _disableSaveAndDeleteButton];
        
    } else {
    
        [self.saveButton setEnabled:YES];
        [self.deleteBillButton setEnabled:YES];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillItemCell"];    
        
    NSMutableArray *items = billItems;
    
    if (items != nil && [items count] > 0) {

        UILabel *label;
        BillItem *item = [items objectAtIndex:[indexPath row]];
        
        label = (UILabel *)[cell viewWithTag:1];
        [label setText:[item productName]];
        
        label = (UILabel *)[cell viewWithTag:2];
        [label setText:[NSString stringWithFormat:@"%@", [item quantity]]];
        
        // NSLog(@"Id: %@ :: ProductName: %@ :: Quantity: %@", [item id], [item productName], [item quantity]);
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // cell.backgroundColor = (indexPath.row%2)?[UIColor lightGrayColor]:[UIColor grayColor];
    cell.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"cell_bg.png"]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.billTableView beginUpdates];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.billTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
         
        BillItem *item = [billItems objectAtIndex:[indexPath row]];
        
        [[self.currentBill items] removeObject:item];
        
        [billItems removeObjectAtIndex:[indexPath row]];
       
        
        if ([[self.currentBill items] count] == 0) {
            
            [self.currentBill setTotalPrice:@0];
            
        } else {

            NSNumber *totalPrice = [[NSNumber alloc] initWithDouble:[[self.currentBill totalPrice] doubleValue] - ([[item productPrice] doubleValue] * [item.quantity intValue])];
            [self.currentBill setTotalPrice:totalPrice];
        }
        
        [self _setTotalPriceLabel:self.currentBill.totalPrice];
    }
    
    [self.billTableView endUpdates];
    [self.billTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedItem = [billItems objectAtIndex:[indexPath row]];
    
    if (nil != selectedItem) {
        
        [self _setProductLabelAndShowQuantityWithName:[selectedItem productName] andPrice:[selectedItem productPrice] isNewItem:NO];
    }
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

- (void)_setTotalPriceLabel:(NSNumber*)totalPrice {
     
    NSString *totalString = NSLocalizedString(@"Total", nil);
    [self.totalLabel setText:[NSString stringWithFormat:@"%@: %@", totalString, [self _formatPriceNumber:totalPrice]]];
}

-(NSString *)_formatPriceNumber:(NSNumber*)price {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumFractionDigits:2];
    return [numberFormatter stringFromNumber:price];
}

- (void)_showAndFocusProductCode {
    
    [self.productCodeTextField setHidden:NO];
    [self.productLabel setHidden:YES];
    [self _animateBottomViewOnYAxis:46];
    [self.productCodeTextField becomeFirstResponder];
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Next", nil) style:UIBarButtonItemStyleDone target:self action:@selector(nextNumberPad)],
                           nil];
}

-(void)_cleanAndReloadBillItemsForTableView:(NSSet *)items {
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO]];
    NSArray *sorteditems = [[[self.currentBill items] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    billItems = [NSMutableArray arrayWithArray:sorteditems];
}

-(void)_clearAndSetBillItemInstance {
    
    [self.currentBill setTotalPrice:@0.00];
    [self.currentBill setItems:[[NSMutableSet alloc] init]];
    [billItems removeAllObjects];
    [self.billTableView reloadData];
    [self _disableSaveAndDeleteButton];
}

-(void)_disableSaveAndDeleteButton {
    
    [self.saveButton setEnabled:NO];
    [self.deleteBillButton setEnabled:NO];
}

-(void)_setProductLabelAndShowQuantityWithName:(NSString *)name
                                      andPrice:(NSNumber *)price
                                     isNewItem:(BOOL)isNewItem {
    
    [self.productLabel setText:[NSString stringWithFormat:@"%@ %@", name, [self _formatPriceNumber:price]]];
    [self.productCodeTextField setHidden:YES];
    [self.productLabel setHidden:NO];
    [self _animateBottomViewOnYAxis:85];
    [self.quantityTextField becomeFirstResponder];
                                          
    NSString *saveText;
                                          
    if (isNewItem) {
        saveText = NSLocalizedString(@"Add", nil);
    } else {
        saveText = NSLocalizedString(@"Change", nil);
    }
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:saveText style:UIBarButtonItemStyleDone target:self action:@selector(addNumberPad)],
                           nil];
}

#pragma mark - Core Data Queries private methods

-(NSArray *)_getAllProducts {
    
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
