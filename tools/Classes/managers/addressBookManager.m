//
//  addressBookManager.m
//  addressPage
//
//  Created by chang on 2017/6/22.
//  Copyright © 2017年 HJL. All rights reserved.
//

#import "addressBookManager.h"

@implementation addressBookManager
+ (instancetype)instance
{
    return [[self alloc] init];
}

- (void)fetchContactsAuthorizationComplitionHandler:(void(^)(BOOL granted,CNContactStore *contactStore,NSError *error)) complition{
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (complition) {
            complition(granted,store,error);
        }
    }];
    
}
-(void)fetchContactsWithContactStore:(CNContactStore *)contactStore filter:(NSArray<id<CNKeyDescriptor>> *)arr complition:(void (^)(NSArray<CNContact *>*contacts,NSError *error))complition
{
    if (!contactStore) {
        if (complition) {
            complition(nil,[NSError errorWithDomain:@"contactStore为nil" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"contactStore为nil"}]);
        }
        return;
    }
    NSError *err = nil;
    if (!arr) {
        arr = @[CNContactPhoneNumbersKey,CNContactFamilyNameKey,CNContactMiddleNameKey];
    }
    NSMutableArray <CNContact *>*contactArr = [NSMutableArray arrayWithCapacity:1];
    [contactStore enumerateContactsWithFetchRequest:[[CNContactFetchRequest alloc] initWithKeysToFetch:arr] error:&err usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        [contactArr addObject:[contact copy]];
    }];
    if (complition) {
        complition(contactArr,err);
    }
    
}
@end
