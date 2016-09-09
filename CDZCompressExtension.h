//
//  CDZCompressExtension.h
//
//
//  Created by baight on 16/7/14.
//  Copyright (c) 2013 baight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CDZCompressExtension)

- (NSData*)compressWithGzip;
- (NSData*)decompressWithGzip;

@end


// 303730915@qq.com
