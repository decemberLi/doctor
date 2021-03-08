//
//  OCRManager.m
//  Runner
//
//  Created by tristan on 2021/3/2.
//

#import "OCRManager.h"
#import <OcrSDKKit/OcrSDKKit.h>
#import <OcrSDKKit/OcrSDKConfig.h>

static NSString* const SECRET_ID     = @"AKIDKSP1OXP1ytJTNWQ9tOfhUflmrgJgGIjw"; // SECRET_ID 信息
static NSString* const SECRET_KEY    = @"BLFuJeIXIwHVsqjBOt4Cm7B9VihQt6SZ"; // SECRET_KEY 信息

@interface OCRManager ()
{
    OcrSDKKit *ocrSDKKit;
}
@end

@implementation OCRManager : NSObject
+(instancetype)shared{
    static OCRManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[OCRManager alloc] init];
    });
    return shared;
}

- (void)initSDK {
    /*！
     * OCR 配置类：
     * ocrModeType: 检测类型 OCR_DETECT_MANUAL 手动拍摄； OCR_DETECT_AUTO_MANUAL 自动识别卡片
     */
    OcrSDKConfig *ocrSDKConfig = [[OcrSDKConfig alloc] init];
    ocrSDKConfig.ocrModeType = OCR_DETECT_AUTO_MANUAL;
    ocrSDKConfig.copyWarn = YES;
    ocrSDKConfig.quality = YES;
    ocrSDKKit = [OcrSDKKit sharedInstance];
    /// SDKKIt 加载 OCR 配置信息
    /// @param secretId  Secret id
    /// @param secretKey Secret key
    /// @param ocrConfig ocr 配置类
    [ocrSDKKit loadSDKConfigWithSecretId:SECRET_ID withSecretKey:SECRET_KEY withConfig:ocrSDKConfig];
}

- (void) startProcessOcrFRONT:(void(^)(NSString *result))finish {

    CustomConfigUI *ocrUIConfig = [[CustomConfigUI alloc] init];
    ocrUIConfig.remindConfirmColor = [UIColor blueColor];
    ocrUIConfig.isShowAlbumBtn = true;
    [ocrSDKKit startProcessOcr:IDCardOCR_FRONT withSDKUIConfig:ocrUIConfig withProcessSucceedBlock:^(id  _Nonnull resultInfo, UIImage *resultImage, id  _Nonnull reserved) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/front.png",NSHomeDirectory()];
        NSData *data = UIImagePNGRepresentation(resultImage);
        [data writeToFile:path atomically:true];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultInfo];
        dic[@"imgPath"] = path;
        NSData *obj = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingFragmentsAllowed error:nil];
        NSString *string = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
        if (finish) {
            finish(string);
        }
    } withProcessFailedBlock:^(NSError * _Nonnull error, id  _Nullable reserved) {
//        [self showAlert:error.domain withMessage:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

- (void) startProcessOcrBack:(void(^)(NSString * result))finish  {
    CustomConfigUI *ocrUIConfig = [[CustomConfigUI alloc] init];
    ocrUIConfig.remindConfirmColor = [UIColor blueColor];
    ocrUIConfig.isShowAlbumBtn = true;
    [ocrSDKKit startProcessOcr:IDCardOCR_BACK  withSDKUIConfig:ocrUIConfig withProcessSucceedBlock:^(id  _Nonnull resultInfo, UIImage *resultImage, id  _Nonnull reserved) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/front.png",NSHomeDirectory()];
        NSData *data = UIImagePNGRepresentation(resultImage);
        [data writeToFile:path atomically:true];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultInfo];
        dic[@"imgPath"] = path;
        NSData *obj = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingFragmentsAllowed error:nil];
        NSString *string = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
        if (finish) {
            finish(string);
        }
    } withProcessFailedBlock:^(NSError * _Nonnull error, id  _Nullable reserved) {
//        [self showAlert:error.domain withMessage:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

- (void) startBankCardOcrProcess:(void(^)(NSString *result))finish {
    CustomConfigUI *ocrSDKUIConfig = [[CustomConfigUI alloc] init];
    ocrSDKUIConfig.isShowTips = YES;
    ocrSDKUIConfig.remindConfirmColor = [UIColor magentaColor];
    [ocrSDKKit startProcessOcr:BankCardOCR withSDKUIConfig:ocrSDKUIConfig withProcessSucceedBlock:^(id  _Nonnull resultInfo, UIImage *resultImage, id  _Nonnull reserved) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/front.png",NSHomeDirectory()];
        NSData *data = UIImagePNGRepresentation(resultImage);
        [data writeToFile:path atomically:true];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultInfo];
        dic[@"imgPath"] = path;
        NSData *obj = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingFragmentsAllowed error:nil];
        NSString *string = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
        if (finish) {
            finish(string);
        }
    } withProcessFailedBlock:^(NSError * _Nonnull error, id  _Nullable reserved) {
        NSLog(@"requestId:%@",reserved);
//        [self showAlert:error.domain withMessage:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

@end
