//
//  NextAddInfoView.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 15..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextAddInfoView : UIView<UITextFieldDelegate>{
    UITapGestureRecognizer *tap;
}

@property (strong, nonatomic) IBOutlet UITextField *themeTextField;
@property (strong, nonatomic) IBOutlet UITextField *groupTextField;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@end
