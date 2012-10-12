#import <CoreData/CoreData.h>

@class DiaryEntry;

@interface Medium : NSManagedObject

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) DiaryEntry *diaryEntry;

@end
