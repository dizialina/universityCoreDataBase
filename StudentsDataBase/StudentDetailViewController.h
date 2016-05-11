//
//  StudentDetailViewController.h
//  StudentsDataBase
//
//  Created by Admin on 10.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AEStudent;

@interface StudentDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *score;
@property (weak, nonatomic) IBOutlet UITextField *car;
@property (weak, nonatomic) IBOutlet UIPickerView *university;
@property (weak, nonatomic) IBOutlet UITableView *coursesTable;

@property (strong, nonatomic) AEStudent* student;

- (IBAction)saveChanges:(id)sender;

@end
