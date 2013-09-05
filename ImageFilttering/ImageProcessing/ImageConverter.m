//
//  ImageConverter.m
//  ImageFilttering
//
//  Created by 武田 祐一 on 2013/09/05.
//  Copyright (c) 2013年 武田 祐一. All rights reserved.
//

#import "ImageConverter.h"
#include "filter.h"

static const size_t bytesPerPixel = 4;
static const size_t bitsPerComponent = 8;
static const size_t bitsPerPixel = bytesPerPixel * bitsPerComponent;

@implementation ImageConverter
+ (UIImage *)convertImage:(UIImage *)inputImage
{
    CGImageRef cgImage = inputImage.CGImage;
    size_t width  = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    unsigned char* src_buf = getImageBuffer(cgImage);

    unsigned char* dst_buf = createBufferFor(cgImage);

    int lut[3][256];
    loadLookUpTable(lut);
    lut_convert(src_buf, dst_buf, height, width, lut);

    UIImage *dst = [self imageFromBuffer:dst_buf height:height width:width];
    free(src_buf);
    free(dst_buf);
    return dst;

}

unsigned char *createBufferFor(CGImageRef cgImage)
{
    size_t width  = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    size_t buf_size = height * width * 4; // BGRA 4channels
    unsigned char *rawData = (unsigned char*)calloc(buf_size, sizeof(unsigned char));
    return rawData;
}

unsigned char *getImageBuffer(CGImageRef cgImage)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t width  = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    unsigned char *rawData = createBufferFor(cgImage);
    size_t bytesPerRow = bytesPerPixel * width;

    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);

    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(context);
    return rawData;
}


+ (UIImage *)imageFromBuffer:(unsigned char *)buf height:(size_t)height width:(size_t)width
{
    size_t buf_size = bytesPerPixel * height * width;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buf, buf_size, NULL);
    size_t bytesPerRow = bytesPerPixel * width;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;

    CGImageRef cgImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, provider, NULL, YES, renderingIntent);
    uint32_t *pixels = (uint32_t *)malloc(buf_size);

    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGImageRef cgImageFromContext = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:cgImageFromContext];

    CGImageRelease(cgImage);
    CGImageRelease(cgImageFromContext);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);

    if (pixels) free(pixels);

    return image;
}

@end

void loadLookUpTable(int lut[3][256])
{
    NSString *path = [NSBundle.mainBundle pathForResource:@"lut_sample" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];

    // assuming 3*256 array
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    for (int c = 0; c < 3; ++c) {
        for (int r = 0; r < 256; ++r) {
            lut[c][r] = [json[c][r] intValue];
        }
    }

}
