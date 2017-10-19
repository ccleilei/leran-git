//
//  MyWorkerThread.h
//  Run loops
//
//  Created by 晓磊 on 16/9/7.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWorkerThread : NSObject<NSPortDelegate> 
@property (nonatomic, strong)  NSPort *remotePort;
@property (nonatomic, strong)  NSPort *myPort;
-(void)sendPortMessage;
@end
