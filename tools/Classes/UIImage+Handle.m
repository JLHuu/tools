//
//  UIImage+Handle.m
//  cuteDituhui
//
//  Created by chang on 2017/6/7.
//  Copyright © 2017年 SuperMap. All rights reserved.
//

#import "UIImage+Handle.h"

@implementation UIImage (Handle)
+(UIImage *)createImageWithColor:(UIColor *)color
{
    if (!color) {
        color = [UIColor clearColor];
    }
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, 1, 1));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+(UIImage *)screenShotsWithView:(UIView *)view
{
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+(UIImage *)createDeleteImageWithColor:(UIColor *)color Size:(CGSize)size andLinewidth:(CGFloat)width
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    CGContextSetLineWidth(ctx, width);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, size.width, size.height);
    CGContextMoveToPoint(ctx, size.width, 0);
    CGContextAddLineToPoint(ctx, 0, size.height);
    CGContextStrokePath(ctx);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
+(UIImage *)getGaryImage:(UIImage *)img
{
    CGColorSpaceRef colorref = CGColorSpaceCreateDeviceGray();
    CGContextRef ctx = CGBitmapContextCreate(nil, img.size.width, img.size.height, 8, 0, colorref, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorref);
    CGContextDrawImage(ctx, CGRectMake(0, 0, img.size.width, img.size.height), img.CGImage);
    CGImageRef ref = CGBitmapContextCreateImage(ctx);
    UIImage *imgg = [UIImage imageWithCGImage:ref];
    CFRelease(ref);
    CGContextRelease(ctx);
    return imgg;
}

+(UIImage *)createArrowImageWithColor:(UIColor *)color size:(CGSize)size lineWidth:(CGFloat)width andDirection:(NSUInteger)diretion
{
    //方向 1↑，2↓，3←，4→
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    CGContextSetLineWidth(ctx, width);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextBeginPath(ctx);
    switch (diretion) {
        case 1:// ↑
            CGContextMoveToPoint(ctx, 0, size.height);
            CGContextAddLineToPoint(ctx, size.width/2, size.height/2);
            CGContextMoveToPoint(ctx, size.width/2, size.height/2);
            CGContextAddLineToPoint(ctx, size.width, size.height);
            break;
        case 2:// ↓
            CGContextMoveToPoint(ctx, 0, 0);
            CGContextAddLineToPoint(ctx, size.width/2, size.height/2);
            CGContextMoveToPoint(ctx, size.width/2, size.height/2);
            CGContextAddLineToPoint(ctx,size.width, 0);
            break;
        case 3:// ←
            CGContextMoveToPoint(ctx, size.width, 0);
            CGContextAddLineToPoint(ctx, size.width/2, size.height/2);
            CGContextMoveToPoint(ctx, size.width/2, size.height/2);
            CGContextAddLineToPoint(ctx, size.width, size.height);
            break;
        case 4:// →
            CGContextMoveToPoint(ctx, 0, 0);
            CGContextAddLineToPoint(ctx, size.width/2, size.height/2);
            CGContextMoveToPoint(ctx, size.width/2, size.height/2);
            CGContextAddLineToPoint(ctx, 0, size.height);
            break;
        default:
            // →
            CGContextMoveToPoint(ctx, 0, 0);
            CGContextAddLineToPoint(ctx, size.width/2, size.height/2);
            CGContextMoveToPoint(ctx, size.width/2, size.height/2);
            CGContextAddLineToPoint(ctx, 0, size.height);
            break;
    }
    CGContextStrokePath(ctx);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+(void)combinationImageWithbackgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage size:(CGSize)size contentMode:(UIViewContentMode)contentMode complitionHandler:(void (^)(UIImage *, NSError *))complition
{
    if (!backgroundImage) {
        if (complition) {
            complition(nil,[NSError errorWithDomain:@"backgroundImage为nil" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"backgroundImage为nil！"}]);
        }
        return;
    }
    if (!foregroundImage) {
        if (complition) {
            complition(nil,[NSError errorWithDomain:@"foregroundImage为nil" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"foregroundImage为nil！"}]);
        }
        return;
    }
    if (size.height * size.width == 0) {
        if (complition) {
            complition(nil,[NSError errorWithDomain:@"size不正确" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"size不正确！"}]);
        }
        return;
    }
    dispatch_queue_t handleQueue = dispatch_queue_create("imagecombinationhandlequeue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(handleQueue, ^{
        NSError *err = nil;
       // 图像处理
        UIImageView *f_imv = [[UIImageView alloc] initWithImage:foregroundImage];
        [f_imv setFrame:CGRectMake(0, 0, size.width, size.height)];
        [f_imv setBackgroundColor:[UIColor clearColor]];
        [f_imv setContentMode:contentMode];
        f_imv.layer.masksToBounds = YES;
        UIImage *new_fimg = [self screenShotsWithView:f_imv];
// 合成
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        [backgroundImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        [new_fimg drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complition) {
                complition(newImg,err);
            }
        });
    });
    
}

