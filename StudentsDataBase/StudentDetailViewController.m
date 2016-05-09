//
//  StudentDetailViewController.m
//  StudentsDataBase
//
//  Created by Admin on 10.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import "StudentDetailViewController.h"
#import "AEStudent.h"
#import "AECourse.h"
#import "AECar.h"

@interface StudentDetailViewController ()

@end

@implementation StudentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.name.text = [NSString stringWithFormat:@"%@ %@", self.student.firstName, self.student.lastName];
    self.score.text = [NSString stringWithFormat:@"%.2f", [self.student.score floatValue]];
    
    if (self.student.car) {
        self.car.text = self.student.car.model;
    } else {
        self.car.text = @"---";
    }
    
    NSMutableString *courses = [[NSMutableString alloc] init];
    for (AECourse *course in self.student.courses) {
        [courses appendString:course.name];
        [courses appendString:@", "];
    }
    self.courses.text = courses;
    [self.courses sizeToFit];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    self.dateOfBirth.text = [formatter stringFromDate:self.student.dateOfBirth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
