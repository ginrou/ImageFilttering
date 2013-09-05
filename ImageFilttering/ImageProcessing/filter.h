//
//  filter.h
//  ImageFilttering
//
//  Created by 武田 祐一 on 2013/09/06.
//  Copyright (c) 2013年 武田 祐一. All rights reserved.
//

#ifndef ImageFilttering_filter_h
#define ImageFilttering_filter_h

void lut_convert(unsigned char* src, unsigned char* dst, int height, int width, int lut[3][256]);

#endif
