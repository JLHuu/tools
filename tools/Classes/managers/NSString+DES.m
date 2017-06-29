//
//  NSString+DES.m
//  tools
//
//  Created by chang on 2017/6/29.
//  Copyright © 2017年 HJL. All rights reserved.
//

#import "NSString+DES.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (DES)
static NSString *defaultKey = @"1234567890";

-(NSString *)DESEncryptWithKey:(NSString *)key
{
    return [[NSString alloc] initWithData:[self DESEncrypt:[[self stringByReplacingSpaces] dataUsingEncoding:NSUTF8StringEncoding] WithKey:key] encoding:NSUTF8StringEncoding];
}
-(NSString *)DESDecryptWithKey:(NSString *)key
{
    return [[NSString alloc] initWithData:[self DESDecrypt:[[self stringByReplacingSpaces] dataUsingEncoding:NSUTF8StringEncoding] WithKey:key] encoding:NSUTF8StringEncoding];}
-(NSString *)DESEncrypt
{
    return [self DESEncryptWithKey:defaultKey];
}
-(NSString *)DESDecrypt
{
    return [self DESDecryptWithKey:defaultKey];
}

- (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

- (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

- (NSString *)stringByReplacingSpaces
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
