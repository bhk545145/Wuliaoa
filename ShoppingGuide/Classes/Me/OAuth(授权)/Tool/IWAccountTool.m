//
//  IWAccountTool.m
//  ItcastWeibo
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWAccount.h"
#import "IWAccountTool.h"

#define IWAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation IWAccountTool
+ (void)saveAccount:(IWAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:IWAccountFile];
}

+ (IWAccount *)account
{
    // 取出账号
    IWAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:IWAccountFile];
    return account;
}

+ (BOOL)deleteFiel{
    BOOL exists = [[self alloc] deleteFiel:IWAccountFile error:nil];
    return exists;
}

- (BOOL)deleteFiel:(NSString *)pathOfFileToDelete error:(NSError *)error{
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:pathOfFileToDelete];
    if (exists) {
        [[NSFileManager defaultManager] removeItemAtPath:pathOfFileToDelete error:nil];
    }
    return exists;
}
@end
