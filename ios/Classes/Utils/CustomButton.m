#import "CustomButton.h"

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // 默认高亮会把方形热区涂成灰框，图标透明角会露出来。
    self.adjustsImageWhenHighlighted = NO;
    self.showsTouchWhenHighlighted = NO;
    self.backgroundColor = UIColor.clearColor;
  }
  return self;
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
  [super setBackgroundImage:image forState:state];
  if (state == UIControlStateNormal && image != nil) {
    [super setBackgroundImage:image forState:UIControlStateHighlighted];
    [super setBackgroundImage:image forState:UIControlStateSelected];
  }
}

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
