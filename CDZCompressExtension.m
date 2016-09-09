//
//  CDZCompressExtension.m
//  
//
//  Created by baight on 16/7/14.
//  Copyright (c) 2013 baight. All rights reserved.
//

#import "CDZCompressExtension.h"
#import <zlib.h>


@implementation NSData (CDZCompressExtension)

// 代码来自 http://blog.csdn.net/workhardupc100/article/details/7601916
- (NSData*)compressWithGzip{
    /*
     Special thanks to Robbie Hanson of Deusty Designs for sharing sample code
     showing how deflateInit2() can be used to make zlib generate a compressed
     file with gzip headers:
     http://deusty.blogspot.com/2007/07/gzip-compressiondecompression.html
     */
    
    if ([self length ] == 0 )  {
        return nil;
    }

    /* Before we can begin compressing (aka "deflating") data using the zlib
     functions, we must initialize zlib. Normally this is done by calling the
     deflateInit() function; in this case, however, we'll use deflateInit2() so
     that the compressed data will have gzip headers. This will make it easy to
     decompress the data later using a tool like gunzip, WinZip, etc.

     deflateInit2() accepts many parameters, the first of which is a C struct of
     type "z_stream" defined in zlib.h. The properties of this struct are used to
     control how the compression algorithms work. z_stream is also used to
     maintain pointers to the "input" and "output" byte buffers (next_in/out) as
     well as information about how many bytes have been processed, how many are
     left to process, etc. */
    
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc     = Z_NULL ; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree      = Z_NULL ; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque     = Z_NULL ; // updated to use default allocation functions.
    zlibStreamStruct.total_out  = 0 ; // Total number of output bytes produced so far
    zlibStreamStruct.next_in    = (Bytef *)[self bytes ]; // Pointer to input bytes
    zlibStreamStruct.avail_in   = (uInt)[self length]; // Number of input bytes left to process
    
    /* Initialize the zlib deflation (i.e. compression) internals with deflateInit2().
     The parameters are as follows:

     z_streamp strm - Pointer to a zstream struct
     int level      - Compression level. Must be Z_DEFAULT_COMPRESSION, or between
     0 and 9: 1 gives best speed, 9 gives best compression, 0 gives
     no compression.
     int method     - Compression method. Only method supported is "Z_DEFLATED".
     int windowBits - Base two logarithm of the maximum window size (the size of
     the history buffer). It should be in the range 8..15. Add
     16 to windowBits to write a simple gzip header and trailer
     around the compressed data instead of a zlib wrapper. The
     gzip header will have no file name, no extra data, no comment,
     no modification time (set to zero), no header crc, and the
     operating system will be set to 255 (unknown).
     int memLevel   - Amount of memory allocated for internal compression state.
     1 uses minimum memory but is slow and reduces compression
     ratio; 9 uses maximum memory for optimal speed. Default value
     is 8.
     int strategy   - Used to tune the compression algorithm. Use the value
     Z_DEFAULT_STRATEGY for normal data, Z_FILTERED for data
     produced by a filter (or predictor), or Z_HUFFMAN_ONLY to
     force Huffman encoding only (no string match) */
    
    int initError = deflateInit2 (&zlibStreamStruct, Z_DEFAULT_COMPRESSION , Z_DEFLATED , (15 + 16), 8 , Z_DEFAULT_STRATEGY );
    if (initError != Z_OK ) {
        return nil ;
    }

    // Create output memory buffer for compressed data. The zlib documentation states that
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    NSMutableData *compressedData = [NSMutableData dataWithLength:[self length]*1.01 + 12];
    int deflateStatus;
    do {
        // Store location where next byte should be put in next_out
        zlibStreamStruct.next_out = [compressedData mutableBytes ] + zlibStreamStruct. total_out ;
        
        // Calculate the amount of remaining free space in the output buffer
        // by subtracting the number of bytes that have been written so far
        // from the buffer's total capacity
        zlibStreamStruct.avail_out = (uInt)([compressedData length] - zlibStreamStruct.total_out);

        /* deflate() compresses as much data as possible, and stops/returns when
         the input buffer becomes empty or the output buffer becomes full. If
         deflate() returns Z_OK, it means that there are more bytes left to
         compress in the input buffer but the output buffer is full; the output
         buffer should be expanded and deflate should be called again (i.e., the
         loop should continue to rune). If deflate() returns Z_STREAM_END, the
         end of the input stream was reached (i.e.g, all of the data has been
         compressed) and the loop should stop. */
        deflateStatus = deflate (&zlibStreamStruct, Z_FINISH );
    }
    while (deflateStatus == Z_OK );
    
    // Free data structures that were dynamically created for the stream.
    deflateEnd (&zlibStreamStruct);
    
    // Check for zlib error and convert code to usable error message if appropriate
    if (deflateStatus != Z_STREAM_END ) {
        return nil;
    }

    [compressedData setLength : zlibStreamStruct.total_out ];
    return compressedData;
}

- (NSData*)decompressWithGzip{
    z_stream zStream;
    zStream.zalloc = Z_NULL ;
    zStream.zfree = Z_NULL ;
    zStream.opaque = Z_NULL ;
    zStream. avail_in = 0 ;
    zStream. next_in = 0 ;
    
    int status = inflateInit2 (&zStream, (15 + 32));
    if (status != Z_OK ) {
        return nil ;
    }
    
    Bytef *bytes = (Bytef*)[self bytes];
    NSUInteger length = [self length];
    NSUInteger halfLength = length/ 2 ;
    NSMutableData *uncompressedData = [NSMutableData dataWithLength:length+halfLength];
    
    zStream.next_in = bytes;
    zStream.avail_in = (unsigned int)length;
    zStream.avail_out = 0 ;
    
    NSInteger bytesProcessedAlready = zStream.total_out ;
    while (zStream.avail_in != 0 ) {
        if (zStream.total_out - bytesProcessedAlready >= [uncompressedData length ]) {
            [uncompressedData increaseLengthBy :halfLength];
        }
        
        zStream.next_out = (Bytef *)[uncompressedData mutableBytes ] + zStream. total_out -bytesProcessedAlready;
        zStream.avail_out = (unsigned int)([uncompressedData length ] - (zStream. total_out -bytesProcessedAlready));
        
        status = inflate (&zStream, Z_NO_FLUSH );
        if (status == Z_STREAM_END ) {
            break;
        }
        else if (status != Z_OK ) {
            return nil ;
        }
    }
    
    status = inflateEnd (&zStream);
    if (status != Z_OK ) {
        return nil;
    }
    
    [uncompressedData setLength: zStream.total_out - bytesProcessedAlready];  // Set real length
    return uncompressedData;
}

@end


// 303730915@qq.com
