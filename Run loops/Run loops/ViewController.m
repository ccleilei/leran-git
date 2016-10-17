//
//  ViewController.m
//  Run loops
//
//  Created by 晓磊 on 16/9/5.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "ViewController.h"
#import "RunLoopSource.h"
#import "MyWorkerThread.h"
#import <objc/message.h>
@interface ViewController ()<NSPortDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  //  [self obseverRunloop];
    [self lacnchThtead];
    
}
-(void)testGCD{
    dispatch_queue_t q=dispatch_queue_create("asasasa", DISPATCH_QUEUE_CONCURRENT);
}

-(void)testNSinvocatonOperation{
    NSInvocationOperation* opera=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(op) object:nil];
    NSOperationQueue* quee=[[NSOperationQueue alloc] init];
    quee.maxConcurrentOperationCount=5;
    [quee addOperation:opera];
}

-(void)lacnchThtead{
    NSPort* myPort=[NSPort port];
    myPort.delegate=self;
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    MyWorkerThread *work = [[MyWorkerThread alloc] init];
    [NSThread detachNewThreadSelector:@selector(LaunchThreadWithPort:) toTarget:work withObject:myPort];
}
-(void)handlePortMessage:(NSPortMessage *)message{
   
 
     NSLog(@"接收到work子线程的消息...\n%@",message);
    
}
-(void)handleMachMessage:(void *)msg{

    NSLog(@"接收到work子线程的消息...\n");

}
-(void)obseverRunloop{
    NSRunLoop* loop=[NSRunLoop currentRunLoop];
    [loop getCFRunLoop];
     CFRunLoopObserverContext  context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                               kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    
    if(observer)
    {
        // 将Cocoa的NSRunLoop类型转换程Core Foundation的CFRunLoopRef类型
        CFRunLoopRef cfRunLoop = [loop getCFRunLoop];
        // 将新建的observer加入到当前的thread的run loop
        CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode);
    }
    NSInteger loopCount = 10;
    do
    {
        // 启动当前thread的run loop直到所指定的时间到达，在run loop运行时，run loop会处理所有来自与该run loop联系的input sources的数据
        // 对于本例与当前run loop联系的input source只有Timer类型的source
        // 该Timer每隔0.1秒发送触发时间给run loop，run loop检测到该事件时会调用相应的处理方法（doFireTimer:）
        // 由于在run loop添加了observer，且设置observer对所有的run loop行为感兴趣
        // 当调用runUntilDate方法时，observer检测到run loop启动并进入循环，observer会调用其回调函数，第二个参数所传递的行为时kCFRunLoopEntry
        // observer检测到run loop的其他行为并调用回调函数的操作与上面的描述相类似
        [loop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        // 当run loop的运行时间到达时，会退出当前的run loop，observer同样会检测到run loop的退出行为，并调用其回调函数，第二个参数传递的行为是kCFRunLoopExit.
        --loopCount;
    }while(loopCount);
}

void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    NSLog(@"xxxxx%lu",activity);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
