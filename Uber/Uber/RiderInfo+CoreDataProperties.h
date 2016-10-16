//
//  RiderInfo+CoreDataProperties.h
//  Uber
//
//  Created by Tony Jin on 6/21/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RiderInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RiderInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *latitute;
@property (nullable, nonatomic, retain) NSNumber *lontitute;

@end

NS_ASSUME_NONNULL_END
