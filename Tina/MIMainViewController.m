//
//  MIMainViewController.m
//  eRacun
//
//  Created by Kornelije Sajler on 3.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MIMainViewController.h"
#import "MIHelper.h"
#import "MIRestJSON.h"
#import "Product.h"
#import "Invoice.h"
#import "InvoiceItem.h"

@interface MIMainViewController ()

@end

@implementation MIMainViewController {
    
    //NSArray * _products;
    Product * _currentProduct;
    InvoiceItem * _selectedItem;
    UIToolbar * _numberToolbar;
    NSMutableArray * _invoiceItems;
    NSString *_authToken;
}


#pragma mark - View Controller base methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _authToken = [MIHelper getAuthToken];
    
    self.query = [[MIQuery alloc] init];
    
    if (nil == _authToken) {
        
        [self performSegueWithIdentifier:@"AuthSegue" sender:self];
        [super viewWillAppear:NO];   
    
    } else {
        
        [self _checkIfAnyProductsAndGetFromServer];
    }
    
    [self _animateBottomViewOnYAxis:46];	    

    self.currentInvoice = (Invoice *)[NSEntityDescription insertNewObjectForEntityForName:@"Invoice"
                                                             inManagedObjectContext:[self.query context]];
    
    _invoiceItems = [NSMutableArray arrayWithArray:[[self.currentInvoice items] allObjects]];
    
    [self _setTotalPriceLabel:@0.00];
    
    _numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    _numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    [self _showAndFocusProductCode];
    
    [_numberToolbar sizeToFit];
    self.productCodeTextField.inputAccessoryView = _numberToolbar;
    self.quantityTextField.inputAccessoryView = _numberToolbar;
}

- (void)viewDidAppear:(BOOL)animated {
    
   
}


#pragma mark - Action methods

- (void)nextNumberPad {
    
    NSNumber *productId = [NSNumber numberWithInt:[[self.productCodeTextField text] intValue]];
    
    if ([productId intValue] > 0) {
        
        _currentProduct = [self.query getProductById:productId];
        
        if (nil != _currentProduct) {
            [self _setProductLabelAndShowQuantityWithName:[_currentProduct name]
                                                 andPrice:[_currentProduct price] isNewItem:YES];
        }
    }
}

- (void)addOrChangeNumberPad {
    
    NSUInteger idFromItemsCount = [[self.currentInvoice items] count] + 1;
    NSNumber *quantity = [NSNumber numberWithInt:[[self.quantityTextField text] intValue]];
    NSString *productName = allTrim([_currentProduct name]);
    NSNumber *productPrice = [_currentProduct price];
    
    if (idFromItemsCount > 0
        && [quantity intValue] > 0
        && _currentProduct != nil
        && [[_currentProduct id] intValue] > 0
        && [productName length] != 0
        && productPrice > 0) {
        
        if (nil == _selectedItem) {
            
            _selectedItem = (InvoiceItem *)[NSEntityDescription insertNewObjectForEntityForName:@"InvoiceItem"
                                                                      inManagedObjectContext:[self.query context]];
            
            [_selectedItem setId:[NSNumber numberWithInt:idFromItemsCount]];
            [_selectedItem setProductId:[_currentProduct id]];
            [_selectedItem setProductName:productName];
            [_selectedItem setProductPrice:productPrice];
            [_selectedItem setQuantity:quantity];
            
            [self.currentInvoice addItemsObject:_selectedItem];
            
        } else {
            
            [_selectedItem setQuantity:quantity];
        }
                

        [self.currentInvoice setTotalPrice: [self _recalculateTotalPrice]];
        [self _setTotalPriceLabel:[self.currentInvoice totalPrice]];        
        
        [self _showAndFocusProductCode];
        
        [self _cleanAndReloadInvoiceItemsForTableView:[self.currentInvoice items]];
                       
        [self.invoiceTableView reloadData];
        
        _selectedItem = nil;
        
    } else {
        
        // TODO: alert message
    }        
}

- (void)cancelNumberPad {
    
    [self _showAndFocusProductCode];
}

- (IBAction)save:(id)sender {
    
    [self _clearAndSetInvoiceItemInstance:TRUE];
}

- (IBAction)deleteInvoice:(id)sender {
    
    [self _clearAndSetInvoiceItemInstance:FALSE];
    [self _setTotalPriceLabel:@0.00];
}

#pragma mark - Text Field Delegate methods

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    return YES;
}


