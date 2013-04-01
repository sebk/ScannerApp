//
//  CardScanViewController.h
//  ScannerApp
//
//  Created by Seb on 27.03.13.
//  Copyright (c) 2013 Gobas GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardScanViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(weak, nonatomic) IBOutlet UIImageView *imageView;

@property(weak, nonatomic) IBOutlet UITextView *textView;


-(IBAction)chooseFromCamera:(id)sender;

-(IBAction)chooseFromLibrary:(id)sender;

-(IBAction)scanImage:(id)sender;

@end
