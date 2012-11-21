//
//  VocaViewController.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 10. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "VocaViewController.h"
#import "VocaCell.h"
#import "EduViewController.h"
#import "ExSentence.h"

@interface VocaViewController ()

@end

@implementation VocaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dbMsg = [DataBase getInstance];
        collation = [UILocalizedIndexedCollation currentCollation];
        [self setAllVocaData];
    }
    return self;
}

- (void)viewDidLoad
{
    [tabbalContoller setSelectedItem:item01];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardDown)];
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

- (IBAction)searchBtnEvent:(id)sender {
    [self searchEvent];
}

- (IBAction)eduBtnEvent:(id)sender {
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"취소"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"필수 영단어", @"틀린 단어",@"단어",@"숙어", nil];
    [actionsheet showInView:self.view];
}

-(void) searchEvent{
    
    NSString *tempSerchMsg = searchMsg.text;
    int section = 0;
    int index = 0;
    if ([tempSerchMsg isEqualToString:@""]) {
        [self setAllVocaData];
    }else {
        NSArray * tempArray = [dbMsg searchVoca:tempSerchMsg:type:check];
        if (tempArray.count != 0) {
            for (int i = 0; i < muArray.count; i++) {
                if ([[muArray objectAtIndex:i]isEqual:[tempSerchMsg substringWithRange:(NSRange){0,1}]]) {
                    section = i;
                    break;
                }
            }
            for (int i = 0; i < vArray[section].count; i+= 4) {
                if ([[vArray[section] objectAtIndex:i]isEqual:[tempArray objectAtIndex:0]]) {
                    index = i / 4;
                    break;
                }
            }
        }
    }
    [self keyBoardDown];
//    [vocaTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
    
    [vocaTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)setAllVocaData{
    muArray = nil;
    muArray = [NSMutableArray arrayWithCapacity:0];
    
    type = 0;
    check = 3;
    
    [self tableReload];
    for (int i = 0; i < [muArray count] - 1; i++) {
        vArray[i] = [dbMsg searchVoca:[muArray objectAtIndex:i]:0:3];
    }
}


#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int index = [indexPath row];
    int section = [indexPath section];
    
    VocaCell *vocaCell = [[VocaCell alloc]init];
    
    vocaCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    if(vocaCell == nil){
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VocaCell" owner:nil options:nil];
        
        vocaCell = [array objectAtIndex:0];

    }
    
    if (check == 2) {
        if (index == 0) {
            vocaCell.wordLabel.text = [xArray objectAtIndex:0];
            vocaCell.meanLabel.text = [xArray objectAtIndex:1];
            if ([[xArray objectAtIndex:2]integerValue] == 1)
                vocaCell.classLabel.text = @"중";
            else if([[xArray objectAtIndex:2]integerValue] == 2)
                vocaCell.classLabel.text = @"고";
            else
                vocaCell.classLabel.text = @"기";
        }else{
            vocaCell.wordLabel.text = [xArray objectAtIndex:index * 4];
            vocaCell.meanLabel.text = [xArray objectAtIndex:index * 4 + 1];
            if ([[xArray objectAtIndex:index * 4 + 2]integerValue] == 1)
                vocaCell.classLabel.text = @"중";
            else if([[xArray objectAtIndex:index * 4 + 2]integerValue] == 2)
                vocaCell.classLabel.text = @"고";
            else
                vocaCell.classLabel.text = @"기";
        }
    }else {
        if (index == 0) {
            vocaCell.wordLabel.text = [vArray[section] objectAtIndex:0];
            vocaCell.meanLabel.text = [vArray[section] objectAtIndex:1];
            if ([[vArray[section] objectAtIndex:2]integerValue] == 1)
                vocaCell.classLabel.text = @"중";
            else if([[vArray[section] objectAtIndex:2]integerValue] == 2)
                vocaCell.classLabel.text = @"고";
            else
                vocaCell.classLabel.text = @"기";
        }else{
            vocaCell.wordLabel.text = [vArray[section] objectAtIndex:index * 4];
            vocaCell.meanLabel.text = [vArray[section] objectAtIndex:index * 4 + 1];
            if ([[vArray[section] objectAtIndex:index * 4 + 2]integerValue] == 1)
                vocaCell.classLabel.text = @"중";
            else if([[vArray[section] objectAtIndex:index * 4 + 2]integerValue] == 2)
                vocaCell.classLabel.text = @"고";
            else
                vocaCell.classLabel.text = @"기";
        }
    }

    return vocaCell;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (check == 2) {
        return 1;
    }
    return muArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
//    return [[collation sectionTitles] objectAtIndex:section];
    if (check == 2) {
        return nil;
    }
    return [muArray objectAtIndex:section];
}



// ---------------- Row Count Setting ---------------- //

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (check == 2) {
        return xArray.count / 4;
    }
    return vArray[section].count / 4;
}



