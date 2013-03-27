//
//  QRScanner.h
//  ScannerModul
//
//  Created by Seb on 19.03.13.
//  Copyright (c) 2013 Gobas GmbH. All rights reserved.
//



#import "ZXingWidgetController.h"


@protocol QRScannerDelegate <NSObject>

- (void)didScannedCode:(NSString*)result;

- (void)didCancelScanning;

@end


@interface QRScanner : UIViewController <ZXingDelegate>

@property(nonatomic, weak) id<QRScannerDelegate> delegate;

- (void)presentScanWidgetOn:(UIViewController*)viewController;

@end
