//
//  Camera.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 14..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Camera : UIView

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UIButton *takePicture;
@property (strong, nonatomic) IBOutlet UIView *cropView;
@end
