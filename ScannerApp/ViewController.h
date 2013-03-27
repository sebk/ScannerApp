//
//  ViewController.h
//  ScannerApp
//
//  Created by Seb on 20.03.13.
//  Copyright (c) 2013 Gobas GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRScanner.h"
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController <QRScannerDelegate, ABPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate>

@property(nonatomic, weak) IBOutlet UITextView *textView;


-(IBAction)showQRWidget:(id)sender;

-(IBAction)scanVCard:(id)sender;

@end
