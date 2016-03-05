//
//  CoreTest+CoreDataProperties.h
//  iOS_SN_CoreData
//
//  Created by TRACEBoard on 16/3/3.
//  Copyright © 2016年 zzq. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CoreTest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreTest (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
