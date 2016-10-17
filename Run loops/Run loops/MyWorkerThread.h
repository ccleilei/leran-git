//
//  MyWorkerThread.h
//  Run loops
//
//  Created by 晓磊 on 16/9/7.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWorkerThread : NSObject<NSMachPortDelegate> {
    NSPort *remotePort;
    NSPort *myPort;
}
@end
