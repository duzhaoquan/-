//
//  AppCache.m
//  生日快乐
//
//  Created by jp123 on 2017/3/27.
//  Copyright © 2017年 jp. All rights reserved.
//

#import "AppCache.h"

@implementation AppCache

static AppCache *appcache;

//单利
+(instancetype)sharInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appcache=[[AppCache alloc]init];
        
    });
    return appcache;
}

#pragma mark -保存123456
//用户信息
+(void)saveUserInfoWithdic:(NSDictionary*)dic{
    //取出沙盒路径
    NSArray *homePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDeirectory =[homePath objectAtIndex:0];
    NSString *cachePath = [cacheDeirectory stringByAppendingPathComponent:@"AppUserInfor"];
    
    //判断有没有该目录,如果没有则创建
    BOOL isDeir = NO;
    NSFileManager *fileManaager =[NSFileManager defaultManager];
    BOOL existed = [fileManaager fileExistsAtPath:cachePath isDirectory:&isDeir];
    
    if (!(existed && isDeir)) {
        [fileManaager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //对象归档保存用户信息
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSString *dicpach = [cachePath stringByAppendingPathComponent:@"userInfor"];
    [data writeToFile:dicpach atomically:YES];
    
}

#pragma mark -取出用户信息
+(NSDictionary*)getUserInfor{
    NSArray *homePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDeirectory = [homePath objectAtIndex:0];
    NSString *cachePath = [cacheDeirectory stringByAppendingPathComponent:@"AppUserInfor"];
    NSString *userpath = [cachePath stringByAppendingPathComponent:@"userInfor"];
    
    NSData *data = [NSData dataWithContentsOfFile:userpath];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return dic;
    
}

//沙盒路径缓存路径
+(NSString*)cacheDeirectory{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask , YES);
    NSString *cacheDeirectory = [path objectAtIndex:0];
    NSString *cachePath = [cacheDeirectory stringByAppendingPathComponent:@"AppCache"];
    
    BOOL isDeir = NO;
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    BOOL existed = [fileManger fileExistsAtPath:cachePath isDirectory:&isDeir];
    
    if (!(isDeir == YES && existed ==YES)) {
        [fileManger createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return cachePath;
}
//清除缓存
+(void)clearChache{
    NSArray*cacheItem = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[AppCache cacheDeirectory] error:nil];
    for (NSString *path in cacheItem) {
        [[NSFileManager defaultManager] removeItemAtPath:[[AppCache cacheDeirectory] stringByAppendingPathComponent:path]  error:nil];
    }
}
//创建新的缓存文件路径
+(NSString*)fullPathOfFilename:(NSString*)filename{
   return  [[AppCache cacheDeirectory] stringByAppendingPathComponent:filename];
}
//对象归档缓存data
+(void)cacheData:(NSData*)data Filename:(NSString*)filename{
    [data writeToFile:[AppCache fullPathOfFilename:filename] atomically:YES];
}
//对象归档取出data
+(NSData*)getCacheDataFromFile:(NSString*)filename{
    return [NSData dataWithContentsOfFile:[AppCache fullPathOfFilename:filename]];
}
//对象归档缓存数组
+(void)cacheArray:(NSArray*)items toFilename:(NSString*)filename{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:items];
    [self cacheData:data Filename:filename];
}
//对象归档取出数组
+(NSArray*)getcacheArrayfromFilename:(NSString*)filename{
    return  [NSKeyedUnarchiver unarchiveObjectWithData:[self getCacheDataFromFile:filename]];
    
    
}
//对象归档缓存字典
+(void)cacheDictionary:(NSDictionary*)dic toFilename:(NSString*)filename{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:dic];
    [self cacheData:data Filename:filename];
}
//对象归档取出数组
+(NSDictionary*)getcacheDictionaryFromFilename:(NSString*)filename{
    return  [NSKeyedUnarchiver unarchiveObjectWithData:[self getCacheDataFromFile:filename]];
    
    
}

@end
