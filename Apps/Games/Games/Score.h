//
//  Score.h
//  Games
//
//  Created by Clemens Wagner on 07.06.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Score : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSDate * creationTime;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSString * game;

@end
