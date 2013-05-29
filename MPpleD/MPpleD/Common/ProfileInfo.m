//
//  ProfileInfo.m
//  ContactSync
//
//  Created by Apple on 13-4-17.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "ProfileInfo.h"


@implementation UserInfo

@synthesize m_nGender;

- (void) setUserInfo:(NSString*)profile email:(NSString*)email password:(NSString*)password name:(NSString*)name phone:(NSString*)phone gender:(int)gender {
    if (profile)
        m_strProfile = [[NSString alloc] initWithString:profile];
    if (email)
        m_strEmail = [[NSString alloc] initWithString:email];
    if (password)
        m_strPassword = [[NSString alloc] initWithString:password];
    if (name)
        m_strName = [[NSString alloc] initWithString:name];
    if (phone)
        m_strPhone = [[NSString alloc] initWithString:phone];
    m_nGender = gender;
}

- (NSString*) getGenderString {
    if (m_nGender == GENDER_FEMALE)
        return @"Female";
    else
        return @"Male";
}

@end


@implementation ProfileInfo

@synthesize m_nPersonRecordId, m_bFavorites;

- (void) dealloc {
    [m_strProfile release];
    [m_strFirstName release];
    [m_strLastName release];
    [m_strImageFileName release];
    [super dealloc];
}
- (id) initWithName:(NSString*)firstName lastName:(NSString*)lastName {
    [self init];
    if (firstName)
        m_strFirstName = [[NSString alloc] initWithString:firstName];
    if (lastName)
        m_strLastName = [[NSString alloc] initWithString:lastName];
    return self;
}
- (void) setProfileString:(NSString*)profile {
    if (profile)
        m_strProfile = [[NSString alloc] initWithString:profile];
}
- (void) setImageFileName:(NSString*)image {
    if (image)
        m_strImageFileName = [[NSString alloc] initWithString:image];
}

- (NSString*) getProfileString {
    if (m_strProfile)
        return m_strProfile;
    else
        return [self getNameString];
}
- (NSString*) getNameString {
    NSString* strName;
    if (m_strFirstName != nil && m_strLastName != nil)
        strName = [NSString stringWithFormat:@"%@ %@", m_strFirstName, m_strLastName];
    else if (m_strFirstName != nil)
        strName = [NSString stringWithFormat:@"%@", m_strFirstName];
    else if (m_strLastName != nil)
        strName = [NSString stringWithFormat:@"%@", m_strLastName];
    else {
//        strName = [NSString stringWithFormat:@"%@ %@", m_strFirstName, m_strLastName];
        strName = @"";
    }
    return strName;
}
- (NSString*) getImageFilePath {
    return m_strImageFileName;
}

@end
