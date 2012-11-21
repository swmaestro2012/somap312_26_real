//
//  ViewController.h
//  TesseractSample
//
//  Created by Ângelo Suzuki on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "OcrResultCheckViewController.h"

@class MBProgressHUD;

namespace tesseract {
    class TessBaseAPI;
};

@interface ViewController : UIViewController<UIAlertViewDelegate>
{
    MBProgressHUD *progressHud;
    
    tesseract::TessBaseAPI *tesseract;
    uint32_t *pixels;
//    UIImage *img;
    NSArray *imgArray;
    
    Boolean inputCheck;
    int checkNumber;
    
    DataBase *dbMsg;
    
    OcrResultCheckViewController *resultCheckView;
}

@property (nonatomic, strong) MBProgressHUD *progressHud;

- (void)setTesseractImage:(UIImage *)image;
//-(void)setimage:(UIImage *)image;
-(void)setimage:(NSArray *)_imgArray;

-(void)setCheckNumber:(int)num;
@end
