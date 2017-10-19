//
//  RunLoopSource.h
//  Run loops
//
//  Created by 晓磊 on 16/9/6.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
//自定义输入源
@interface RunLoopSource : NSObject
{
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray* commands;
}
@property (nonatomic,weak) ViewController * del;
- (id)init;
- (void)addToCurrentRunLoop;
- (void)invalidate;

// Handler method
- (void)sourceFired;

// Client interface for registering commands to process
- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;
@end
@interface RunLoopContext : NSObject
{
    CFRunLoopRef runLoop;
    RunLoopSource* source;
}
@property (nonatomic,assign) CFRunLoopRef runLoop;
@property (nonatomic,strong) RunLoopSource* source;
- (id)initWithSource:(RunLoopSource*)src andLoop:(CFRunLoopRef)loop;
@end

