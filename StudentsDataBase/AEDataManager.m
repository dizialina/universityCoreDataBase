//
//  AEDataManager.m
//  StudentsDataBase
//
//  Created by Admin on 09.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import "AEDataManager.h"
#import "AEStudent.h"
#import "AECar.h"
#import "AEUniversity.h"
#import "AECourse.h"

static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

static NSString* carModelNames[] = {
    @"Dodge", @"Toyota", @"BMW", @"Lada", @"Volga",
    @"Lexus", @"Chery", @"Smart", @"Nissan", @"Bentley",
    @"Mercedes", @"Honda", @"Alfa Romeo", @"Pagani", @"Subaru",
    @"Foton", @"Fauxhall", @"Dacia", @"Abarth", @"Daewoo",
    @"Rolls Royce", @"Kia", @"Acura", @"Maybach", @"Aston Martin",
    @"Land Rover", @"Maserati", @"Jeep", @"Infiniti", @"Tesla"
};

@implementation AEDataManager

+ (AEDataManager *)sharedManager {
    
    static AEDataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[AEDataManager alloc] init];
    });
    return dataManager;
}

#pragma mark - Generate random objects

- (AEStudent*)addRandomStudent {
    
    AEStudent *student =
    [NSEntityDescription insertNewObjectForEntityForName:@"AEStudent"
                                  inManagedObjectContext:self.managedObjectContext];
    
    student.score = @((float)arc4random_uniform(201) / 100.f + 2.f);
    student.dateOfBirth = [NSDate dateWithTimeIntervalSince1970:60 * 60 * 24 * 365 * arc4random_uniform(31)];
    student.firstName = firstNames[arc4random_uniform(50)];
    student.lastName = lastNames[arc4random_uniform(50)];
    
    return student;
}

- (AECar*)addRandomCar {
    
    AECar *car = [NSEntityDescription insertNewObjectForEntityForName:@"AECar"
                                               inManagedObjectContext:self.managedObjectContext];
    
    car.model = carModelNames[arc4random_uniform(30)];
    
    return car;
}

- (AECourse*)addCourseWithName:(NSString*) courseName {
    
    AECourse *course = [NSEntityDescription insertNewObjectForEntityForName:@"AECourse"
                                                     inManagedObjectContext:self.managedObjectContext];
    
    course.name = courseName;
    
    return course;
}

- (void)addStudentsToDatabaseUniversityNamed:(NSString*) universityName {
    
    // create university with name
    
    AEUniversity *university = [NSEntityDescription insertNewObjectForEntityForName:@"AEUniversity" inManagedObjectContext:self.managedObjectContext];
    
    university.name = universityName;
    
    NSArray *coursesNames = @[
        @"iOS", @"Android", @"PHP", @"Java", @"Javascript",
        @"Python", @"C++", @"C#", @"Designer", @"Delphi",
        @"Ruby", @"1C"];
    
    NSMutableArray *newCourses = [[NSMutableArray alloc] init];
    
    for (NSString *courseName in coursesNames) {
        [newCourses addObject:[self addCourseWithName:courseName]];
    }
    
    [university addCourses:[NSSet setWithArray:newCourses]];

    // create 200 random students, add every student a car (chance 50%), and add them random number of courses
    
    for (int i = 0; i < 200; i++) {
        
        AEStudent *student = [self addRandomStudent];
        if (arc4random_uniform(2)) {
            student.car = [self addRandomCar];
        }
        
        student.university = university;
        
        int numberOfCourses = arc4random_uniform(12);
        while ([student.courses count] < numberOfCourses) {
            AECourse *course = [newCourses objectAtIndex:arc4random_uniform(12)];
            if (![student.courses containsObject:course]) {
                [student addCoursesObject:course];
            }
        }
        
    }
    
    // write all to database
    
    [self saveChangesToDatabase];
    
}

- (NSArray*)allObjectsFromDatabase {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"AEObject" inManagedObjectContext:self.managedObjectContext]];
    
    NSError *requestError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"Error writing to database: %@", [requestError localizedDescription]);
    }

    return result;
}

- (NSArray*)allUniversitiesFromDatabase {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"AEUniversity" inManagedObjectContext:self.managedObjectContext]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *requestError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"Error writing to database: %@", [requestError localizedDescription]);
    }
    
    return result;
}


- (void)deleteAllObjectsFromDatabase {
    
    NSArray *result = [self allObjectsFromDatabase];
    for (AEObject *obj in result) {
        [self.managedObjectContext deleteObject:obj];
    }
    
    [self saveChangesToDatabase];
    
}

- (void)printAllObjectsFromDatabase {
    
    NSArray *result = [self allObjectsFromDatabase];
    for (AEObject *obj in result) {
        
        if ([obj isKindOfClass:[AEUniversity class]]) {
            AEUniversity *university = (AEUniversity*) obj;
            NSLog(@"UNIVERSITY: %@, number of students: %lu", university.name, [university.students count]);
            
        } else if ([obj isKindOfClass:[AECourse class]]) {
            AECourse *course = (AECourse*) obj;
            NSLog(@"COURSE: %@, students on course: %lu", course.name, [course.students count]);
            
        } else if ([obj isKindOfClass:[AEStudent class]]) {
            AEStudent *student = (AEStudent*) obj;
            NSLog(@"STUDENT: %@ %@, number of courses: %lu, score: %.2f", student.firstName, student.lastName, [student.courses count], [student.score floatValue]);
            
        } else if ([obj isKindOfClass:[AECar class]]) {
            AECar *car = (AECar*) obj;
            NSLog(@"CAR: %@, owner: %@ %@", car.model, car.owner.firstName, car.owner.lastName);
        }
        
    }

}

- (void)saveChangesToDatabase {
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error writing to database: %@", [error localizedDescription]);
    }
    
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {

    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StudentsDataBase" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"StudentsDataBase.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
