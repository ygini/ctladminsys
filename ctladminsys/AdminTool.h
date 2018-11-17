//
//  AdminTool.h
//  ctladminsys
//
//  Created by Yoann Gini on 17/11/2018.
//  Copyright © 2018 Yoann Gini (Open Source Project). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdminTool : NSObject

@property (readonly) int exitStatus;

+ (instancetype)sharedInstance;
- (void)runWithCompletionHandler:(void (^)(void))completionHandler;
- (BOOL)isDone;
@end

NS_ASSUME_NONNULL_END
