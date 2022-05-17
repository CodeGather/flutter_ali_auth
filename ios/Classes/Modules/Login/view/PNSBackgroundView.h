
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNSBackgroundView : UIView

@property (nonatomic, strong) NSURL *gifUrl;

@property (nonatomic, strong) NSURL *videoUrl;

- (void)show;

@end

NS_ASSUME_NONNULL_END
