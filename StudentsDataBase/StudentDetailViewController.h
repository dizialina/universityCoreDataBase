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

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *car;
@property (weak, nonatomic) IBOutlet UITextView *courses;


@property (strong, nonatomic) AEStudent* student;

@end
