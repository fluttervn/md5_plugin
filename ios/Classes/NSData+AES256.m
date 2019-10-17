//
//  NSData+AES256.m
//  FileString
//
//  Created by An Lam on 4/18/19.
//  Copyright (c) 2019 FlutterVN. All rights reserved.
//

#import "NSData+AES256.h"
#import <CommonCrypto/CommonCryptor.h>
@implementation NSData (AES256)
- (NSData *)AES256EncryptWithKey:(NSString *)key {
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [self length];
	
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	}
    
	free(buffer); //free the buffer;
	return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key {
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [self length];
	
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
	
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
	}
	
	free(buffer); //free the buffer;
	return nil;
}
- (NSString *)stringWithBase64EncodedData
{
    uint8_t* input = (uint8_t*)[self bytes];
	NSInteger length = [self length];
    
	if (!length) {
		return @"";
	}
	
	char* output = malloc(1 + ((length + 2) / 3) * 4);
	char* ptr = output;
	
	for (int i = 0; i < length; i += 3) {
		uint8_t src1, src2, src3;
		
		src1 = input[i];
		src2 = (i + 1 < length) ? input[i + 1] : 0;
		src3 = (i + 2 < length) ? input[i + 2] : 0;
		
		uint8_t dest1, dest2, dest3, dest4;
		
		dest1 = src1 >> 2;
		dest2 = ((src1 & 0x3) << 4) | (src2 >> 4);
		dest3 = ((src2 & 0xF) << 2) | (src3 >> 6);
		dest4 = src3 & 0x3F;
		
		*ptr++ = ByteEncode(dest1);
		*ptr++ = ByteEncode(dest2);
		*ptr++ = (i + 1 < length) ? ByteEncode(dest3) : '=';
		*ptr++ = (i + 2 < length) ? ByteEncode(dest4) : '=';
	}
    
	*ptr++ = 0;
	
	NSString *result = [[NSString alloc] initWithCString:output encoding:NSASCIIStringEncoding];
	free(output);
	
	return result ;
}
static char ByteEncode(uint8_t byte)
{
	if (byte < 26) {
		return 'A' + byte;
	}
	if (byte < 52) {
		return 'a' + (byte - 26);
	}
	if (byte < 62) {
		return '0' + (byte - 52);
	}
	if (byte == 62) {
		return '+';
	}
	
	return '/';
}
-(NSString *)MD5{
//    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
//    if (!handle) return nil;
//    
//    unsigned int length = 32 * 1024;
//    NSMutableData *result = [NSMutableData dataWithLength:CC_MD5_DIGEST_LENGTH];
//    CC_MD5_CTX context;
//    CC_MD5_Init(&context);
//    BOOL done = NO;
//    while (!done) {
//        @autoreleasepool {
//            NSData* fileData = [handle readDataOfLength:length];
//            CC_MD5_Update(&context, [fileData bytes], (unsigned int)[fileData length]);
//            if( [fileData length] == 0 ) done = YES;
//        }
//    }
//    CC_MD5_Final([result mutableBytes], &context);
//    [handle closeFile];
//    NSData *data=[NSData dataWithData:result];
//    return [data stringWithBase64EncodedData];
    // Create byte array of unsigned chars
    NSMutableData *result = [NSMutableData dataWithLength:CC_MD5_DIGEST_LENGTH];
    CC_MD5_CTX context;
    CC_MD5_Init(&context);
    CC_MD5_Update(&context, [self bytes], (unsigned int)[self length]);
    CC_MD5_Final([result mutableBytes], &context);
    NSData *data=[NSData dataWithData:result];
    return [data stringWithBase64EncodedData];
//    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
//    
//    // Create 16 byte MD5 hash value, store in buffer
//    CC_MD5(self.bytes, self.length, md5Buffer);
//    
//    // Convert unsigned char buffer to NSString of hex values
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x",md5Buffer[i]];
//    NSData *data=[output dataUsingEncoding:NSUTF8StringEncoding];
//    return [data stringWithBase64EncodedData];
}
@end
