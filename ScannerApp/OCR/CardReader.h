//
//  CardReader.h
//  ScannerModul
//
//  Created by Seb on 19.03.13.
//  Copyright (c) 2013 Gobas GmbH. All rights reserved.
//


@interface CardReader : NSObject

/**
 Scan the image.
 This method uses Tesseract as the scanning processor.
 @param image UIIMage to be scanned
 @param completion Block with the NSString result. This block will be called on the main thread.
 */
- (void)scanCard:(UIImage*)image completion:(void (^)(NSString *result))completion;

@end
