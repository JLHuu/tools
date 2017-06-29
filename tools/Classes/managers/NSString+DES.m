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

-(NSString *)DESEncrypt
{
    return [self DESEncryptWithKey:defaultKey];
}

-(NSString *)DESDecrypt
{
    return [self DESDecryptWithKey:defaultKey];
}
-(NSString *)DESEncryptWithKey:(NSString *)key
{
    return [NSString stringByReplacingSpacesAndBracketsFromData:[NSString DESEncrypt:[self dataUsingEncoding:NSUTF8StringEncoding] WithKey:key]];

}
-(NSString *)DESDecryptWithKey:(NSString *)key
{
    NSData *data = [NSString dataConvertFromDataString:self];
    
    NSData *dataDecrpt = [NSString DESDecrypt:data WithKey:key];
    
    return [[NSString alloc] initWithData:dataDecrpt encoding:NSUTF8StringEncoding];
}
//+(NSString *)DESDecrypt:(NSString *)dataString key:(NSString *)key
//{
//    NSData *data = [self dataConvertFromDataString:dataString];
//    
//    NSData *dataDecrpt = [self DESDecrypt:data WithKey:key];
//    
//    return [[NSString alloc] initWithData:dataDecrpt encoding:NSUTF8StringEncoding];
//}
//
//+(NSString *)DESEncrypt:(NSString *)string key:(NSString *)key
//{
//    return [self stringByReplacingSpacesAndBracketsFromData:[self DESEncrypt:[string dataUsingEncoding:NSUTF8StringEncoding] WithKey:key]];
//}
//
//+ (NSString *)DESEncrypt:(NSString *)string
//{
//    return [self DESEncrypt:string key:defaultKey];
//}
//
//+ (NSString *)DESDecrypt:(NSString *)dataString
//{
//    return [self DESDecrypt:dataString key:defaultKey];
//}

+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
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

+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
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

+ (NSData *)dataConvertFromDataString:(NSString *)hexString
{
    if (!hexString) {
        return [NSData data];
    }
    int j=0;
    NSUInteger length = [hexString length] / 2;
    Byte bytes[length];
    
    for(int i=0; i<[hexString length]; i++)
    {
        // 两位16进制数转化后的10进制数
        int int_ch;
        
        // 两位16进制数中的第一位(高位*16)
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   // 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; // A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; // a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; //两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); // 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; // A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; // a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  //将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:length];
    
    return newData;
}

+ (NSString *)stringByReplacingSpacesAndBracketsFromData:(NSData *)data
{
    if (!data) {
        return @"";
    }
    
    NSString *str = [data description];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return str;
}

@end
