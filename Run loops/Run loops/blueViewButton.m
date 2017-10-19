//
//  blueViewButton.m
//  Run loops
//
//  Created by 晓磊 on 2017/10/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "blueViewButton.h"

@implementation blueViewButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"blue pointInside");
    return YES;
}

@end
