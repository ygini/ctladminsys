//
//  AdminTool.m
//  ctladminsys
//
//  Created by Yoann Gini on 17/11/2018.
//  Copyright © 2018 Yoann Gini (Open Source Project). All rights reserved.
//

#import "AdminTool.h"
#import "ADMUser.h"
#import "ADMDSNode.h"
#import "Constants.h"

@interface AdminTool ()
@property int exitStatus;
@end

@implementation AdminTool

+ (instancetype)sharedInstance {
    static AdminTool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _exitStatus = -1;
    }
    return self;
}

- (void)runWithCompletionHandler:(void (^)(void))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self run];
        completionHandler();
    });
}

- (NSDictionary*)loadSettings {
    NSFileHandle *inputFile = [NSFileHandle fileHandleWithStandardInput];
    NSMutableData *inputData = [NSMutableData new];
    NSData *data = nil;
    do {
        data = [inputFile availableData];
        [inputData appendData:data];
    } while ([data length] > 0);
    
    NSError *error = nil;
    id object = [NSPropertyListSerialization propertyListWithData:inputData options:0 format:nil error:&error];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    } else {
        return nil;
    }
}

- (void)run {
    
    NSDictionary *settings = [self loadSettings];
    
    NSString *username = [settings objectForKey:kUserName];
    if ([username length] == 0) { self.exitStatus = 1; return; }
    
    NSString *userPassword = [settings objectForKey:kUserPassword];
    if ([userPassword length] == 0) { self.exitStatus = 2; return; }
    
    NSString *adminName = [settings objectForKey:kAdminName];
    if ([adminName length] == 0) { self.exitStatus = 3; return; }
    
    NSString *adminPassword = [settings objectForKey:kAdminPassword];
    if ([adminPassword length] == 0) { self.exitStatus = 4; return; }
    
    NSNumber *requestedStatusNumber = [settings objectForKey:kRequestedStatus];
    if (!requestedStatusNumber) { self.exitStatus = 5; return; }
    BOOL requestedStatus = [requestedStatusNumber boolValue];
    
    ADMUser *targetUser = [ADMUser findUserByName:username searchParent:NO];
    if (!targetUser) {
        NSLog(@"User %@ not found", username);
        self.exitStatus = 6;
        return;
    }
    
    ADMDSNode *targetUserNode = [targetUser node];
    int status = [targetUserNode authenticateName:adminName withPassword:adminPassword];
    if (status != 0) {
        NSLog(@"Unable to authenticate with admin creds");
        self.exitStatus = status;
        return;
    }
    
    id result = [targetUser setSecureTokenAuthorizationEnabled:requestedStatus userPassword:userPassword];
    if (result) {
        NSLog(@"%@", result);
        self.exitStatus = 7;
        return;
    }
    self.exitStatus = 0;
}

- (BOOL)isDone {
    return self.exitStatus != -1;
}

@end
