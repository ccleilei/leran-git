//
//  AppDelegate.h
//  Run loops
//
//  Created by 晓磊 on 16/9/5.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunLoopSource.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)registerSource:(RunLoopContext*)sourceInfo;

@end

