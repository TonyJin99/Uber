//
//  CallingInformation+CoreDataProperties.h
//  Uber
//
//  Created by Tony Jin on 6/27/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CallingInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CallingInformation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;

@end

NS_ASSUME_NONNULL_END
