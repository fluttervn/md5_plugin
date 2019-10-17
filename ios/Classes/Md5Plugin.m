#import "Md5Plugin.h"
#import "NSData+AES256.h"

@implementation Md5Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"md5_plugin"
            binaryMessenger:[registrar messenger]];
  Md5Plugin* instance = [[Md5Plugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getMD5" isEqualToString:call.method]) {
    NSString *path = call.arguments[@"file_path"];
          result([self fileMD5WithPath: path]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

-(NSString *)fileMD5WithPath:(NSString*)path {

    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!handle) return nil;
    unsigned int length = 32 * 1024;
    NSMutableData *result = [NSMutableData dataWithLength:CC_MD5_DIGEST_LENGTH];
    CC_MD5_CTX context;
    CC_MD5_Init(&context);
    BOOL done = NO;
    while (!done) {
        @autoreleasepool {
            NSData* fileData = [handle readDataOfLength:length];
            CC_MD5_Update(&context, [fileData bytes], (unsigned int)[fileData length]);
            if( [fileData length] == 0 ) done = YES;
        }
    }
    CC_MD5_Final([result mutableBytes], &context);
    [handle closeFile];
    NSData *data=[NSData dataWithData:result];
    return [data stringWithBase64EncodedData];
}

@end
