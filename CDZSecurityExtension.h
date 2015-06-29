//
//  CDZSecurityExtension.h
//
//
//  Created by baight on 15/6/11.
//  Copyright (c) 2013 baight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CDZSecurityExtension)

// Base64
+ (NSData*)dataFromBase64String:(NSString*)str;
- (NSString*)base64EncodedString;

// DES
- (NSData *)DESEncryptWithKey:(NSString *)key;
- (NSData *)DESDecryptWithKey:(NSString *)key;

// AES
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end


// 303730915@qq.com
