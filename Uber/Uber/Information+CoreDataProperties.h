//
//  Information+CoreDataProperties.h
//  Uber
//
//  Created by Tony Jin on 6/14/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Information.h"

NS_ASSUME_NONNULL_BEGIN

@interface Information (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *username;

@end

NS_ASSUME_NONNULL_END
