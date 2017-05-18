//
//  AppCache.h
//  生日快乐
//
//  Created by jp123 on 2017/3/27.
//  Copyright © 2017年 jp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCache : NSObject

#pragma mark -保存用户信息
+(void)saveUserInfoWithdic:(NSDictionary*)dic;

#pragma mark -取出用户信息
+(NSDictionary*)getUserInfor;
#pragma mark -清除缓存
+(void)clearChache;

#pragma mark -对象归档缓存数组
+(void)cacheArray:(NSArray*)items toFilename:(NSString*)filename;
#pragma mark -对象归档取出数组
+(NSArray*)getcacheArrayfromFilename:(NSString*)filename;
#pragma mark -对象归档缓存字典
+(void)cacheDictionary:(NSDictionary*)dic toFilename:(NSString*)filename;
#pragma mark -对象归档取出数组
+(NSDictionary*)getcacheDictionaryFromFilename:(NSString*)filename;




@end
