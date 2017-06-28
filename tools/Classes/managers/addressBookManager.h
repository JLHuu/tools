//
//  addressBookManager.h
//  addressPage
//
//  Created by chang on 2017/6/22.
//  Copyright © 2017年 HJL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
/**
 通讯录管理类
 */
@interface addressBookManager : NSObject
/** 实例化 */
+ (instancetype)instance;
/**
 获取通讯录权限,ios9.0后可用
 
 @param complition 回调
 */
- (void)fetchContactsAuthorizationComplitionHandler:(void(^)(BOOL granted,CNContactStore *contactStore,NSError *error))complition NS_AVAILABLE_IOS(9_0);

/**
 从CNContactStore获取条件的数据,ios9.0后可用

 @param contactStore contactStore
 @param arr 过滤条件
 @param complition 完成回调
 */
- (void)fetchContactsWithContactStore:(CNContactStore *)contactStore filter:(NSArray <id<CNKeyDescriptor>>*)arr complition:(void(^)(NSArray<CNContact *>*contacts,NSError *error))complition NS_AVAILABLE_IOS(9_0);

@end

