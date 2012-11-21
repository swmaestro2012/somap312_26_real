//
//  SettingViewController.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 15..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "SettingViewController.h"
#import "InfoSubCell.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dbMsg = [DataBase getInstance];
        [self setClass:[dbMsg getStteingData]];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnEvent:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    settingTable = nil;
    [super viewDidUnload];
}

-(void)setClass:(int)c{
    if (c == 0) {
        tempClass = @"중학교";
    }else if(c == 1){
        tempClass = @"고등학교";
    }
        
}

// ------------- TableView Setting ------------- //
/* ---------------------------------------------
 0번 색션일 경우 항목을 1개
 1번 색션일 경우 항목을 2개 생성
 --------------------------------------------- */
#pragma mark Table Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 2;
        }
    }else{
        return 2;
    }
    return 0;
}

/* ---------------------------------------------
 색션을 2개 생성
 --------------------------------------------- */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 0) {
        return 2;
    }
    return 1;
}

/* ---------------------------------------------
 Header Height 를 40으로 지정
 --------------------------------------------- */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return 40;
    }
    return  0;
}


/* ---------------------------------------------
 각 셀을 설정
 --------------------------------------------- */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        if ([indexPath section] == 0) {
            InfoSubCell *cell = [[InfoSubCell alloc]init];
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
            if(cell == nil){
                
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"InfoSubCell" owner:nil options:nil];
                
                cell = [array objectAtIndex:0];
            }
            cell.classLabel.text = tempClass;
            
            return cell;
        }else if ([indexPath section] == 1) {
            
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            
            if ([indexPath row] == 0) {
                cell.textLabel.text = @"사용 데이터 초기화";
            }else if ([indexPath row] == 1) {
                cell.textLabel.text = @"FeedBack 보내기";
            }
            return cell;
            
        }

    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        
        if ([indexPath row] == 0) {
            cell.textLabel.text = @"중학생";
        }else if ([indexPath row] == 1) {
            cell.textLabel.text = @"고등학생";
        }
//        [dbMsg updateClass:[indexPath row]];
//        [self setClass:[dbMsg getStteingData]];
//        cell.textLabel.text = tempClass;
        return cell;
    }
    
    return nil;
}

/* ---------------------------------------------
 섹션을 타이틀 설정
 --------------------------------------------- */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        if (section == 0) {
            return @"사용자 정보";
        }else if (section == 1) {
            return @"기타";
        }
    }
    return 0;
}

/* ---------------------------------------------
 각 셀을 설정 클릭 이벤트 설정
 --------------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        if ([indexPath section] == 0) {
            [self setClass];
        }else if ([indexPath section] == 1) {
            if ([indexPath row] == 0) {
                alert = [[UIAlertView alloc] initWithTitle:@"확  인"
                                                               message:@"데이터가 모두 삭제됩니다.\n초기화 하시겠습니까?"
                                                              delegate:self
                                                     cancelButtonTitle:@"아니요"
                                                     otherButtonTitles:@"예", nil];
                
                alert.tag = 0;
                [alert show];

            }else if ([indexPath row] == 1) {
                [self sendFeedBack];
            }
        }
    }else {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [dbMsg updateClass:[indexPath row]];
        [self setClass:[dbMsg getStteingData]];
        [settingTable reloadData];
    }
}

-(void)dataInit{
    [dbMsg dataInit];
    [self setClass:[dbMsg getStteingData]];
    [settingTable reloadData];
}

-(void)setClass{
    alert = [[UIAlertView alloc] initWithTitle:@"선  택"
                                                    message:@"\n\n\n\n\n\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil, nil];
    
    UITableView *myView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 264, 150)];
    
    myView.tag = 1;
    myView.delegate = self;
    myView.dataSource = self;
    
    [myView setScrollEnabled:NO];
    
    [alert addSubview:myView];
    
    [alert setAutoresizesSubviews:YES];
    
    [alert show];
    
}

// ------------- sendFeedBack ------------- //
/* ----------------------------------------
 개발자에게 FeedBack 보내기
 ---------------------------------------- */
-(void)sendFeedBack{
    MFMailComposeViewController *mailsome = [[MFMailComposeViewController alloc] init];
    mailsome.mailComposeDelegate=self;
    if([MFMailComposeViewController canSendMail]){
        [mailsome setToRecipients:[NSArray arrayWithObjects:@"chin9ubda@gmail.com" ,nil]];
        
        [mailsome setSubject:nil];
        [mailsome setMessageBody:nil isHTML:NO];
        [self presentModalViewController:mailsome animated:YES];
    }
}

// ------- mailComposeController Button Event ------- //
/* ----------------------------------------------------------------------
 mailComposeController 상의 버튼을 클릭했을경우
 모달뷰를 Dismiss
 탭바 보이기
 ---------------------------------------------------------------------- */
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result == MFMailComposeResultCancelled) {
        [self dismissModalViewControllerAnimated:YES];
    }else if ( result == MFMailComposeResultSent) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0 && buttonIndex == 1) {
        [self dataInit];
    }
}
@end
