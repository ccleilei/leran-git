//
//  yellowView.m
//  Run loops
//
//  Created by 晓磊 on 2017/10/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "yellowView.h"

@implementation yellowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        blueView = [blueViewButton buttonWithType:UIButtonTypeRoundedRect];
        blueView.frame = CGRectMake(0, -20, 100, 20);
        [blueView addTarget:self action:@selector(dosom) forControlEvents:UIControlEventTouchUpInside];
        [blueView setBackgroundColor: [UIColor blueColor] ];
        [self addSubview:blueView];
        
        redView = [[rRedView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:redView];
    }
    return self;
}

-(void)dosom{
    NSLog(@"haha");
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    return  blueView;
//}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
   // NSLog(@"是否在页面范围");
    return YES;
}

@end
