//
//  AEUniversity.h
//  StudentsDataBase
//
//  Created by Admin on 09.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEObject.h"

@class AECourse, AEStudent;

NS_ASSUME_NONNULL_BEGIN

@interface AEUniversity : AEObject

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<AECourse *> *courses;
@property (nullable, nonatomic, retain) NSSet<AEStudent *> *students;

@end

@interface AEUniversity (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(AECourse *)value;
- (void)removeCoursesObject:(AECourse *)value;
- (void)addCourses:(NSSet<AECourse *> *)values;
- (void)removeCourses:(NSSet<AECourse *> *)values;

- (void)addStudentsObject:(AEStudent *)value;
- (void)removeStudentsObject:(AEStudent *)value;
- (void)addStudents:(NSSet<AEStudent *> *)values;
- (void)removeStudents:(NSSet<AEStudent *> *)values;

@end

NS_ASSUME_NONNULL_END

