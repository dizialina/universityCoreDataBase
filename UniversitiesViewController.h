//
//  UniversitiesViewController.h
//  StudentsDataBase
//
//  Created by Admin on 09.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"

@class AECourse, AEUniversity, AEStudent;

typedef enum {
    kAllList,
    kUniversity,
    kCourse,
} DataMode;

@interface UniversitiesViewController : CoreDataViewController

@property (assign, nonatomic) DataMode dataMode;
@property (strong, nonatomic) AEUniversity *currentUniversity;
@property (strong, nonatomic) AECourse *currentCourse;

@end
