#import <UIKit/UIKit.h>


@interface DiaryEntryCell : UITableViewCell

@property (nonatomic, weak, readonly) UIControl *imageControl;

- (void)setText:(NSString *)inText;
- (void)setIcon:(UIImage *)inImage;
- (void)setDate:(NSDate *)inDate;

@end
