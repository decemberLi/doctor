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

- (void)initSDK {
    /*！
     * OCR 配置类：
     * ocrModeType: 检测类型 OCR_DETECT_MANUAL 手动拍摄； OCR_DETECT_AUTO_MANUAL 自动识别卡片
     */
    OcrSDKConfig *ocrSDKConfig = [[OcrSDKConfig alloc] init];
    ocrSDKConfig.ocrModeType = OCR_DETECT_AUTO_MANUAL;
    ocrSDKKit = [OcrSDKKit sharedInstance];
    /// SDKKIt 加载 OCR 配置信息
    /// @param secretId  Secret id
    /// @param secretKey Secret key
    /// @param ocrConfig ocr 配置类
    [ocrSDKKit loadSDKConfigWithSecretId:SECRET_ID withSecretKey:SECRET_KEY withConfig:ocrSDKConfig];
}

- (void)show{
    
}

- (void) startProcessOcrFRONT {

    CustomConfigUI *ocrUIConfig = [[CustomConfigUI alloc] init];
    ocrUIConfig.remindConfirmColor = [UIColor blueColor];
    ocrUIConfig.isShowAlbumBtn = NO;
    [ocrSDKKit startProcessOcr:IDCardOCR_FRONT withSDKUIConfig:ocrUIConfig withProcessSucceedBlock:^(id  _Nonnull resultInfo, UIImage *resultImage, id  _Nonnull reserved) {
//        [self->resultImageArr replaceObjectAtIndex:0 withObject:resultImage];
//        NSMutableArray *afterArr = [NSMutableArray array];
//        NSDictionary *item0Dict = self->dataArr[0];
//        NSDictionary *item1Dict = self->dataArr[1];
//        NSMutableDictionary *mutableItem = [NSMutableDictionary dictionaryWithDictionary:item0Dict];
//        [mutableItem setObject:[NSNumber numberWithInt:1] forKey:@"idCardState"];
//        [afterArr addObject:mutableItem];
//        [afterArr addObject:item1Dict];
//        self->dataArr = afterArr;
//        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//        [self->_idCardTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//
//        self->frontDict = resultInfo;
//        [self addShowContentView];
    } withProcessFailedBlock:^(NSError * _Nonnull error, id  _Nullable reserved) {
//        [self showAlert:error.domain withMessage:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

- (void) startProcessOcrBack {
    [ocrSDKKit startProcessOcr:IDCardOCR_BACK  withSDKUIConfig:nil withProcessSucceedBlock:^(id  _Nonnull resultInfo, UIImage *resultImage, id  _Nonnull reserved) {
//        [self->resultImageArr replaceObjectAtIndex:1 withObject:resultImage];
//
//        NSMutableArray *afterArr = [NSMutableArray array];
//        NSDictionary *item0Dict = self->dataArr[0];
//        NSDictionary *item1Dict = self->dataArr[1];
//        NSMutableDictionary *mutableItem = [NSMutableDictionary dictionaryWithDictionary:item1Dict];
//        [mutableItem setObject:[NSNumber numberWithInt:1] forKey:@"idCardState"];
//        [afterArr addObject:item0Dict];
//        [afterArr addObject:mutableItem];
//        self->dataArr = afterArr;
//        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//        [self->_idCardTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//
//        self->backDict = resultInfo;
//        [self addShowContentView];
    } withProcessFailedBlock:^(NSError * _Nonnull error, id  _Nullable reserved) {
//        [self showAlert:error.domain withMessage:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

- (void) startBankCardOcrProcess{
    CustomConfigUI *ocrSDKUIConfig = [[CustomConfigUI alloc] init];
    ocrSDKUIConfig.isShowTips = YES;
    ocrSDKUIConfig.remindConfirmColor = [UIColor magentaColor];
    [ocrSDKKit startProcessOcr:BankCardOCR withSDKUIConfig:ocrSDKUIConfig withProcessSucceedBlock:^(id  _Nonnull resultInfo, UIImage *resultImage, id  _Nonnull reserved) {
//        ResultViewController *resultViewController = [[ResultViewController alloc] initWithNibName:NSStringFromClass([ResultViewController class]) bundle:nil];
//        resultViewController.cardType = @"BankCard";
//        resultViewController.resultImage = resultImage;
//        resultViewController.resultDict = resultInfo;
//
//        [self.navigationController pushViewController:resultViewController animated:YES];
    } withProcessFailedBlock:^(NSError * _Nonnull error, id  _Nullable reserved) {
        NSLog(@"requestId:%@",reserved);
//        [self showAlert:error.domain withMessage:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

@end
