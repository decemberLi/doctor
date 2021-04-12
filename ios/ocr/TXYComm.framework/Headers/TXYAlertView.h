//
//  TXYCustomerDialog.h
//  HuiYanSDKDemo
//
//  Created by v_clvchen on 2020/10/10.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);
//TXYAlertView
@interface TXYAlertView : UIView
//resultIndex 
@property (nonatomic,copy) AlertResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

- (void)showXLAlertView;

@end
