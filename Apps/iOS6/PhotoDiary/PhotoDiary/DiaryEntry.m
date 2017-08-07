#import "DiaryEntry.h"
#import "Medium.h"

NSString * const kMediumTypeImage = @"image";
NSString * const kMediumTypeAudio = @"audio";

@interface DiaryEntry(CoreDataGeneratedAccessors)

- (void)addMediaObject:(Medium *)value;
- (void)removeMediaObject:(Medium *)value;
- (void)addMedia:(NSSet *)values;
- (void)removeMedia:(NSSet *)values;

@end

@implementation DiaryEntry

@dynamic icon;
@dynamic creationTime;
@dynamic updateTime;
@dynamic text;
@dynamic media;

- (void)awakeFromInsert {
    [super awakeFromInsert];
    NSDate *theDate = [NSDate date];
    
    [self setPrimitiveValue:theDate forKey:@"creationTime"];
    [self setPrimitiveValue:theDate forKey:@"updateTime"];
}

- (void)willSave {
    [super willSave];
    if(!self.isDeleted) {
        NSDate *theDate = [NSDate date];
        
        [self setPrimitiveValue:theDate forKey:@"updateTime"];
    }
}

- (BOOL)hasContent {
    return self.text.length > 0 || self.media.count > 0;
}

- (Medium *)mediumForType:(NSString *)inType {
    for(Medium *theMedium in self.media) {
        if([[theMedium type] isEqualToString:inType]) {
            return theMedium;
        }
    }
    return nil;
}

- (void)removeMediumForType:(NSString *)inType {
    Medium *theMedium = [self mediumForType:inType];

    [self removeMedium:theMedium];
}

- (void)addMedium:(Medium *)inMedium {
    if(inMedium != nil) {
        [self removeMediumForType:inMedium.type];
        [self addMediaObject:inMedium];
    }
}

- (void)removeMedium:(Medium *)inMedium {
    if(inMedium != nil) {
        inMedium.diaryEntry = nil;
        [self.managedObjectContext deleteObject:inMedium];
    }
}

@end