- (UIImage *)imageWithNewSize:(CGSize)size
{
    if (!self || self.size.width == 0 || self.size.height == 0 || size.width == 0 || size.height == 0) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGFloat scale1 = self.size.width/self.size.height;
    CGFloat scale2 = size.width/size.height;
    if (scale1 > scale2) {
         [self drawInRect:CGRectMake(-(size.height*scale1-size.width)/2, 0, size.height*scale1, size.height)];
    }else{
        [self drawInRect:CGRectMake(0, -(size.width/scale1 - size.height)/2, size.width, size.width/scale1)];
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
-(UIImage *)imageToscale:(CGFloat)scale
{
    if (!self) {
        return nil;
    }
    if (scale <= 0) {
        return self;
    }
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*scale, self.size.height*scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width*scale, self.size.height*scale)];
    UIImage *scaleimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleimg;
}

-(void)reverseImagecomplite:(void (^)(UIImage *))complition
{
    if (!self) {
        if (complition) {
            complition(self);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGImageRef imgref = self.CGImage;
        size_t width = CGImageGetWidth(imgref);
        size_t height = CGImageGetHeight(imgref);
        size_t bitsPerComponent = CGImageGetBitsPerComponent(imgref);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(imgref);
        size_t bytesPerRow = CGImageGetBytesPerRow(imgref);
        
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(imgref);
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imgref);
        
        bool shouldInterpolate = CGImageGetShouldInterpolate(imgref);
        
        CGColorRenderingIntent intent = CGImageGetRenderingIntent(imgref);
        
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imgref);
        
        CFDataRef data = CGDataProviderCopyData(dataProvider);
        
        UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);//Returns a read-only pointer to the bytes of a CFData object.// 首地址
        NSUInteger  x, y;
        // 像素矩阵遍历，改变成自己需要的值
        UInt8 rgb = 255;
        for (y = 0; y < height; y++) {
            for (x = 0; x < width; x++) {
                UInt8 *tmp = buffer + x*4 +y*bytesPerRow;
                tmp[0] = rgb ^ tmp[0];
                tmp[1] = rgb ^ tmp[1];
                tmp[2] = rgb ^ tmp[2];
            }
        }
        CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
        
        CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
        // 生成一张新的位图
        CGImageRef effectedCgImage = CGImageCreate(
                                                   width, height,
                                                   bitsPerComponent, bitsPerPixel, bytesPerRow,
                                                   colorSpace, bitmapInfo, effectedDataProvider,
                                                   NULL, shouldInterpolate, intent);
        
        UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
        
        CGImageRelease(effectedCgImage);
        
        CFRelease(effectedDataProvider);
        
        CFRelease(effectedData);
        
        CFRelease(data);
        if (complition) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complition(effectedImage);
            });
        }
    });
    
    
}
-(void)mosaicImageWithArea:(CGRect)area level:(NSUInteger)level complite:(void (^)(UIImage *))complition
{
    if (!level) {
        if (complition) {
            complition(self);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGImageRef imgref = self.CGImage;
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imgref);
        CFDataRef imgdata = CGDataProviderCopyData(dataProvider);
        UInt8 *dataper = (UInt8 *)CFDataGetBytePtr(imgdata);
        size_t width = CGImageGetWidth(imgref);
        size_t heigth = CGImageGetHeight(imgref);
        size_t bytesperrow = CGImageGetBytesPerRow(imgref);
        size_t area_x = area.origin.x>width?width:area.origin.x;
        size_t area_y = area.origin.y>heigth?heigth:area.origin.y;
        size_t area_w = ((area.size.width?:width)+area_x)>width?(width-area_x):(area.size.width?:width);
        size_t area_h = ((area.size.height?:heigth)+area_y)>heigth?(heigth-area_y):(area.size.height?:heigth);
        /*取顶点像素*/
        //        for (size_t h=area_y; h < area_y+area_h; h++) {
        //            for (size_t w=area_x; w<area_x+area_w; w++) {
        //                UInt8 *colorcomponets = dataper + h*bytesperrow +w*4;// 每一个像素点是四个字节，w*4获取当前的像素点的字节位置
        //                UInt8 *changecolorcomponets = dataper + (h-h%level)*bytesperrow + (w-w%level)*4;// 获取level * level顶点的RGBA值
        //
        //                UInt8 tmp0 = changecolorcomponets[0];
        //                UInt8 tmp1 = changecolorcomponets[1];
        //                UInt8 tmp2 = changecolorcomponets[2];
        //                colorcomponets[0] = tmp0; // R
        //                colorcomponets[1] = tmp1; // G
        //                colorcomponets[2] = tmp2; // B
        //            }
        //        }
        /*取level*level像素平均值*/
        UInt8 r = 0,g = 0,b = 0;
        for (size_t h=area_y; h < area_y+area_h; h++) {
            for (size_t w=area_x; w<area_x+area_w; w++) {
                if ((h-area_y)%level==0 && (w-area_x)%level==0) {// level * level顶点
                    unsigned long R = 0,G = 0,B = 0;
                    // 向右，向下获取level * level个像素点，取RGB平均值
                    size_t rellevel_i = (w+level)>width?(width-w):level;
                    size_t rellevel_j = (h+level)>heigth?(heigth-h):level;
                    for (size_t i = 0; i<rellevel_i; i++) {
                        for (size_t j=0; j<rellevel_j; j++) {
                            UInt8 *colorcomponets = dataper + (h+j)*bytesperrow +(w+i)*4;
                            R += colorcomponets[0];
                            G += colorcomponets[1];
                            B += colorcomponets[2];
                        }
                        
                    }
                    // 计算出每一个level * level块的RGB均值大小
                    r = (UInt8) (R/(rellevel_i * rellevel_j));
                    g = (UInt8) (G/(rellevel_i * rellevel_j));
                    b = (UInt8) (B/(rellevel_i * rellevel_j));
                    // 重新给level*level像素点的RGB赋值
                    for (size_t i = 0; i<rellevel_i; i++) {
                        for (size_t j=0; j<rellevel_j; j++) {
                            UInt8 *cur_colorcomponets = dataper + (h+j)*bytesperrow +(w+i)*4;
                            cur_colorcomponets[0] = r;
                            cur_colorcomponets[1] = g;
                            cur_colorcomponets[2] = b;
                        }
                    }
                    
                }
            }
        }
        // 生成新图片
        CGImageRef masimg = CGImageCreate(width, heigth, CGImageGetBitsPerComponent(imgref), CGImageGetBitsPerPixel(imgref), bytesperrow, CGImageGetColorSpace(imgref), CGImageGetBitmapInfo(imgref), CGDataProviderCreateWithCFData(imgdata), CGImageGetDecode(imgref), CGImageGetShouldInterpolate(imgref), CGImageGetRenderingIntent(imgref));
        UIImage *img = [UIImage imageWithCGImage:masimg];
        CFRelease(imgdata);
        CGImageRelease(masimg);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complition) {
                complition(img);
            }
        });
    });
}

