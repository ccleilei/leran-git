//
//  RunLoopSource.m
//  Run loops
//
//  Created by 晓磊 on 16/9/6.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "RunLoopSource.h"
#import "AppDelegate.h"

@implementation RunLoopSource

//Init 方法创建 CGFunLoopSourceRef 类型，该类型必须被附加到 runloop 里。它将 RunLoopSource 对象作为上下文引用参数，以便回调例程持有该对象的一个引用指针。输入源的安装只在工作线程调用 addToCurrentRunLoop 方法才发生，此时 RunLoopSourceScheduledRoutine 被调用。一旦输入源被添加到 runloop，线程就运行 runloop 并等待事件。
- (id)init {
    CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL, &RunLoopSourceScheduleRoutine, RunLoopSourceCancelRoutine,
        RunLoopSourcePerformRoutine
    };
    runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    commands = [[NSMutableArray alloc] init]; return self;
}
- (void)addToCurrentRunLoop {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    NSLog(@"runloop加入输入源%@",[NSThread currentThread]);
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}



- (void)fireCommandsOnRunLoop:(CFRunLoopRef)runloop {
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}



void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    
    RunLoopSource* obj = (__bridge RunLoopSource*)info;
    UIApplication* del = [UIApplication sharedApplication];
    //根据 runloop输入源 和 runloop 获取 RunLoopContext，并将这个 RunLoopContext 注册到主线程，用于委托和输入源之间的通信。
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    //在主线程执行注册源
    [obj.del performSelector:@selector(registerSource:) withObject:theContext];
//    [obj.del performSelectorOnMainThread:@selector(registerSource:) withObject:theContext waitUntilDone:NO]
//    ;
  
}


void RunLoopSourcePerformRoutine (void *info) {
    NSLog(@"开始处理%@",[NSThread currentThread]);
    RunLoopSource* obj = (__bridge RunLoopSource*)info;
  //  [obj sourceFired];
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode) { RunLoopSource* obj = (__bridge RunLoopSource*)info;
    UIApplication* del = [UIApplication sharedApplication];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
     [obj.del performSelector:@selector(removeSource:) withObject:theContext];
//    [del performSelectorOnMainThread:@selector(removeSource:) withObject:theContext waitUntilDone:YES];
}
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runLoop
{
    
    //当手动调用此方法的时候，将会触发 RunLoopSourceContext的performCallback
    
   // CFRunLoopSourceSignal(runLoopSource);
    
    CFRunLoopWakeUp(runLoop);
    
}
@end
@implementation RunLoopContext
-(id)initWithSource:(RunLoopSource *)src andLoop:(CFRunLoopRef)loop {
    self = [super init];
    if (self) {
        _runLoop = loop;
        _source = src;
    }
    return self;
}
@end
