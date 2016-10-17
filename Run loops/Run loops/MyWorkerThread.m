//
//  MyWorkerThread.m
//  Run loops
//
//  Created by 晓磊 on 16/9/7.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MyWorkerThread.h"

@implementation MyWorkerThread
-(void)LaunchThreadWithPort:(id)inData

{
    remotePort= (NSPort *)inData;
    
    [[NSThread currentThread] setName:@"MyWorkerClassThread"];
    [[NSRunLoop currentRunLoop] run];
    myPort = [NSMachPort port];
    [myPort setDelegate:self];
    
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
   
     [self sendPortMessage];
}
-(void)sendPortMessage{
    NSMutableArray *array  =[[NSMutableArray alloc]initWithArray:@[@"1",@"2"]];
  //  NSString* st=@"hello";
    //发送消息到主线程，操作1
    [remotePort sendBeforeDate:[NSDate date]
                         msgid:10
                    components:array
                          from:myPort
                      reserved:0];
}
#pragma mark - NSPortDelegate

/**
 *  接收到主线程port消息
 */
-(void)handleMachMessage:(void *)msg{
    NSMutableArray* arr=(__bridge NSMutableArray *)(msg);
     NSLog(@"接收到父线程的消息...\n");
}
- (void)handlePortMessage:(NSPortMessage *)message{
    NSLog(@"接收到父线程的消息...\n");
    
    //    unsigned int msgid = [message msgid];
    //    NSPort* distantPort = nil;
    //
    //    if (msgid == kCheckinMessage)
    //    {
    //        distantPort = [message sendPort];
    //
    //    }
    //    else if(msgid == kExitMessage)
    //    {
    //        CFRunLoopStop((__bridge CFRunLoopRef)[NSRunLoop currentRunLoop]);
    //    }
}
@end