-(UIImage *)changeImageColorWithColor:(UIColor *)color error:(NSError *__autoreleasing *)error
{
    if (!self) {
        if (error) {
            *error = [NSError errorWithDomain:@"image为nil" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"image不能为nil"}];
        }
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, self.size.width, self.size.height));
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeDestinationIn alpha:1];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
-(void)changeImageColorWithColor:(UIColor *)color finished:(void (^)(UIImage *, NSError *))finished
{
    if (!self) {
        if (finished) {
            finished(self,[NSError errorWithDomain:@"image为nil" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"image不能为nil"}]);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGImageRef imgref = self.CGImage;
        size_t width = CGImageGetWidth(imgref);
        size_t height = CGImageGetHeight(imgref);
        size_t bytesPerRow = CGImageGetBytesPerRow(imgref);
        // copy 数据
        CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(imgref));
        UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);// 首地址
        NSUInteger  x, y;
        // 像素矩阵遍历，改变成自己需要的值
//        NSMutableString *str = [[NSMutableString alloc] init];
        for (y = 0; y < height; y++) {
            for (x = 0; x < width; x++) {
                UInt8 *tmp;
                tmp = buffer + y * bytesPerRow + x * 4;
                if (!tmp[3] || (tmp[0] ==0 && tmp[1] == 0 && tmp[2] == 0)) {
                    // 不处理rgb都为0或者alpha为0的像素点
                }else{
                    tmp[0] = 124;
                    tmp[1] = 12;
                    tmp[2] = 176;
                }
//                [str appendString:[NSString stringWithFormat:@"%3u-",tmp[0]]];
            }
//            [str appendString:@"\n"];
        }
//        NSLog(@"\n%@",str);
        // 生成一张新的位图
        CGImageRef newImageRef = CGImageCreate(width, height, CGImageGetBitsPerComponent(imgref), CGImageGetBitsPerPixel(imgref), CGImageGetBytesPerRow(imgref), CGImageGetColorSpace(imgref), CGImageGetBitmapInfo(imgref), CGDataProviderCreateWithCFData(data), CGImageGetDecode(imgref), CGImageGetShouldInterpolate(imgref), CGImageGetRenderingIntent(imgref));
        UIImage *newImage = [[UIImage alloc] initWithCGImage:newImageRef];
        CFRelease(data);
        CFRelease(newImageRef);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(newImage,nil);
            }
        });
    });
    

}


@end
