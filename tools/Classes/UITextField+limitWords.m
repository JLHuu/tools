//
//  UITextField+limitWords.m
//  cuteDituhui
//
//  Created by HJL on 2017/9/5.
//  Copyright © 2017年 SuperMap. All rights reserved.
//

#import "UITextField+limitWords.h"
#import <objc/runtime.h>

static char *maxLengthKey = "maxLengthKey";
static char lb = 't';
@implementation UITextField (limitWords)
@dynamic maxLength;

-(void)setMaxLength:(NSUInteger)maxLength
{
    objc_setAssociatedObject(self, maxLengthKey, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSUInteger)maxLength
{
    return [objc_getAssociatedObject(self, maxLengthKey) unsignedIntegerValue];
}
- (void)setObserveBlock:(limitWordsBlock)block
{
    objc_setAssociatedObject(self, &lb, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (limitWordsBlock)getObserveBlock
{
    return objc_getAssociatedObject(self, &lb);
}
-(void)startlimitWordsObserveWithBlock:(limitWordsBlock)block
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChanged:) name:UITextFieldTextDidChangeNotification object:self];
    if (block) {
        [self setObserveBlock:block];
    }
}
-(void)removelimitWordsObserve
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)textFiledDidChanged:(NSNotification *)noti
{
    UITextField *textField = noti.object;
    if (![textField isEqual:self]) {
        return;
    }
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position || !selectedRange)
        {
            if (toBeString.length > self.maxLength)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:self.maxLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
                [self getObserveBlock](YES,textField.text);
            }else{
                [self getObserveBlock](NO,textField.text);
            }
        }
    }else
    {
        if (toBeString.length > self.maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:self.maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
            [self getObserveBlock](YES,textField.text);
        }else{
            [self getObserveBlock](NO,textField.text);
        }
    }
    
}
-(void)dealloc
{
    [self removelimitWordsObserve];
}
@end
