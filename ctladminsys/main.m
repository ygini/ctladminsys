//
//  main.m
//  ctladminsys
//
//  Created by Yoann Gini on 17/11/2018.
//  Copyright © 2018 Yoann Gini (Open Source Project). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdminTool.h"


int main(int argc, const char * argv[]) {
    NSLock *lock = [NSLock new];
    AdminTool *adminTool = [AdminTool sharedInstance];
    @autoreleasepool {
        [lock lock];
        [adminTool runWithCompletionHandler:^{
            [lock unlock];
        }];
        [lock lock];
    }
    return [adminTool exitStatus];
}
