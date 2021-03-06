//
//  MIAppDelegate.m
//  eRacun
//
//  Created by Kornelije Sajler on 3.12.2012.
//  Copyright (c) 2012 Metaintellect. All rights reserved.
//

#import "MIAppDelegate.h"
#import "MIMainViewController.h"
#import "Product.h"
#import "Account.h"

@implementation MIAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self _setTintToNavigationBar];
    // [self _createProductsDummyData];
    // [self _fetchAllProducts];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Tina" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"eRacun.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

# pragma mark - Custom Navigation appearance

-(void)_setTintToNavigationBar {

    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[versionCompatibility objectAtIndex:0] intValue] >= 7) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:177/255.0f green:224/255.0f blue:1/255.0f alpha:1.0f]];
        
        // UIColor colorWithRed:153/255.0f green:204/255.0f blue:0/255.0f alpha:1.0f]
    }
    else
    {
        UIImage *backgroundImage = [UIImage imageNamed:@"nav_bg.png"];
        [[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    }
    
}

#pragma mark - Create Products dummy data

//- (void)_createProductsDummyData
//{
//    Product *kikiriki = (Product *)[NSEntityDescription insertNewObjectForEntityForName:@"Product"
//                                                                 inManagedObjectContext:[self managedObjectContext]];
//    [kikiriki setId:@1];
//    [kikiriki setName:@"Kikiriki kokice i zanimacije i svasta nosto"];
//    [kikiriki setPrice:@23.3];
//    
//    Product *medica = (Product *)[NSEntityDescription insertNewObjectForEntityForName:@"Product"
//                                                                 inManagedObjectContext:[self managedObjectContext]];
//    [medica setId:@2];
//    [medica setName:@"Medica"];
//    [medica setPrice:@66.66];
//    
//    NSError *error = nil;
//    
//    if (! [[self managedObjectContext] save:&error]) {
//        NSLog(@"Huston, we have a problem!\n%@", error);
//    }
//}

//- (void)_fetchAllProducts
//{
//    NSFetchRequest *request = [[self managedObjectModel] fetchRequestTemplateForName:@"GetAllProducts"];
//    
//    NSError *error = nil;
//    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
//    
//    if (fetchedObjects == nil) {
//        NSLog(@"Huston, we have a problem!\n%@", error);
//    }
//    
//    for (Product *product in fetchedObjects) {
//        NSLog(@"Name: %@", [product name]);
//    }
//}

@end
