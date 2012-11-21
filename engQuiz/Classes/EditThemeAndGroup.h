//
//  EditThemeAndGroup.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditThemeAndGroup : UIView<UITextFieldDelegate>{
    UITapGestureRecognizer *tap;
}

@property (strong, nonatomic) IBOutlet UITextField *themeLabel;
@property (strong, nonatomic) IBOutlet UITextField *groupLabel;
@property (strong, nonatomic) IBOutlet UIButton *delBtn;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@end
