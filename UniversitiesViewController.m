//
//  UniversitiesViewController.m
//  StudentsDataBase
//
//  Created by Admin on 09.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import "UniversitiesViewController.h"
#import "StudentDetailViewController.h"
#import "AEDataManager.h"
#import "AEStudent.h"
#import "AECourse.h"
#import "AECar.h"
#import "AEUniversity.h"

@interface UniversitiesViewController () {

}

@end

@implementation UniversitiesViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.dataMode) {
        self.dataMode = kAllList;
        self.navigationItem.title = @"Universities";
    }
    
    switch (self.dataMode) {
        case kAllList:
            self.navigationItem.title = @"Universities";
            break;
        case kUniversity:
            self.navigationItem.title = self.currentUniversity.name;
            break;
        case kCourse:
            self.navigationItem.title = self.currentCourse.name;
            break;
    }

    
    /*
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    */

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
*/

# pragma mark - Getters

- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[AEDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

# pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    NSSortDescriptor *sortDescriptor;
    NSPredicate *predicate;
    NSMutableArray *descriptors = [[NSMutableArray alloc] init];
    
    switch (self.dataMode) {
        case kAllList: {
            entity = [NSEntityDescription entityForName:@"AEUniversity" inManagedObjectContext:self.managedObjectContext];
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            [descriptors addObject:sortDescriptor];
            break;
        }
        case kUniversity: {
            entity = [NSEntityDescription entityForName:@"AECourse" inManagedObjectContext:self.managedObjectContext];
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            [descriptors addObject:sortDescriptor];
            predicate = [NSPredicate predicateWithFormat:@"university == %@", self.currentUniversity];
            break;
        }
        case kCourse: {
            entity = [NSEntityDescription entityForName:@"AEStudent" inManagedObjectContext:self.managedObjectContext];
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
            NSSortDescriptor *secondSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
            [descriptors addObject:sortDescriptor];
            [descriptors addObject:secondSortDescriptor];
            predicate = [NSPredicate predicateWithFormat:@"courses contains %@", self.currentCourse];
            break;
        }
    }

    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    [fetchRequest setSortDescriptors:descriptors];
    
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}    

# pragma mark - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = self.storyboard;
    
    switch (self.dataMode) {
        case kAllList: {
            UniversitiesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UniversitiesViewController"];
            vc.currentUniversity = [self.fetchedResultsController objectAtIndexPath:indexPath];
            vc.dataMode = kUniversity;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case kUniversity: {
            UniversitiesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UniversitiesViewController"];
            vc.currentCourse = [self.fetchedResultsController objectAtIndexPath:indexPath];
            vc.dataMode = kCourse;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case kCourse: {
            StudentDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"StudentDetailViewController"];
            vc.student = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
    
}

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object {
    
    switch (self.dataMode) {
        case kAllList: {
            AEUniversity *university = (AEUniversity*) object;
            cell.textLabel.text = university.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"courses: %ld", [university.courses count]];
            break;
        }
        case kUniversity: {
            AECourse *course = (AECourse*) object;
            cell.textLabel.text = course.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"students: %ld", [course.students count]];
            break;
        }
        case kCourse: {
            AEStudent *student = (AEStudent*) object;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"score: %.2f", [student.score floatValue]];
            break;
        }
    }

    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

    
}


@end
