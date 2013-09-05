//
//  ImageConverter.h
//  ImageFilttering
//
//  Created by 武田 祐一 on 2013/09/05.
//  Copyright (c) 2013年 武田 祐一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageConverter : NSObject
+ (UIImage *)convertImage:(UIImage *)inputImage;
@end

void loadLookUpTable(int lut[3][256]);
