//
//  ViewController.m
//  ImageFilttering
//
//  Created by 武田 祐一 on 2013/09/05.
//  Copyright (c) 2013年 武田 祐一. All rights reserved.
//

#import "ViewController.h"
#import "ImageConverter.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _beforeImageView.image = [UIImage imageNamed:@"Lenna"];


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        // do processings
        UIImage *afterImage = [ImageConverter convertImage:_beforeImageView.image];

        int lut[3][256];
        loadLookUpTable(lut);
        

        dispatch_async(dispatch_get_main_queue(), ^{
            _afterImageView.image = afterImage;
        });

    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
