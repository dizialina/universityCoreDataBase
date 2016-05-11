//
//  StudentDetailViewController.m
//  StudentsDataBase
//
//  Created by Admin on 10.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import "StudentDetailViewController.h"
#import "AEDataManager.h"
#import "AEUniversity.h"
#import "AEStudent.h"
#import "AECourse.h"
#import "AECar.h"

@interface StudentDetailViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *universitiesList;
    AEUniversity *currentUniversity;
}

@end

@implementation StudentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    universitiesList = [[AEDataManager sharedManager] allUniversitiesFromDatabase];
    
    self.firstName.text = self.student.firstName;
    self.lastName.text = self.student.lastName;
    self.score.text = [NSString stringWithFormat:@"%.2f", [self.student.score floatValue]];
    
    if (self.student.car) {
        self.car.text = self.student.car.model;
    } 
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    self.dateOfBirth.text = [formatter stringFromDate:self.student.dateOfBirth];
    
    for (int i = 0; i < universitiesList.count; i++) {
        AEUniversity *univ = universitiesList[i];
        if ([univ.name isEqualToString:self.student.university.name]) {
            [self.university selectRow:i inComponent:0 animated:YES];
        }
    }
    
    self.university.layer.borderColor = [UIColor grayColor].CGColor;
    self.university.layer.borderWidth = 0.5;
    
    if (self.student) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", self.student.firstName, self.student.lastName];
    } else {
        self.navigationItem.title = @"New student";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [universitiesList count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currentUniversity = universitiesList[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont fontWithName:@"System" size:12];
        AEUniversity *univ = universitiesList[row];
        tView.textAlignment = NSTextAlignmentCenter;
        tView.text = univ.name;
    }
    return tView;
}

- (IBAction)saveChanges:(id)sender {
    
    NSManagedObjectContext *context = [[AEDataManager sharedManager] managedObjectContext];
    
    if (!self.student) {
        self.student = [NSEntityDescription insertNewObjectForEntityForName:@"AEStudent" inManagedObjectContext:context];
    } else {
        [context refreshObject:self.student mergeChanges:NO];
    }
    
    self.student.firstName = self.firstName.text;
    self.student.lastName = self.lastName.text;
    
    self.student.score = [NSNumber numberWithFloat:[self.score.text floatValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    self.student.dateOfBirth = [formatter dateFromString:self.dateOfBirth.text];
    
    NSString *newCarModel = self.car.text;
    if (newCarModel.length > 0) {
        AECar *newCar = [NSEntityDescription insertNewObjectForEntityForName:@"AECar" inManagedObjectContext:context];
        newCar.model = newCarModel;
        self.student.car = newCar;
    }
    
    self.student.university = universitiesList[[self.university selectedRowInComponent:0]];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error adding new object: %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.navigationController popViewControllerAnimated:YES];    
}

@end
