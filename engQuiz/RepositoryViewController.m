//
//  RepositoryViewController.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 10. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "RepositoryViewController.h"
#import "SentenceViewController.h"

@interface RepositoryViewController ()

@end

@implementation RepositoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dbMsg = [DataBase getInstance];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [tabbar setSelectedItem:item01];
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

#pragma mark UITabber Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{    
    switch ([item tag] ) {
        case 0:
            type = 1;
            break;
        case 1:
            type = 2;
            break;
        default:
            break;
    }
    
    lblTitle.text = [item title];
    
    
    [self reLoadTable];
}

- (void)reLoadTable{
    
//    if(rAndi.selectedSegmentIndex == 0)
//        type = 1;
//    if(rAndi.selectedSegmentIndex == 1)
//        type = 2;

//    tabbar.selectedItem =
    
    
    if (type == 0) {
        type = 1;
    }
    
    rArray = [dbMsg getRSentenceData:type];
    cellCount = rArray.count/3;
    
    NSLog(@"count :::  %d selected ::: %d",rArray.count, type);
    [rTableView reloadData];
}

- (IBAction)segmentedselectedEvent:(id)sender {
    [self reLoadTable];
}


#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int index = [indexPath row];
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    

    if (index == 0) {
        cell.textLabel.text = [rArray objectAtIndex:1];
    }else {
        cell.textLabel.text = [rArray objectAtIndex:(index * 3) + 1];
    }
    
    return cell;
}




// ---------------- Section Count Setting ---------------- //

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return cellCount;
}



// ---------------- Cell Select Event ---------------- //


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int index = [indexPath row];
    
    SentenceViewController *sentenceVeiw = [[SentenceViewController alloc]init];
    
    if (index == 0) {
        [sentenceVeiw setInit:@"보관함":[rArray objectAtIndex:1]:type:[[rArray objectAtIndex:0] intValue]];
        NSLog(@"%@",[rArray objectAtIndex:0]);
    }else {
        [sentenceVeiw setInit:@"보관함":[rArray objectAtIndex:(index * 3) + 1]:type:[[rArray objectAtIndex:(index * 3)] intValue]];
        
        NSLog(@"%@",[rArray objectAtIndex:(index * 3)]);
//        NSLog(@"%d",rArray.count);
    }
    
    [self presentModalViewController:sentenceVeiw animated:YES];
}


// --------------- TableView 에서 해당 항목 swipe --------------- //
/* -----------------------------------------------------------
 해당 셀의 EditingStyle을 Delete Style로 설정
 ----------------------------------------------------------- */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// ------------------- EdittingStyle Event ------------------- //
/* -----------------------------------------------------------
 Editing 상태일때 삭제 버튼을 누를경우 해당 메시지를 삭제
 ----------------------------------------------------------- */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    if (index == 0) {
        [dbMsg deleteRdata:[[rArray objectAtIndex:0] intValue]];
    }else {
        [dbMsg deleteRdata:[[rArray objectAtIndex:(index * 3)] intValue]];
    }
    
    [self reLoadTable];
}



- (void)viewDidUnload {
    rTableView = nil;
//    rAndi = nil;
    tabbar = nil;
    item01 = nil;
    item02 = nil;
    [super viewDidUnload];
}
@end
