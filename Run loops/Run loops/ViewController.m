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
#import "yellowView.h"
#import "coreAnimateViewController.h"
@interface ViewController ()<NSPortDelegate,UITextFieldDelegate>
{
    NSMutableArray *sourcesToPing;
    NSThread *therad;
    RunLoopSource *sourc ;
    CFRunLoopRef runLoop;
    NSRunLoop *portLoop;
    MyWorkerThread *work;
    dispatch_source_t mySource;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  //  [self obseverRunloop];
   // [self lacnchThtead];
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, 100, 40)];
    field.borderStyle = UITextBorderStyleLine;
    field.delegate = self;
    [self.view addSubview:field];
  //  [self processSource];
    UIButton *bn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bn.frame = CGRectMake(100, 200, 100, 40);
    [bn setTitle:@"wake up" forState:UIControlStateNormal];
    [bn addTarget: self action:@selector(portWake) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bn];
    //事件传递
    yellowView *yellow = [[yellowView alloc] initWithFrame:CGRectMake(100, 100, 150, 80)];
    [yellow setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:yellow];
    
    UIButton *bn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bn1.frame = CGRectMake(100, 400, 100, 40);
    [bn1 setTitle:@"animate" forState:UIControlStateNormal];
    [bn1 addTarget: self action:@selector(animate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bn1];
}

-(void)animate{
    coreAnimateViewController *new = [[coreAnimateViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:new];
    [self presentViewController:nav animated:YES completion:nil];
}

# pragma mark dispatch_source
- (void)dispatchTimeSource {
    
    dispatch_queue_t quee = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    dispatch_source_t timeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quee);
    if (timeTimer) {
        dispatch_source_set_timer(timeTimer, dispatch_walltime(NULL, 0), 2 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timeTimer, ^{
            static int i = 0;
            ++i;
            NSLog(@"%d",i);
        });
        dispatch_source_set_cancel_handler(timeTimer, ^{
              NSLog(@"Signal canceled");
        }) ;
        dispatch_resume(timeTimer);
        mySource = timeTimer;
    }
}

- (void)dispatchSignalSource {
    signal(SIGQUIT, SIG_IGN);
    dispatch_queue_t quee = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);;
     dispatch_source_t signalSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGQUIT, 0, quee);
    if (signalSource) {
        dispatch_source_set_event_handler(signalSource, ^{
            static NSInteger i = 0;
            ++i;
            NSLog(@"Signal Detected: %ld",i);
        });
        dispatch_source_set_cancel_handler(signalSource, ^{
             NSLog(@"Signal canceled");
        });
        dispatch_resume(signalSource);
    }
    mySource = signalSource;
}

- (void)coustomDispatchSource {
   static dispatch_source_t Stimer = nil;
    static dispatch_source_t source = nil;
   dispatch_queue_t tquee = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
     dispatch_queue_t quee = dispatch_get_main_queue();
    source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, quee);
    dispatch_resume(source);
    dispatch_source_set_event_handler(source, ^{
        NSLog(@"receive data %ld %@", dispatch_source_get_data(source),[NSThread currentThread]);
    });
    dispatch_source_set_cancel_handler(source, ^{

    });
    Stimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, tquee);
    if (Stimer) {
        dispatch_source_set_timer(Stimer, dispatch_walltime(NULL, 0), 2*NSEC_PER_SEC, 100);
        dispatch_source_set_event_handler(Stimer, ^{
            NSLog(@"send:%@", [NSThread currentThread]);
            dispatch_source_merge_data(source, 1);
        });
        dispatch_source_set_cancel_handler(Stimer, ^{
            
        });
        dispatch_resume(Stimer);
    }
      mySource = source;
}

