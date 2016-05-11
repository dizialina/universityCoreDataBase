//
//  AEDataManager.h
//  StudentsDataBase
//
//  Created by Admin on 09.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AEDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (AEDataManager *)sharedManager;
- (void)addStudentsToDatabaseUniversityNamed:(NSString*) universityName;
- (void)printAllObjectsFromDatabase;
- (void)deleteAllObjectsFromDatabase;
- (NSArray*)allUniversitiesFromDatabase;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
