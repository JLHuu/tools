//
//  UIImage+Handle.h
//  cuteDituhui
//
//  Created by chang on 2017/6/7.
//  Copyright © 2017年 SuperMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Handle)

/**
 通过颜色获取一张纯色图

 @param color 颜色
 @return 纯色图
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 画一个删除的图片

 @param color 颜色
 @param size 尺寸
 @param width 线宽
 @return 删除图
 */
+ (UIImage *)createDeleteImageWithColor:(UIColor *)color Size:(CGSize)size andLinewidth:(CGFloat)width;

/**
 获取灰色图片
 
 @param img 原图
 @return 灰色图
 */
+ (UIImage *)getGaryImage:(UIImage *)img;

/**
 创建一张箭头图片

 @param color 颜色
 @param size 尺寸
 @param width 线宽
 @param diretion 方向 1↑，2↓，3←，4→
 @return 图片
 */
+ (UIImage *)createArrowImageWithColor:(UIColor *)color size:(CGSize)size lineWidth:(CGFloat)width andDirection:(NSUInteger)diretion;

/**
 设置图片新的size

 @param size 新的size
 @return 新图
 */
- (UIImage *)imageWithNewSize:(CGSize)size;

/**
  比例缩放

 @param scale 比例
 @return 比例图
 */
- (UIImage *)imageToscale:(CGFloat)scale;

/**
 颜色反转

 @param complition 反转色图片
 */
- (void)reverseImagecomplite:(void(^)(UIImage *reverseimage))complition;
/**
 图片马赛克处理

 @param area 区域
 @param level 一个马赛克点大小
 @param complition 回调
 */
- (void)mosaicImageWithArea:(CGRect)area level:(NSUInteger)level complite:(void(^)(UIImage *mosimg))complition;
@end