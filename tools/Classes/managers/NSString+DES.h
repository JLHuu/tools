//
//  NSString+DES.h
//  tools
//
//  Created by chang on 2017/6/29.
//  Copyright © 2017年 HJL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DES)
NS_ASSUME_NONNULL_BEGIN
/**加密*/
- (NSString *)DESEncrypt;
/**解密*/
- (NSString *)DESDecrypt;

/**
 加密
 
 @param key 加密用key
 @return 加密后string
 */
- (NSString *)DESEncryptWithKey:(NSString *)key;
/**
 解密
 
 @param key 解密用key
 @return 解密后string
 */
- (NSString *)DESDecryptWithKey:(NSString *)key;
NS_ASSUME_NONNULL_END
@end
