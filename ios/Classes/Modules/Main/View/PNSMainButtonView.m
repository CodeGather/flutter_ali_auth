//
//  PNSMainButtonView.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "PNSMainButtonView.h"

@interface PNSMainButtonView ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, copy) NSString *buttonTitle;

@property (nonatomic, weak) id buttonTarget;

@property (nonatomic, assign) SEL buttonAction;

@property (nonatomic, copy) NSString *descriptionText;

@end

@implementation PNSMainButtonView

- (instancetype)initWithButtonTitle:(NSString *)buttonTitle
                       buttonTarget:(id)buttonTarget
                       buttonAction:(SEL)buttonAction
                    descriptionText:(NSString *)descriptionText {
    self = [super init];
    if (self) {
        self.buttonTitle = buttonTitle;
        self.buttonTarget = buttonTarget;
        self.buttonAction = buttonAction;
        self.descriptionText = descriptionText;

        [self initSubviews];
        [self setLayoutSubviews];        
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.button];
    [self addSubview:self.label];
}

- (void)setLayoutSubviews {
    [self.button mas_makeConstraints:^(MASConstraintMaker * _Nonnull make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(45);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker * _Nonnull make) {
        make.top.mas_equalTo(self.button.mas_bottom).offset(5);
        make.left.mas_equalTo(self.button);
        make.right.mas_equalTo(self.button);
        make.bottom.mas_equalTo(self);
    }];
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.backgroundColor = [UIColor orangeColor];
        _button.titleLabel.adjustsFontSizeToFitWidth = YES;
        _button.titleLabel.numberOfLines = 0;
        _button.layer.cornerRadius = 5.0;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitle:self.buttonTitle forState:UIControlStateNormal];
        [_button addTarget:self.buttonTarget
                    action:self.buttonAction
          forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = self.descriptionText;
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor grayColor];
    }
    return _label;
}

@end
