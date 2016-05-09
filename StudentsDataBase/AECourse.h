//
//  AECourse.h
//  StudentsDataBase
//
//  Created by Admin on 09.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEObject.h"

@class AEStudent, AEUniversity;

NS_ASSUME_NONNULL_BEGIN

@interface AECourse : AEObject

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) AEUniversity *university;
@property (nullable, nonatomic, retain) NSSet<AEStudent *> *students;

@end

@interface AECourse (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(AEStudent *)value;
- (void)removeStudentsObject:(AEStudent *)value;
- (void)addStudents:(NSSet<AEStudent *> *)values;
- (void)removeStudents:(NSSet<AEStudent *> *)values;

@end


NS_ASSUME_NONNULL_END


