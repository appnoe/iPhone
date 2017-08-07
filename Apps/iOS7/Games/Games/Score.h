//
//  Score.h
//  Games
//
//  Created by Clemens Wagner on 07.06.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Score : NSManagedObject

@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSDate *creationTime;
@property (nonatomic, strong) NSDate *updateTime;
@property (nonatomic, strong) NSString *game;

@end
