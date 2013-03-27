//
//  QRScanner.m
//  ScannerModul
//
//  Created by Seb on 19.03.13.
//  Copyright (c) 2013 Gobas GmbH. All rights reserved.
//

#import "QRScanner.h"

#ifndef ZXQR
#define ZXQR 1
#endif

#if ZXQR
#import "QRCodeReader.h"
#endif

#ifndef ZXAZ
#define ZXAZ 0
#endif

#if ZXAZ
#import "AztecReader.h"
#endif

@interface QRScanner () {
    UIViewController *_viewController;
}

@end

@implementation QRScanner

-(BOOL)shouldAutorotate {
    return YES;
}

- (void)presentScanWidgetOn:(UIViewController*)viewController {
    
    _viewController = viewController;
    
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    
    NSMutableSet *readers = [[NSMutableSet alloc ] init];
    
#if ZXQR
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    [readers addObject:qrcodeReader];
#endif
    
#if ZXAZ
    AztecReader *aztecReader = [[AztecReader alloc] init];
    [readers addObject:aztecReader];
#endif
    
    widController.readers = readers;
    
    [_viewController presentViewController:widController animated:YES completion:^{
        NSLog(@"opened QR-Scanner-View");
    }];
}


#pragma mark - ZXing Delegate

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result{
    [_viewController dismissViewControllerAnimated:YES completion:^{

        if (_delegate && [_delegate respondsToSelector:@selector(didScannedCode:)]) {
            [_delegate didScannedCode:result];
        }
                
        /*
        NSArray *substrings = [result componentsSeparatedByString:@"\n"];
        if (substrings.count > 0 && [substrings[0] isEqualToString:@"BEGIN:VCARD"]) {
            _parser = [[VCardImporter alloc]init];
            [_parser parse:result];
            
            [self performSegueWithIdentifier:@"showVcard" sender:self];
            
        }
         */
        
    }];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [_viewController dismissViewControllerAnimated:YES completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(didCancelScanning)]) {
            [_delegate didCancelScanning];
        }
    }];
    
}


@end
