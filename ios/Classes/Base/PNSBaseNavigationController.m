//
//  PNSBaseNavigationController.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/21.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "PNSBaseNavigationController.h"

@interface PNSBaseNavigationController ()

@end

@implementation PNSBaseNavigationController

- (BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
//}

@end
