#import "CustomButton.h"

@implementation CustomButton


// title的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
  /// CGFloat x, CGFloat y, CGFloat width, CGFloat height
  return CGRectMake(0, self.bounds.size.height + 5, self.bounds.size.width, 16);
}
//背景图的位置
- (CGRect)backgroundRectForBounds:(CGRect)bounds{
  return CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}
@end
