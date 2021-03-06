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
+ (NSData*)dataFromBase64String:(NSString*)str NS_AVAILABLE(10_9, 7_0);
- (NSString*)base64EncodedString NS_AVAILABLE(10_9, 7_0);

- (NSString*)md5String;
- (NSString*)hmacSHA1StringWithSecret:(NSString*)secret;
- (NSString*)hmacSHA256StringWithSecret:(NSString*)secret;

// DES
- (NSData *)DESEncryptWithKey:(NSString *)key;
- (NSData *)DESDecryptWithKey:(NSString *)key;

// AES
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end



@interface NSString (CDZSecurityExtension)

- (NSString*)md5StringWithUTF8Encoding;

@end


// 303730915@qq.com
