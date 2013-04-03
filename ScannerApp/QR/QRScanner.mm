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

#import "CustomOverlayView.h"


@interface QRScanner () {
    UIViewController *_viewController;
    ZXingWidgetController *_widController;
    
}

@end

@implementation QRScanner

- (void)presentScanWidgetOn:(UIViewController*)viewController {
    
    _viewController = viewController;
    
    _widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    
    
    CustomOverlayView *overlay = [[CustomOverlayView alloc] initWithFrame: _viewController.view.bounds
                                                            cancelEnabled:YES oneDMode:NO showLicense:NO];
    overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _widController.overlayView = overlay;
    _widController.overlayView.delegate = _widController;

    
    
    NSMutableSet *readers = [[NSMutableSet alloc ] init];
    
#if ZXQR
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    [readers addObject:qrcodeReader];
#endif
    
#if ZXAZ
    AztecReader *aztecReader = [[AztecReader alloc] init];
    [readers addObject:aztecReader];
#endif
    
    _widController.readers = readers;
    
    [_viewController presentViewController:_widController animated:YES completion:^{
        NSLog(@"opened QR-Scanner-View");
    }];
    
}


#pragma mark - ZXing Delegate

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result{
    [_viewController dismissViewControllerAnimated:YES completion:^{

        if (_delegate && [_delegate respondsToSelector:@selector(didScannedCode:)]) {
            [_delegate didScannedCode:result];
        }
        
    }];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [_viewController dismissViewControllerAnimated:NO completion:^{
        
        if (_delegate && [_delegate respondsToSelector:@selector(didCancelScanning)]) {
            [_delegate didCancelScanning];
        }
    }];
    
}


@end
