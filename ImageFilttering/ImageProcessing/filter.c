//
//  filter.c
//  ImageFilttering
//
//  Created by 武田 祐一 on 2013/09/06.
//  Copyright (c) 2013年 武田 祐一. All rights reserved.
//

#include "filter.h"

void lut_convert(unsigned char* src, unsigned char* dst, int height, int width, int lut[3][256])
{
    for (int h = 0; h < height; ++h) {
        for (int w = 0; w < width; ++w) {
            int idx = 4 * ( h * width + w);
            dst[idx+0] = lut[0][src[idx+0]];
            dst[idx+1] = lut[1][src[idx+1]];
            dst[idx+2] = lut[2][src[idx+2]];
            dst[idx+3] = src[idx+3];
        }
    }
}