- (void)processSource {
    pid_t pid = getpid();
    dispatch_queue_t quee = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, pid, DISPATCH_PROC_EXIT, quee);
    if (source) {
        dispatch_source_set_event_handler(source, ^{
            NSLog(@"receive process");
        });
        dispatch_source_set_cancel_handler(source, ^{
            
        });
        dispatch_resume(source);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark runloop source
- (void)first {
    therad = [[NSThread alloc] initWithBlock:^{
        NSLog(@"%@ %@", [NSThread currentThread], therad);
        sourc = [[RunLoopSource alloc] init];
        sourc.del = self;
        [sourc addToCurrentRunLoop];
        [[NSRunLoop currentRunLoop] run];
    }];
    [therad start];
}

- (void)wake {
    //唤醒子线程runloop
    [self performSelector:@selector(theradWake) onThread:therad withObject:nil waitUntilDone:NO];
    RunLoopContext *sourceInfor = [sourcesToPing objectAtIndex:0];
    [sourceInfor.source fireAllCommandsOnRunLoop:sourceInfor.runLoop];
    //执行方法
 
}

-(void)theradWake {
    NSLog(@"执行了 当前在%@", [NSThread currentThread]);
}

- (void)first1 {
    dispatch_queue_t t = dispatch_queue_create(nil,DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(t, ^{
        NSLog(@"%@",[NSThread currentThread]);
        RunLoopSource *source = [[RunLoopSource alloc] init];
        source.del = self;
        [source addToCurrentRunLoop];
        runLoop = CFRunLoopGetCurrent();
        [[NSRunLoop currentRunLoop] run];
    });
}
//自定义输入源
- (void)wake1 {
        RunLoopContext *sourceInfor = [sourcesToPing objectAtIndex:0];
        [sourceInfor.source fireAllCommandsOnRunLoop:sourceInfor.runLoop];
}

-(void)theradWake1 {
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)registerSource:(RunLoopContext*)sourceInfo
{
    if (!sourcesToPing) {
        sourcesToPing = [NSMutableArray arrayWithCapacity:0];
    }
    [sourcesToPing addObject:sourceInfo];
}

- (void)removeSource:(RunLoopContext*)sourceInfo
{
    id    objToRemove = nil;
    
    for (RunLoopContext* context in sourcesToPing)
    {
        if ([context isEqual:sourceInfo])
        {
            objToRemove = context;
            break;
        }
    }
    
    if (objToRemove)
        [sourcesToPing removeObject:objToRemove];
}

-(void)testGCD{
    dispatch_queue_t q=dispatch_queue_create("asasasa", DISPATCH_QUEUE_CONCURRENT);
}

-(void)testNSinvocatonOperation{
    NSInvocationOperation* opera=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(op) object:nil];
    NSOperationQueue* quee=[[NSOperationQueue alloc] init];
    quee.maxConcurrentOperationCount=4;
    [quee addOperation:opera];
}
//基于端口的输入源
-(void)lacnchThtead{
    NSPort* myPort=[NSPort port];
    myPort.delegate=self;
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    
    work = [[MyWorkerThread alloc] init];
    therad = [[NSThread alloc] initWithTarget:work selector:@selector(LaunchThreadWithPort:) object:myPort];
    [therad start];
//    [NSThread detachNewThreadSelector:@selector(LaunchThreadWithPort:) toTarget:work withObject:myPort];
}
-(void)handlePortMessage:(NSPortMessage *)message{
     NSLog(@"接收到work子线程的消息%@",[NSThread currentThread]);
 
}

- (void)portWake {
  //  [work sendPortMessage];
      [self performSelector:@selector(theradWake) onThread:therad withObject:nil waitUntilDone:NO];
//    NSMutableArray *array  =[[NSMutableArray alloc]initWithArray:@[@"1",@"2"]];
//    //  NSString* st=@"hello";
//    //发送消息到主线程，操作1
//    NSLog(@"主线程发送端口消息 %@",[NSThread currentThread]);
//    [work.myPort sendBeforeDate:[NSDate date]
//                          msgid:11
//                     components:array
//                           from:work.remotePort
//                       reserved:0];
    
}

//-(void)handleMachMessage:(void *)msg{
//
//    NSLog(@"接收到work子线程的消息...\n");
//
//}
//观察源
- (void)oberv {
    therad = [[NSThread alloc] initWithBlock:^{
        NSLog(@"%@ %@", [NSThread currentThread], therad);
        [self obseverRunloop];
    }];
    [therad start];
}

-(void)obseverRunloop{
    portLoop=[NSRunLoop currentRunLoop];
    [portLoop getCFRunLoop];
     CFRunLoopObserverContext  context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                               kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    
    if(observer)
    {
        // 将Cocoa的NSRunLoop类型转换程Core Foundation的CFRunLoopRef类型
        CFRunLoopRef cfRunLoop = [portLoop getCFRunLoop];
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
        [portLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
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