// ---------------- Cell Select Event ---------------- //


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = [indexPath row];
    int section = [indexPath section];
    
    if (eSentence != nil) {
        [eSentence removeFromSuperview];
        eSentence = nil;
    }
    
    eSentence = [[ExSentence alloc]init];
    
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"exSentence" owner:self options:nil];
    eSentence = (ExSentence *)[xibs objectAtIndex:0];
    [eSentence awakeFromNib];
    
    eSentence.frame = CGRectMake(0, 0, 320, 460);
    
    if (check == 2) {
        if (index == 0) {
            [eSentence setWord:[xArray objectAtIndex:0]:[xArray objectAtIndex:1]:[[xArray objectAtIndex:3] intValue]];
        }else{
            [eSentence setWord:[xArray objectAtIndex:index *4]:[xArray objectAtIndex:index *4 + 1]:[[xArray objectAtIndex:index * 4 + 3] intValue]];
            
        }
    }else {
        if (index == 0) {
            [eSentence setWord:[vArray[section] objectAtIndex:0]:[vArray[section] objectAtIndex:1]:[[vArray[section] objectAtIndex:3] intValue]];
        }else{
            [eSentence setWord:[vArray[section] objectAtIndex:index *4]:[vArray[section] objectAtIndex:index *4 + 1]:[[vArray[section] objectAtIndex:index * 4 + 3] intValue]];
            
        }
    }
    
    [self.view addSubview:eSentence];

}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (check == 2) {
        return nil;
    }
    return muArray;
}


// --------- TextField BeginEditing --------- //


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardDown)];
    [self.view addGestureRecognizer:tap];
    
    return YES;
}


// -------- TextField EndEditing -------- //


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self searchEvent];
    return true;
}

-(void)keyBoardDown{
    
    [searchMsg resignFirstResponder];
    [self.view removeGestureRecognizer:tap];    
}


#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        EduViewController *eduView = [[EduViewController alloc]init];
        
        if (buttonIndex == 1) {
            NSLog(@"틀린 단어");
            [eduView setVocaArray:[dbMsg searchVoca:@"" :0 :2]];
        }else if(buttonIndex == 0){
            NSLog(@"필수 영단어");
            [eduView setVocaArray:[dbMsg getVocaData:0 :0]];
//            [eduView setVocaArray:[dbMsg searchVoca:@"" :0 :0]];
//            [eduView setVocaArray:vArray];
        }else if(buttonIndex == 2){
            NSLog(@"단어");
            [eduView setVocaArray:[dbMsg getVocaData:1:0]];
        }else if(buttonIndex == 3){
            NSLog(@"숙어");
            [eduView setVocaArray:[dbMsg getVocaData:2:0]];
        }
        
        [self presentModalViewController:eduView animated:YES];
    }
}

#pragma mark UITabber Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    
    switch ([item tag] ) {
        case 0:
            type = 0;
            check = 3;
            break;
        case 1:
            type = 0;
            check = 1;
            break;
        case 2:
            type = 0;
            check = 2;

            break;
        case 3:
            type = 1;
            check = 3;

            break;
        case 4:
            type = 2;
            check = 3;

            break;
        default:
            break;
    }
    
    [self tableReload];
    [vocaTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    lblTitle.text = [item title];
}

// --------------- TableView 에서 해당 항목 swipe --------------- //
/* -----------------------------------------------------------
 해당 셀의 EditingStyle을 Delete Style로 설정
 ----------------------------------------------------------- */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (check == 1) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// ------------------- EdittingStyle Event ------------------- //
/* -----------------------------------------------------------
 Editing 상태일때 삭제 버튼을 누를경우 해당 메시지를 삭제
 ----------------------------------------------------------- */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    int section = [indexPath section];
    
    if (index == 0) {
        [dbMsg setVocaCheck:[[vArray[section] objectAtIndex:3] intValue] :0];
    }else {
        [dbMsg setVocaCheck: [[vArray[section] objectAtIndex:index * 4 + 3] intValue]:0];
    }
    
    [self tableReload];
}


- (void)tableReload{
    int count = 0;
    
    if (check == 2) {
        xArray = [dbMsg searchVoca:@"" :type :check];

    }else {
    [muArray removeAllObjects];
    
    for (int i = 0; i < [[collation sectionIndexTitles] count] - 1; i++) {
        
        if ([dbMsg searchVoca:[[collation sectionIndexTitles] objectAtIndex:i] :type :check].count != 0) {
            
            vArray[count] = [dbMsg searchVoca:[[collation sectionIndexTitles] objectAtIndex:i] :type :check];
        [muArray insertObject:[[collation sectionIndexTitles] objectAtIndex:i] atIndex:count];
        count++;
        }
    }
    }
    [vocaTable reloadData];

}

- (void)viewDidUnload {
    vocaTable = nil;
    searchMsg = nil;
    tabbalContoller = nil;
    item01 = nil;
    [super viewDidUnload];
}
@end
