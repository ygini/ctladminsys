//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <Foundation/Foundation.h>

@interface ADMSysKeyChainConfig : NSObject
{
}

+ (id)sharedSysKeyChainConfig;
- (void)setKeyForDomain:(id)arg1;
- (BOOL)setODSDPassword:(id)arg1 accountName:(id)arg2;
- (void)setRestrictAppInstallations:(unsigned long long)arg1;
- (void)setRestrictAppInstallations:(BOOL)arg1 allowCaspianIdentifiedApps:(BOOL)arg2;
- (int)storeKeyInSystemKeychain:(id)arg1 forUser:(id)arg2 serverURL:(id)arg3 description:(id)arg4;
- (BOOL)storeSystemKeychainPassword:(id)arg1 account:(id)arg2 service:(id)arg3;

@end

