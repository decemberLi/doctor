//
//  ServerAPIManager.H
//  HuiYanSDK
//
//  Created by v_clvchen on 2020/9/23.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 ServerAPIManager 工具类
 */
@interface ServerAPIManager : NSObject

+ (void) get:(NSString *)domain
         url:(NSString *)urlStr
      params:(NSDictionary *)paramsDict
      header:(NSDictionary *)header
     topView:(UIView *)topView
     success:(void (^)(id response))success
     failure:(void (^)(NSError *err))failure;

+ (void) post:(NSString *)domain
          url:(NSString *)urlStr
       params:(NSDictionary *)paramsDict
       header:(NSDictionary *)header
    bodyParams:(id)bodyParams
      topView:(UIView *)topView
      success:(void (^)(id response))success
      failure:(void (^)(NSError *err))failure;

 @end
