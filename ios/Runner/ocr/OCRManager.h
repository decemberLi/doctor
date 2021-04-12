//
//  OCRManager.h
//  Runner
//
//  Created by tristan on 2021/3/2.
//
#import <UIKit/UIKit.h>

@interface OCRManager : NSObject
+(instancetype)shared;
- (void) startProcessOcrFRONT:(void(^)(NSString *result))finish ;
- (void) startProcessOcrBack:(void(^)(NSString *result))finish ;
- (void) startBankCardOcrProcess:(void(^)(NSString *result))finish ;
- (void)initSDK;
@end
