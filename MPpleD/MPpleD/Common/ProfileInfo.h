//
//  ProfileInfo.h
//  ContactSync
//
//  Created by Apple on 13-4-17.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

enum GENDER_TYPE {
    GENDER_FEMALE = 0,
    GENDER_MALE
};
@interface UserInfo : NSObject {
    NSString*   m_strProfile;
    NSString*   m_strEmail;
    NSString*   m_strPassword;
    NSString*   m_strName;
    NSString*   m_strPhone;
    int     m_nGender;
    NSString*   m_strImageFileName;
}

@property (nonatomic, assign)NSString*   m_strProfile;
@property (nonatomic, assign)NSString*   m_strEmail;
@property (nonatomic, assign)NSString*   m_strPassword;
@property (nonatomic, assign)NSString*   m_strName;
@property (nonatomic, assign)NSString*   m_strPhone;
@property (nonatomic, assign)NSString*   m_strImageFileName;
@property (nonatomic)int m_nGender;


- (void) setUserInfo:(NSString*)profile email:(NSString*)email password:(NSString*)password name:(NSString*)name phone:(NSString*)phone gender:(int)gender;

- (NSString*) getGenderString;
@end

@interface ProfileInfo : NSObject {
    NSString*   m_strProfile;
    NSString*   m_strFirstName;
    NSString*   m_strLastName;
    NSString*   m_strImageFileName;
    NSString*   m_strCompany;
    BOOL    m_bFavorites;
    int32_t m_nPersonRecordId;
}

@property (nonatomic) BOOL m_bFavorites;
@property (nonatomic) int32_t m_nPersonRecordId;

- (id) initWithName:(NSString*)firstName lastName:(NSString*)lastName;
- (void) setProfileString:(NSString*)profile;
- (void) setImageFileName:(NSString*)image;

- (NSString*) getProfileString;
- (NSString*) getNameString;
- (NSString*) getImageFilePath;

@end
