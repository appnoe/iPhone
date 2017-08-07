#import "DiaryEntryCell.h"

@interface DiaryEntryCell()

@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *entryTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end

@implementation DiaryEntryCell

- (UIControl *)imageControl {
    return (UIControl *) self.iconView.superview;
}

- (void)setIcon:(UIImage *)inImage {
    UIImageView *theView = self.iconView;
    
    theView.image = inImage;
}

- (void)setText:(NSString *)inText {
    self.entryTextLabel.text = inText;
}

- (void)setDate:(NSDate *)inDate {
    NSDateFormatter *theFormatter = [[NSDateFormatter alloc] init];
    
    theFormatter.dateStyle = NSDateFormatterMediumStyle;
    theFormatter.locale = [NSLocale currentLocale];
    self.dateLabel.text = [theFormatter stringFromDate:inDate];
}

@end
