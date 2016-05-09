//
//  AECar.h
//  StudentsDataBase
//
//  Created by Admin on 09.05.16.
//  Copyright © 2016 Alina Egorova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEObject.h"

@class AEStudent;

NS_ASSUME_NONNULL_BEGIN

@interface AECar : AEObject

@property (nullable, nonatomic, retain) NSString *model;
@property (nullable, nonatomic, retain) AEStudent *owner;

@end

NS_ASSUME_NONNULL_END