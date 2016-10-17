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


- (id)init {
    CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL, &RunLoopSourceScheduleRoutine, RunLoopSourceCancelRoutine,
        RunLoopSourcePerformRoutine
    };
  
    runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    commands = [[NSMutableArray alloc] init]; return self;
}
- (void)addToCurrentRunLoop {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
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
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    [del performSelectorOnMainThread:@selector(registerSource:) withObject:theContext waitUntilDone:NO]
    ;
  
}


void RunLoopSourcePerformRoutine (void *info) {
    RunLoopSource* obj = (__bridge RunLoopSource*)info;
    [obj sourceFired];
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode) { RunLoopSource* obj = (__bridge RunLoopSource*)info;
    UIApplication* del = [UIApplication sharedApplication];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    [del performSelectorOnMainThread:@selector(removeSource:) withObject:theContext waitUntilDone:YES];
}
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runLoop
{
    
    //当手动调用此方法的时候，将会触发 RunLoopSourceContext的performCallback
    
    CFRunLoopSourceSignal(runLoopSource);
    
    CFRunLoopWakeUp(runLoop);
    
}
@end
@implementation RunLoopContext

@end