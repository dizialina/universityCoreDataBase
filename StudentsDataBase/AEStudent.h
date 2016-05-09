//
//  AEStudent.h
//  StudentsDataBase
//
//  Created by Admin on 09.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEObject.h"

@class AECourse, AEUniversity, AECar;

NS_ASSUME_NONNULL_BEGIN

@interface AEStudent : AEObject

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSDate *dateOfBirth;
@property (nullable, nonatomic, retain) NSNumber *score;
@property (nullable, nonatomic, retain) AECar *car;
@property (nullable, nonatomic, retain) NSSet<AECourse *> *courses;
@property (nullable, nonatomic, retain) AEUniversity *university;

@end

@interface AEStudent (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(AECourse *)value;
- (void)removeCoursesObject:(AECourse *)value;
- (void)addCourses:(NSSet<AECourse *> *)values;
- (void)removeCourses:(NSSet<AECourse *> *)values;

@end

NS_ASSUME_NONNULL_END
