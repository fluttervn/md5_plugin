//
//  NSData+AES256.h
//  FileString
//
//  Created by An Lam on 10/17/19.
//  Copyright (c) 2019 FlutterVN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSData (AES256)
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;
- (NSString *)stringWithBase64EncodedData;
-(NSString*)MD5;
@end
