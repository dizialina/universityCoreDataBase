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
    
    NSString *newObjectName;
    NSMutableArray *newStudentProperties;
    UIAlertAction *currentCreateAction;

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
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAlertView)];
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, addButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject {
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    switch (self.dataMode) {
        case kAllList: {
            
            AEUniversity *newUniversity = [NSEntityDescription insertNewObjectForEntityForName:@"AEUniversity" inManagedObjectContext:context];
            if (newObjectName.length > 0) {
                newUniversity.name = newObjectName;
                newObjectName = nil;
            }
            break;
        }
        case kUniversity: {
            
            AECourse *newCourse = [NSEntityDescription insertNewObjectForEntityForName:@"AECourse" inManagedObjectContext:context];
            if (newObjectName.length > 0) {
                newCourse.name = newObjectName;
                newObjectName = nil;
                newCourse.university = self.currentUniversity;
            }
            break;
        }
        case kCourse: {
            
            AEStudent *newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"AEStudent" inManagedObjectContext:context];
            newStudent.firstName = @"Aaaaa";
            newStudent.lastName = @"Bbbbb";
            [newStudent addCoursesObject:self.currentCourse];
            break;
        }
    }

    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error adding new object: %@, %@", error, [error userInfo]);
        abort();
    }
}

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

- (void)showAlertView {
    
    NSString *doneTitle = @"Create";
    NSString *title;
    
    switch (self.dataMode) {
        case kAllList:
            title = @"New university name";
            break;
        case kUniversity:
            title = @"New course name";
            break;
        case kCourse:
            title = @"New student name";
            break;
    }

    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"Write the name of your new object:" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *createAction = [UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        newObjectName = alertController.textFields.firstObject.text;
        [self insertNewObject];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:createAction];
    [alertController addAction:cancelAction];
    createAction.enabled = false;
    currentCreateAction = createAction;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Object name";
        [textField addTarget:self action:@selector(audioFileNameDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    /*
    if (self.dataMode == kCourse) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Object name";
            [textField addTarget:self action:@selector(audioFileNameDidChange:) forControlEvents:UIControlEventEditingChanged];
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Object name";
            [textField addTarget:self action:@selector(audioFileNameDidChange:) forControlEvents:UIControlEventEditingChanged];
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Object name";
            [textField addTarget:self action:@selector(audioFileNameDidChange:) forControlEvents:UIControlEventEditingChanged];
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Object name";
            [textField addTarget:self action:@selector(audioFileNameDidChange:) forControlEvents:UIControlEventEditingChanged];
        }];
    }
    */
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void) audioFileNameDidChange:(UITextField*) textField {
    currentCreateAction.enabled = YES;
}

@end
