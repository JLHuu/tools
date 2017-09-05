//
//  UITextField+limitWords.h
//  cuteDituhui
//
//  Created by HJL on 2017/9/5.
//  Copyright © 2017年 SuperMap. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^limitWordsBlock) (BOOL beyondLimit,NSString *text);
/** textFiled可以进行字数限制 */
@interface UITextField (limitWords)
@property (nonatomic,assign) NSUInteger maxLength;
- (void)startlimitWordsObserveWithBlock:(limitWordsBlock)block;
/// 需要时调用，默认是在delloc中调用
- (void)removelimitWordsObserve;
@end