#pragma mark - TableView Data Source Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = [_invoiceItems count];
    // NSLog(@"No. of rows: %d", rows);
    
    if (0 == rows) {
        
        [self _disableSaveAndDeleteButton];
        
    } else {
    
        [self.saveButton setEnabled:YES];
        [self.deleteInvoiceButton setEnabled:YES];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvoiceItemCell"];
        
    NSMutableArray *items = _invoiceItems;
    
    if (items != nil && [items count] > 0) {

        UILabel *label;
        InvoiceItem *item = [items objectAtIndex:[indexPath row]];
        
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
    [self.invoiceTableView beginUpdates];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.invoiceTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
         
        InvoiceItem *item = [_invoiceItems objectAtIndex:[indexPath row]];
        
        [[self.currentInvoice items] removeObject:item];
        
        [_invoiceItems removeObjectAtIndex:[indexPath row]];
       
        
        if ([[self.currentInvoice items] count] == 0) {
            
            [self.currentInvoice setTotalPrice:@0];
            
        } else {

            [self.currentInvoice setTotalPrice:[self _recalculateTotalPrice]];
        }
        
        [self _setTotalPriceLabel:self.currentInvoice.totalPrice];
    }
    
    [self.invoiceTableView endUpdates];
    [self.invoiceTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedItem = [_invoiceItems objectAtIndex:[indexPath row]];
    
    if (nil != _selectedItem) {
        
        [self _setProductLabelAndShowQuantityWithName:[_selectedItem productName]
                                             andPrice:[_selectedItem productPrice]
                                            isNewItem:NO];
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

- (NSNumber *)_recalculateTotalPrice {
    
    double totalPrice = 0.0;
    [self.currentInvoice setTotalPrice:@0.0];
    
    for (InvoiceItem *item in [self.currentInvoice items]) {
               
//        NSLog(@"Result before: %.2lf", totalPrice);
//         NSLog(@"Product: %@ :: Price: %@ :: Quantity: %@", item.productName, item.productPrice, item.quantity);
        totalPrice += ([[item productPrice] doubleValue] * [[item quantity] intValue]);
    }    
    
    NSNumber *result = [NSNumber numberWithDouble:totalPrice];
    
    [self.currentInvoice setTotalPrice:result];
    return result;
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
    
    _numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Next", nil) style:UIBarButtonItemStyleDone target:self action:@selector(nextNumberPad)],
                           nil];
}

- (void)_checkIfAnyProductsAndGetFromServer {
    
    if ([self.query getProductsCount] == 0) {
        
        [MIHelper showAlerMessageWithTitle:@"No Products"
                               withMessage:@"There are no products. Proucts will be syced with server!"
                     withCancelButtonTitle:@"OK"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [MIRestJSON callProductsApiAndSetProductsArrayForToken:_authToken];
    }
}

- (void)_cleanAndReloadInvoiceItemsForTableView:(NSSet *)items {
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO]];
    NSArray *sorteditems = [[[self.currentInvoice items] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    _invoiceItems = [NSMutableArray arrayWithArray:sorteditems];
}

- (void)_clearAndSetInvoiceItemInstance:(BOOL)setInvoice {
    
    if (setInvoice == TRUE)
    {
        [self _createJSONDataFromCurrentInvoice];
    }
    
    [self.currentInvoice setTotalPrice:@0.00];
    [self.currentInvoice setItems:[[NSMutableSet alloc] init]];
    [_invoiceItems removeAllObjects];
    [self.invoiceTableView reloadData];
    [self _disableSaveAndDeleteButton];
}

- (void)_createJSONDataFromCurrentInvoice {
    
    NSArray *items = [self _createInvoiceItemsJSON];
    
    NSDictionary *jsonValues = @{
        @"totalPrice" : [self.currentInvoice totalPrice],
        @"items" : items
    };
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonValues options:kNilOptions error:&error];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    
    [MIRestJSON callInvoicesApiWithJSONData:jsonValues forToken:_authToken];
}

- (NSArray *)_createInvoiceItemsJSON {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if (nil == [self.currentInvoice items]
        || [[self.currentInvoice items] count] == 0) {
        
        return nil;
    }
    
    for (InvoiceItem *item in [self.currentInvoice items]) {
        
        [result addObject: @{
            // @"id" : item.id,
             @"productId" : item.productId,
             @"quantity" : item.quantity
         }];
        
        NSLog(@"item: %@", result[0]);
    }
    
    return result;
}

- (void)_disableSaveAndDeleteButton {
    
    [self.saveButton setEnabled:NO];
    [self.deleteInvoiceButton setEnabled:NO];
}

- (void)_setProductLabelAndShowQuantityWithName:(NSString *)name
                                      andPrice:(NSNumber *)price
                                     isNewItem:(BOOL)isNewItem {    
    
    name = [MIHelper truncateString:name toNumberOfCharsWithThreeDots:17];
    
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
    
    _numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:saveText style:UIBarButtonItemStyleDone target:self action:@selector(addOrChangeNumberPad)],
                           nil];
}

@end
