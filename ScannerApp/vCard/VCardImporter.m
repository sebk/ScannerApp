//
//  VCardImporter.m
//  qrScannerDemo
//
//  Created by Sebastian Kruschwitz on 04.02.13.
//  Copyright (c) 2013 greenmobile. All rights reserved.
//

#import "VCardImporter.h"

@interface VCardImporter () {
    ABAddressBookRef _addressBook;
    ABRecordRef _personRecord;
    NSString *_base64image;
}

@end

@implementation VCardImporter

- (id) init {
    if (self = [super init]) {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    
    return self;
}

- (void) dealloc {
    CFRelease(_addressBook);
}


-(void)grantAccess:(void(^)(BOOL succeess))completion {
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            completion(YES);
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        completion(YES);
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The App has no access to the address book" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        completion(NO);
    }
}

-(void)parse:(NSString*)vcardString {
    
    /*
    [self grantAccess:^(BOOL succeess) {
        if (!succeess) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The App has no access to the address book" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
     */
    
    CFDataRef vCardData = (__bridge CFDataRef)[vcardString dataUsingEncoding:NSUTF8StringEncoding];
    
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
    CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
    for (CFIndex index = 0; index < CFArrayGetCount(vCardPeople); index++) {
        ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, index);
        
        [self print:person];
        
        _parsedPerson = person; //TODO: CHANGE TO ARRAY SUPPORT
                
        //ABAddressBookAddRecord(book, person, NULL);
        CFRelease(person);
    }
    
    //CFRelease(vCardPeople);
    CFRelease(defaultSource);
    
    //ABAddressBookSave(book, NULL);
}

//!!!: Attention: This method will add a new Contact, without checking for duplicates
-(BOOL)addToAddressBook:(NSString*)vcardString {
    [self grantAccess:^(BOOL succeess) {
        if (!succeess) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The App has no access to the address book" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
    
    CFDataRef vCardData = (__bridge CFDataRef)[vcardString dataUsingEncoding:NSUTF8StringEncoding];
    
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
    CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
    for (CFIndex index = 0; index < CFArrayGetCount(vCardPeople); index++) {
        ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, index);
        
        ABAddressBookAddRecord(book, person, NULL);
        CFRelease(person);
    }
    
    CFRelease(vCardPeople);
    CFRelease(defaultSource);
    return ABAddressBookSave(book, NULL);
}

-(void)print:(ABRecordRef)record {
    
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonMiddleNameProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonPrefixProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonSuffixProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonNicknameProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNamePhoneticProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonMiddleNamePhoneticProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonOrganizationProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonJobTitleProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonDepartmentProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonNoteProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonKindProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonBirthdayProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonCreationDateProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonModificationDateProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonEmailProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonAddressProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonDateProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonPhoneProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonInstantMessageProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonURLProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonRelatedNamesProperty));
    NSLog(@"kABPersonFirstNameProperty: %@", (__bridge NSString *)ABRecordCopyValue(record, kABPersonSocialProfileProperty));
}

@end
