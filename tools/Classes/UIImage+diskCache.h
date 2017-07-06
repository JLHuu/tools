//
//  UIImage+diskCache.h
//  tools
//
//  Created by chang on 2017/6/30.
//  Copyright © 2017年 HJL. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 图片缓存文件缓存
 */
@interface UIImage (diskCache)
NS_ASSUME_NONNULL_BEGIN
- (void)jl_storeImageWithFileName:(NSString *)fileName path:(NSString *)path;
- (void)jl_storeImageWithFileName:(NSString *)fileName;
NS_ASSUME_NONNULL_END
@end
