#import <CoreData/CoreData.h>

extern NSString * const kMediumTypeImage;
extern NSString * const kMediumTypeAudio;

@class Medium;

@interface DiaryEntry : NSManagedObject

@property (nonatomic, retain) NSData *icon;
@property (nonatomic, retain) NSDate *creationTime;
@property (nonatomic, retain) NSDate *updateTime;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, copy) NSSet *media;

- (BOOL)hasContent;

- (Medium *)mediumForType:(NSString *)inType;
- (void)removeMediumForType:(NSString *)inType;

- (void)addMedium:(Medium *)inMedium;
- (void)removeMedium:(Medium *)inMedium;

@end