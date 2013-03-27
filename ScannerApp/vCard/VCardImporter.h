//
//  VCardImporter.h
//  qrScannerDemo
//
//  Created by Sebastian Kruschwitz on 04.02.13.
//  Copyright (c) 2013 greenmobile. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface VCardImporter : NSObject 

@property(nonatomic, readonly) ABRecordRef parsedPerson;
@property(nonatomic, readonly) ABAddressBookRef addressBook;


-(void)parse:(NSString*)vcardString;

-(BOOL)addToAddressBook:(NSString*)vcardString;

@end
