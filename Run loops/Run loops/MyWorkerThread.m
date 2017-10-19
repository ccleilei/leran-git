//
//  MyWorkerThread.m
//  Run loops
//
//  Created by 晓磊 on 16/9/7.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MyWorkerThread.h"
#import "RunLoopSource.h"
@implementation MyWorkerThread
//端口源
-(void)LaunchThreadWithPort:(id)inData

{
    _remotePort= (NSPort *)inData;
    
    [[NSThread currentThread] setName:@"MyWorkerClassThread"];
   
    _myPort = [NSPort port];
    [_myPort setDelegate:self];
    [[NSRunLoop currentRunLoop] addPort:_myPort forMode:NSRunLoopCommonModes];
    [self sendPortMessage];
    [[NSRunLoop currentRunLoop] run];
}

-(void)sendPortMessage{
    NSMutableArray *array  =[[NSMutableArray alloc]initWithArray:@[@"1",@"2"]];
  //  NSString* st=@"hello";
    //发送消息到主线程，操作1
    NSLog(@"子线程发送端口消息 %@",[NSThread currentThread]);
    [_remotePort sendBeforeDate:[NSDate date]
                         msgid:10
                    components:array
                          from:_myPort
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
    
//        unsigned int msgid = [message msgid];
//        NSPort* distantPort = nil;
//    
//        if (msgid == kCheckinMessage)
//        {
//            distantPort = [message sendPort];
//    
//        }
//        else if(msgid == kExitMessage)
//        {
//            CFRunLoopStop((__bridge CFRunLoopRef)[NSRunLoop currentRunLoop]);
//        }
}
@end
