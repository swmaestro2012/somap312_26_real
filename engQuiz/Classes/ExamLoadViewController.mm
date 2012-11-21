//
//  ExamLoadViewController.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 10. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "ExamLoadViewController.h"
#import "SentenceViewController.h"
#import "ThemeCell.h"
//#import "ExViewController.h"
//#import "ViewController.h"
#import "OcrResultCheckViewController.h"


#define BookTableTag 1
#define ChapterTableTag 2
#define ThemeTableTag 3


#define PublicTag 11
#define Class1Tag 12
#define Class2Tag 13


@interface ExamLoadViewController ()

@end

@implementation ExamLoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dbMsg = [DataBase getInstance];
        bCell = [[BookListCell alloc]init];
        pArray = [dbMsg getPublisherIds];
        imgArray = [NSMutableArray arrayWithCapacity:0];
        imgViewArray = [NSMutableArray arrayWithCapacity:0];
        btnArray = [NSMutableArray arrayWithCapacity:0];
        gArray = [NSMutableArray arrayWithCapacity:0];
        groupCountArray = [NSMutableArray arrayWithCapacity:0];
        
//        cNumber = [dbMsg getStteingData] + 1;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bookTableReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableInit) name:@"bookTableReload" object:nil];
    
    [self setScrollViewInit];
    [scrollView setHidden:YES];
    
    bookNumber = 0;
    chapterNumber = 0;
    pNumber = 0;
    cNumber = [dbMsg getStteingData] + 1;

    [self setClassNameData:cNumber];
    
    [self setTableInit];
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

-(void)setClassNameData:(int)c{
    switch (c) {
        case 0:
            [className setTitle: @"전체" forState:UIControlStateNormal];
            break;
        case 1:
            [className setTitle: @"중학교" forState:UIControlStateNormal];
            break;
        case 2:
            [className setTitle: @"고등학교" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
}

- (void)setScrollViewInit{
    NSMutableArray *views = [[NSMutableArray alloc]init];
    
    [views addObject:bookTable];
    [views addObject:chapterTable];
    [views addObject:themeTable];
    
    for (int index = 0; index < views.count; index++) {
        CGRect frame;
        frame.origin.x = scrollView.frame.size.width * index;
        frame.origin.y = 0;
        frame.size = scrollView.frame.size;
        
        UITableView *subTableView = [[UITableView alloc] initWithFrame:frame];
        subTableView = [views objectAtIndex:index];
        
        [subTableView setFrame:frame];
        
        [scrollView addSubview:subTableView];
    }
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(0, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    [scrollView setContentOffset:CGPointMake(0,0) animated:NO];
    
    
    rootLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, naviScroll.frame.size.height)];
    
    rootLabel.text = @">";
    
    [rootLabel sizeToFit];
    [naviScroll addSubview:rootLabel];

}

- (IBAction)publisherSelect:(id)sender {
    alert = [[UIAlertView alloc] initWithTitle:@"출판사"
                                       message:@"\n\n\n\n\n\n\n"
                                      delegate:nil
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:nil, nil];
    
    UITableView *myView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 264, 150)];
    
    myView.tag = PublicTag;
    myView.delegate = self;
    myView.dataSource = self;
    [alert addSubview:myView];
    
    [alert setAutoresizesSubviews:YES];
    
    [alert show];
}

- (IBAction)classSelect:(id)sender {
    alert = [[UIAlertView alloc] initWithTitle:@"학교"
                                       message:@"\n\n\n\n\n\n\n"
                                      delegate:nil
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:nil, nil];
    
    UITableView *myView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 264, 150)];
    
    myView.tag = Class1Tag;
    myView.delegate = self;
    myView.dataSource = self;
    [alert addSubview:myView];
    
    [alert show];
}

- (IBAction)numberSelect:(id)sender {
    alert = [[UIAlertView alloc] initWithTitle:@"학년"
                                       message:@"\n\n\n\n\n\n\n"
                                      delegate:nil
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:nil, nil];
    
    UITableView *myView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 264, 150)];
    
    myView.tag = Class2Tag;
    myView.delegate = self;
    myView.dataSource = self;
    [alert addSubview:myView];
    
    [alert show];
}

- (IBAction)addSentence:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"취소"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"사진 촬영", @"앨범에서 가져오기",@"지문 입력하기",@"파일 불러오기", nil];
    [actionsheet showInView:self.view];
}


#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int index = [indexPath row];
    int section = [indexPath section];
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (tableView.tag == BookTableTag) {
        if (pNumber == 0) {
            if (section == pArray.count) {
                int poz = (index + section - pArray.count);
                if (poz == 0) {
                    if (![[gArray objectAtIndex:3]isEqualToString:@""]) {
                        cell.textLabel.text = [gArray objectAtIndex:3];
                    }else{
                        cell.textLabel.text = [gArray objectAtIndex:1];
                    }
                }else {
                    if (![[gArray objectAtIndex:poz * 4 + 3]isEqualToString:@""]) {
                        cell.textLabel.text = [gArray objectAtIndex:poz * 4 + 3];
                    }else{
                        cell.textLabel.text = [gArray objectAtIndex:poz * 4 + 1];
                    }
                    
                }
            }else if (section > pArray.count) {
                int poz = 0;
                for (int i = 0; i < section - pArray.count; i++) {
                    poz = poz + [[groupCountArray objectAtIndex:i]intValue] / 4;
                }
                if (![[gArray objectAtIndex:poz * 4 + 3]isEqualToString:@""]) {
                    cell.textLabel.text = [gArray objectAtIndex:(poz + index) * 4 + 3];
                }else{
                    cell.textLabel.text = [gArray objectAtIndex:(poz + index) * 4 + 1];
                }
            }else if ([dbMsg getBookIds:section+1:cNumber:sNumber].count != 0) {
                cell.textLabel.text = [dbMsg getBookName:[[[dbMsg getBookIds:section+1:cNumber:sNumber] objectAtIndex:index]integerValue]];
                
            }
        }else if(pNumber == pArray.count + 1){
            if (section == 0) {
                if (index == 0) {
                    if (![[gArray objectAtIndex:3]isEqualToString:@""]) {
                        cell.textLabel.text = [gArray objectAtIndex:3];
                    }else{
                        cell.textLabel.text = [gArray objectAtIndex:1];
                    }
                }else {
                    if (![[gArray objectAtIndex:index * 4 + 3]isEqualToString:@""]) {
                        cell.textLabel.text = [gArray objectAtIndex:index * 4 + 3];
                    }else{
                        cell.textLabel.text = [gArray objectAtIndex:index * 4 + 1];
                    }
                    
                }
            }else {
                int poz = 0;
                for (int i = 0; i < section ; i++) {
                    poz = poz + [[groupCountArray objectAtIndex:i]intValue] / 4;
                }
                if (![[gArray objectAtIndex:poz * 4 + 3]isEqualToString:@""]) {
                    cell.textLabel.text = [gArray objectAtIndex:poz * 4 + 3];
                }else{
                    cell.textLabel.text = [gArray objectAtIndex:poz * 4 + 1];
                }
            }
        }else {
            cell.textLabel.text = [dbMsg getBookName:[[bArray objectAtIndex:index]integerValue]];
        }
        
    }
    
    else if (tableView.tag == ChapterTableTag) {
        if (index == 0) {
            cell.textLabel.text = [cArray objectAtIndex:1];
        }else {
            cell.textLabel.text = [cArray objectAtIndex:index * 2 + 1];
        }
    }
    
    else if (tableView.tag == ThemeTableTag) {
        if (index == 0) {
            cell.textLabel.text = [tArray objectAtIndex:1];
        }else {
            cell.textLabel.text = [tArray objectAtIndex:index * 3 + 1];
        }
    }
    
    else if (tableView.tag == PublicTag) {
        if (index == 0) {
            cell.textLabel.text = @"전체";
        }else if(index - 1 < pArray.count){
            cell.textLabel.text = [dbMsg getPublisherName:[[pArray objectAtIndex:index-1]integerValue]];
        }else{
            cell.textLabel.text = @"등록한 자료";
        }
    }
    
    else if (tableView.tag == Class1Tag) {
        
        switch (index) {
                
            case 0:
                cell.textLabel.text = @"전체";
                break;
            case 1:
                cell.textLabel.text = @"중학교";
                break;
                
            case 2:
                cell.textLabel.text = @"고등학교";
                break;
                
            default:
                break;
        }
    }
    
    else if (tableView.tag == Class2Tag) {
        
        switch (index) {
            case 0:
                cell.textLabel.text = @"전체";
                break;
                
            case 1:
                cell.textLabel.text = @"1 학년";
                break;
                
            case 2:
                cell.textLabel.text = @"2 학년";
                break;
                
            case 3:
                cell.textLabel.text = @"3 학년";
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}




// ---------------- Cell Count Setting ---------------- //

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    return tableCellCount;
    if (tableView.tag == PublicTag) {
        return pArray.count + 2;
    }else if (tableView.tag == Class1Tag) {
        return 3;
    }else if (tableView.tag == Class2Tag) {
        return 4;
    }else if ( tableView.tag == BookTableTag) {
        if (pNumber == 0) {
            
            if (section >= pArray.count){
                return [[groupCountArray objectAtIndex:section - pArray.count]intValue] / 4;

            }else if ([dbMsg getBookIds:section+1:cNumber:sNumber].count == 0) {
//                return 1;
                return 0;
            }
            return [dbMsg getBookIds:section+1:cNumber:sNumber].count;
        }else if(pNumber == pArray.count + 1){
            return [[groupCountArray objectAtIndex:section]intValue] / 4;
        }else{
            return bArray.count;
        }
    }else if ( tableView.tag == ChapterTableTag) {
        return cArray.count / 2;
    }else if ( tableView.tag == ThemeTableTag) {
        return tArray.count / 3;
    }
    
    return 0;
}



// ---------------- Cell Select Event ---------------- //


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int index = [indexPath row];
    int section = [indexPath section];
    
    if (tableView.tag == BookTableTag) {
        if (bookNumber == index + 1) {
            [cArray removeAllObjects];
            [self tableRePoz:2];
        }else{
            
            if (pNumber == 0) {
                if (section == pArray.count) {
                    int poz = (index + section - pArray.count);
                    SentenceViewController *sentenceVeiw = [[SentenceViewController alloc]init];
                    
                    if (poz == 0) {
                        [sentenceVeiw setInit:@"기타":[gArray objectAtIndex:1]:0:[[gArray objectAtIndex:0]intValue]];
                    }else {
                        [sentenceVeiw setInit:@"기타":[gArray objectAtIndex:poz *4 + 1]:0:[[gArray objectAtIndex:poz *4]intValue]];
                    }
                    
                    [self presentModalViewController:sentenceVeiw animated:YES];
                }else if (section > pArray.count) {
                    int poz = 0;
                    for (int i = 0; i < section - pArray.count; i++) {
                        poz = poz + [[groupCountArray objectAtIndex:i]intValue] / 4;
                    }
                    SentenceViewController *sentenceVeiw = [[SentenceViewController alloc]init];

                    [sentenceVeiw setInit:@"기타":[gArray objectAtIndex:(poz + index) *4 + 1]:0:0];
                    [self presentModalViewController:sentenceVeiw animated:YES];

                }else if ([dbMsg getBookIds:section+1:cNumber:sNumber].count != 0) {
                    bookNumber = index + 1;
                    [cArray removeAllObjects];
                    cArray = [dbMsg getChapterData:[[[dbMsg getBookIds:section+1:cNumber:sNumber] objectAtIndex:index]integerValue]];
                    
                    if (cArray.count != 0) {
                    }else{
                        [self tableRePoz:2];
                    }
                    
                    if (naviButton[0] != nil) {
                        [naviButton[0] removeFromSuperview];
                        naviButton[0] = nil;
                    }
                    
                    if (naviLabel[0] != nil) {
                        [naviLabel[0] removeFromSuperview];
                        naviLabel[0] = nil;
                    }
                    
                    if (naviButton[1] != nil) {
                        [naviButton[1] removeFromSuperview];
                        naviButton[1] = nil;
                    }
                    
                    if (naviLabel[1] != nil) {
                        [naviLabel[1] removeFromSuperview];
                        naviLabel[1] = nil;
                    }
                    
                    
                    naviButton[0] = [UIButton buttonWithType:UIButtonTypeCustom];
                    [naviButton[0] setFrame:CGRectMake(rootLabel.frame.origin.x + rootLabel.frame.size.width + 10, 0, 10, naviScroll.frame.size.height)];
                    [naviButton[0] setTitle:[dbMsg getBookName:[[bArray objectAtIndex:index]integerValue]] forState:UIControlStateNormal];
                    [naviButton[0] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [naviButton[0] sizeToFit];
                    naviButton[0].tag = 0;
                    [naviButton[0] addTarget:self action:@selector(naviButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
                    
                    naviLabel[0] = [[UILabel alloc]initWithFrame:CGRectMake(naviButton[0].frame.origin.x + naviButton[0].frame.size.width + 10, 0, 10, naviScroll.frame.size.height)];
                    
                    naviLabel[0].text = @">";
                    
                    [naviLabel[0] sizeToFit];
                    [naviScroll addSubview:naviButton[0]];
                    [naviScroll addSubview:naviLabel[0]];
                    
                    naviScroll.contentSize = CGSizeMake(naviLabel[0].frame.origin.x + naviLabel[0].frame.size.width, 0);
                    
                    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
                    
                    [chapterTable reloadData];

                }
            }else if(pNumber == pArray.count + 1){
                SentenceViewController *sentenceVeiw = [[SentenceViewController alloc]init];
                
                if (section == 0) {
                    if (index == 0) {
                        [sentenceVeiw setInit:@"기타":[gArray objectAtIndex:1]:0:[[gArray objectAtIndex:1] intValue]];
                    }else {
                        [sentenceVeiw setInit:@"기타":[gArray objectAtIndex:index *4 + 1]:0:[[gArray objectAtIndex:index *4] intValue]];
                        
                    }
                }else {
                    int poz = 0;
                    for (int i = 0; i < section ; i++) {
                        poz = poz + [[groupCountArray objectAtIndex:i]intValue] / 4;
                    }
                    [sentenceVeiw setInit:@"기타":[gArray objectAtIndex:poz *4 + 1]:0:[[gArray objectAtIndex:poz *4]intValue]];
                }
                
                [self presentModalViewController:sentenceVeiw animated:YES];
            }else {
                bookNumber = index + 1;
                [cArray removeAllObjects];
                cArray = [dbMsg getChapterData:[[bArray objectAtIndex:index]integerValue]];
                
                if (cArray.count != 0) {
                }else{
                    [self tableRePoz:2];
                }
                
                if (naviButton[0] != nil) {
                    [naviButton[0] removeFromSuperview];
                    naviButton[0] = nil;
                }
                
                if (naviLabel[0] != nil) {
                    [naviLabel[0] removeFromSuperview];
                    naviLabel[0] = nil;
                }
                
                if (naviButton[1] != nil) {
                    [naviButton[1] removeFromSuperview];
                    naviButton[1] = nil;
                }
                
                if (naviLabel[1] != nil) {
                    [naviLabel[1] removeFromSuperview];
                    naviLabel[1] = nil;
                }
                
                
                naviButton[0] = [UIButton buttonWithType:UIButtonTypeCustom];
                [naviButton[0] setFrame:CGRectMake(rootLabel.frame.origin.x + rootLabel.frame.size.width + 10, 0, 10, naviScroll.frame.size.height)];
                [naviButton[0] setTitle:[dbMsg getBookName:[[bArray objectAtIndex:index]integerValue]] forState:UIControlStateNormal];
                [naviButton[0] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [naviButton[0] sizeToFit];
                naviButton[0].tag = 0;
                [naviButton[0] addTarget:self action:@selector(naviButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
                
                naviLabel[0] = [[UILabel alloc]initWithFrame:CGRectMake(naviButton[0].frame.origin.x + naviButton[0].frame.size.width + 10, 0, 10, naviScroll.frame.size.height)];
                
                naviLabel[0].text = @">";
                
                [naviLabel[0] sizeToFit];
                [naviScroll addSubview:naviButton[0]];
                [naviScroll addSubview:naviLabel[0]];
                
                naviScroll.contentSize = CGSizeMake(naviLabel[0].frame.origin.x + naviLabel[0].frame.size.width, 0);
                
                [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
                
                [chapterTable reloadData];

            }
        }
        if (cArray.count != 0){
            [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width,0) animated:YES];
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, 0);
        }else {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 1, 0);
        }
    }else if ( tableView.tag == ChapterTableTag) {
        if (chapterNumber == index + 1) {
            [tArray removeAllObjects];
            [self tableRePoz:1];
        }else{
            chapterNumber = index + 1;
            [tArray removeAllObjects];
            
            tArray = [dbMsg getThemeData:[[cArray objectAtIndex:index*2]integerValue]];
            
//            NSLog(@" count :: %d",tArray.count);
            
            if (tArray.count != 0) {
                [themeTable setHidden:NO];
            }else{
                [self tableRePoz:1];
            }
            
            
            if (naviButton[1] != nil) {
                [naviButton[1] removeFromSuperview];
                naviButton[1] = nil;
            }
            
            if (naviLabel[1] != nil) {
                [naviLabel[1] removeFromSuperview];
                naviLabel[1] = nil;
            }
            
            naviButton[1] = [UIButton buttonWithType:UIButtonTypeCustom];
            [naviButton[1] setFrame:CGRectMake(naviLabel[0].frame.origin.x + naviLabel[0].frame.size.width + 10, 0, 10, naviScroll.frame.size.height)];
            [naviButton[1] setTitle:[cArray objectAtIndex:index * 2 + 1] forState:UIControlStateNormal];
            [naviButton[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [naviButton[1] sizeToFit];
            
            naviButton[1].tag = 1;
            [naviButton[1] addTarget:self action:@selector(naviButtonEvent:) forControlEvents:UIControlEventTouchUpInside];

            
            naviLabel[1] = [[UILabel alloc]initWithFrame:CGRectMake(naviButton[1].frame.origin.x + naviButton[1].frame.size.width + 10, 0, 10, naviScroll.frame.size.height)];
            
            naviLabel[1].text = @">";
            
            [naviLabel[1] sizeToFit];
            [naviScroll addSubview:naviButton[1]];
            [naviScroll addSubview:naviLabel[1]];
            
            naviScroll.contentSize = CGSizeMake(naviLabel[1].frame.origin.x + naviLabel[1].frame.size.width + naviScroll.frame.size.width -naviButton[1].frame.origin.x - naviLabel[1].frame.size.width, 0);
            [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width,0) animated:YES];
            [naviScroll setContentOffset:CGPointMake(naviButton[1].frame.origin.x,0) animated:YES];

            
            [themeTable reloadData];
        }
        if (tArray.count != 0){
            [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * 2,0) animated:YES];
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, 0);
        }else {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, 0);
        }
    }else if ( tableView.tag == ThemeTableTag){
        SentenceViewController *sentenceVeiw = [[SentenceViewController alloc]init];
        
        if (index == 0) {
            [sentenceVeiw setInit:[dbMsg getBookName:[[bArray objectAtIndex:bookNumber - 1]integerValue]]:[tArray objectAtIndex:2]:0:[[tArray objectAtIndex:0]intValue]];
//            /////////
        }else {
            [sentenceVeiw setInit:[dbMsg getBookName:[[bArray objectAtIndex:bookNumber - 1]integerValue]]:[tArray objectAtIndex:index * 3 + 2]:0:[[tArray objectAtIndex:index*3]intValue]];
        }
        
        [self presentModalViewController:sentenceVeiw animated:YES];
    }
    else{
        if (tableView.tag == PublicTag) {
            if (index == 0) {
                pNumber = index;
                [publisherName setTitle: @"전체" forState:UIControlStateNormal];
                
            }else if(index - 1 < pArray.count){
                pNumber = [[pArray objectAtIndex:index-1]integerValue];
                [publisherName setTitle:[dbMsg getPublisherName:pNumber] forState:UIControlStateNormal];
            }else {
                pNumber = index;
                [publisherName setTitle:@"등록한 자료" forState:UIControlStateNormal];

            }
            scrollView.contentSize = CGSizeMake(0, 0);
            [scrollView setContentOffset:CGPointMake(0,0) animated:NO];
            for (int i = 0 ; i < 2; i++) {
                [naviButton[i] removeFromSuperview];
                [naviLabel[i] removeFromSuperview];
                
                naviButton[i] = nil;
                naviLabel[i] = nil;
            }
            naviScroll.contentSize = CGSizeMake(0, 0);
            [naviScroll setContentOffset:CGPointMake(0,0) animated:YES];

        }
        
        else if (tableView.tag == Class1Tag) {
            
            switch (index) {
                case 0:
                    cNumber = index;
                    [className setTitle: @"전체" forState:UIControlStateNormal];
                    break;
                    
                case 1:
                    cNumber = index;
                    [className setTitle: @"중학교" forState:UIControlStateNormal];
                    break;
                    
                case 2:
                    cNumber = index;
                    [className setTitle: @"고등학교" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            scrollView.contentSize = CGSizeMake(0, 0);
            [scrollView setContentOffset:CGPointMake(0,0) animated:NO];
            
            for (int i = 0 ; i < 2; i++) {
                [naviButton[i] removeFromSuperview];
                [naviLabel[i] removeFromSuperview];
                
                naviButton[i] = nil;
                naviLabel[i] = nil;
            }
            naviScroll.contentSize = CGSizeMake(0, 0);
            [naviScroll setContentOffset:CGPointMake(naviScroll.frame.size.width,0) animated:YES];

        }
        [self disAlert];
    }
}

- (void)tableRePoz:(int)type{
    switch (type) {
        case 0:
            bookNumber = 0;
            break;
        case 1:
            chapterNumber = 0;
            break;
        case 2:
            bookNumber = 0;
            chapterNumber = 0;
            break;
        default:
            break;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView.tag == BookTableTag){
        if (pNumber == 0) {
            return pArray.count + groupArray.count;
        }else if(pNumber == pArray.count + 1) {
            return groupArray.count;
        }
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == BookTableTag) {
        if(pNumber == pArray.count + 1){
            if ([[groupArray objectAtIndex:section]isEqualToString:@""]) {
                return @"기타";
            }
            return [groupArray objectAtIndex:section];
        }else{
            if (section >= pArray.count) {
                if ([[groupArray objectAtIndex:section - pArray.count]isEqualToString:@""]) {
                    return @"기타";
                }
                return [groupArray objectAtIndex:section - pArray.count];
            }else{
                return [dbMsg getPublisherName:[[pArray objectAtIndex:section]integerValue]];
            }
        }
    }
    return nil;
}

- (void)disAlert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    bookNumber = 0;
    chapterNumber = 0;
    
    if (pNumber != pArray.count + 1) {
        bArray = [dbMsg getBookIds:pNumber:cNumber:sNumber];
        tableCellCount = bArray.count;
        if (bArray.count != 0)
            [scrollView setHidden:NO];
        else
            [scrollView setHidden:YES];
    }else{
        [scrollView setHidden:NO];
    }
    
    
    [bookTable reloadData];
}
             
- (void)naviButtonEvent:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            naviScroll.contentSize = CGSizeMake(naviLabel[0].frame.origin.x + naviLabel[0].frame.size.width, 0);
            [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
            if (naviButton[1] != nil) {
                [naviButton[1] removeFromSuperview];
                naviButton[1] = nil;
            }

            
            if (naviLabel[1] != nil) {
                [naviLabel[1] removeFromSuperview];
                naviLabel[1] = nil;
            }
            
            [themeTable reloadData];
            [chapterTable reloadData];

            break;
        case 1:
            naviScroll.contentSize = CGSizeMake(naviLabel[1].frame.origin.x + naviLabel[1].frame.size.width, 0);
            [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width,0) animated:YES];
            break;
            
        default:
            break;
    }
}


// --------------- TableView 에서 해당 항목 swipe --------------- //
/* -----------------------------------------------------------
 해당 셀의 EditingStyle을 Delete Style로 설정
 ----------------------------------------------------------- */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    
    if (pNumber == 0) {
        if (section >= pArray.count) {
            return UITableViewCellEditingStyleDelete;
        }
    }else if(pNumber == pArray.count+1){
        return UITableViewCellEditingStyleDelete;
    }
    return nil;
}

// ------------------- EdittingStyle Event ------------------- //
/* -----------------------------------------------------------
 Editing 상태일때 삭제 버튼을 누를경우 해당 메시지를 삭제
 ----------------------------------------------------------- */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int index = [indexPath row];

    
    NSArray *xib = [[NSBundle mainBundle]  loadNibNamed:@"EditThemeAndGroup" owner:self options:nil];
    editView = (EditThemeAndGroup *)[xib objectAtIndex:0];
    
    [editView setFrame:CGRectMake(0, 0, 320, 460)];
    
    [editView awakeFromNib];
    
    
    if (pNumber == 0) {
        if (section == pArray.count) {
            int poz = (index + section - pArray.count);
//            [dbMsg deleteInsertSentence:[[gArray objectAtIndex:poz *4] intValue]];
            [self setPoz:poz * 4];

        }else if (section > pArray.count) {
            int poz = 0;
            for (int i = 0; i < section - pArray.count; i++) {
                poz = poz + [[groupCountArray objectAtIndex:i]intValue] / 4;
            }
            [self setPoz:poz * 4];
//            [dbMsg deleteInsertSentence:[[gArray objectAtIndex:poz *4] intValue]];
        }
//        [self setTableInit];

        [editView.groupLabel setText:[NSString stringWithFormat:@"%@",[groupArray objectAtIndex:section - pArray.count]]];

    }else if(pNumber == pArray.count + 1){
        
        if (section == 0) {
//            [dbMsg deleteInsertSentence:[[gArray objectAtIndex:index *4] intValue]];
            [self setPoz:index * 4];

        }else {
            int poz = 0;
            for (int i = 0; i < section ; i++) {
                poz = poz + [[groupCountArray objectAtIndex:i]intValue] / 4;
            }
//            [dbMsg deleteInsertSentence:[[gArray objectAtIndex:poz *4] intValue]];
            [self setPoz:poz * 4];
        }
        [editView.groupLabel setText:[NSString stringWithFormat:@"%@",[groupArray objectAtIndex:section]]];

//        [self tableReload];
    }
    
    [editView.cancelBtn addTarget:self action:@selector(cancelBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [editView.delBtn addTarget:self action:@selector(deleteSentence) forControlEvents:UIControlEventTouchUpInside];
    [editView.editBtn addTarget:self action:@selector(updateThemeGroup) forControlEvents:UIControlEventTouchUpInside];
    [editView.themeLabel setDelegate:editView];
    [editView.groupLabel setDelegate:editView];
    
    [editView.themeLabel setText:[NSString stringWithFormat:@"%@",[gArray objectAtIndex:delPoz + 3]]];
    
    [self.view addSubview:editView];

}

-(void)cancelBtnEvent{
    [editView removeFromSuperview];
}

-(void)updateThemeGroup{
    [dbMsg updateThemeAndGroup:[[gArray objectAtIndex:delPoz] intValue] Theme:editView.themeLabel.text Group:editView.groupLabel.text];
    
    NSLog(@"%@ , %@",editView.themeLabel.text , editView.groupLabel.text);
    
    if (pNumber == 0) {
        [self setTableInit];
    }else {
        [self tableReload];
    }
    
    [editView removeFromSuperview];

}

- (void)setPoz:(int)poz{
    delPoz = poz;
}

- (void)deleteSentence{
    [dbMsg deleteInsertSentence:[[gArray objectAtIndex:delPoz] intValue]];
    
    if (pNumber == 0) {
        [self setTableInit];
    }else {
        [self tableReload];
    }
    
    [editView removeFromSuperview];
}

#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"사진 찍기");
        
        [imgArray removeAllObjects];
        [imgViewArray removeAllObjects];
        [btnArray removeAllObjects];
        
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;

        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        NSArray *xibs = [[NSBundle mainBundle]  loadNibNamed:@"Camera" owner:self options:nil];
        cameraOverView = (Camera *)[xibs objectAtIndex:0];

        imagePickerController.allowsEditing=NO;
        imagePickerController.showsCameraControls = NO;
        imagePickerController.cameraViewTransform = CGAffineTransformScale(imagePickerController.cameraViewTransform,1, 1);
        
        
        
        imagePickerController.cameraOverlayView = cameraOverView;
        
        [cameraOverView.cancelBtn addTarget:self action:@selector(closeCamer:) forControlEvents:UIControlEventTouchUpInside];
        [cameraOverView.takePicture addTarget:self action:@selector(tookPicture:) forControlEvents:UIControlEventTouchUpInside];
        [cameraOverView.doneBtn addTarget:self action:@selector(cameraDone:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        NSArray *xib = [[NSBundle mainBundle]  loadNibNamed:@"ImgSelectedOverView" owner:self options:nil];
        selectedOverView = (ImgSelectedOverView *)[xib objectAtIndex:0];
        
        [selectedOverView setFrame:CGRectMake(0, self.view.frame.size.height - 20, self.view.frame.size.width, 120)];
        
        [selectedOverView awakeFromNib];
        
        [imagePickerController.view setFrame:CGRectMake(0, 0, imagePickerController.view.frame.size.width, imagePickerController.view.frame.size.height - 120 - 20)];
        
        [selectedOverView.doneBtn addTarget:self action:@selector(imageOcr) forControlEvents:UIControlEventTouchUpInside];
        [selectedOverView.upAndDownBtn addTarget:self action:@selector(menuUpDown) forControlEvents:UIControlEventTouchUpInside];
        
        [imagePickerController.view addSubview:selectedOverView];
        
        [self setPanGestuer];
        
//        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280, 340)];
//        [view setBackgroundColor:[UIColor blackColor]];
//        
//        [imagePickerController.view addSubview:view];

        
        
        [self presentModalViewController:imagePickerController animated:NO];
        
    }else if(buttonIndex == 1){
        NSLog(@"앨범에서 불러오기");
        
        if (imagePickerController != nil) {
            imagePickerController = nil;
            [imagePickerController removeFromParentViewController];
        }
        
        if (selectedOverView != nil) {
            selectedOverView = nil;
            [selectedOverView removeFromSuperview];
        }
        
        [imgArray removeAllObjects];
        [imgViewArray removeAllObjects];
        [btnArray removeAllObjects];

        
        imagePickerController = [[UIImagePickerController alloc] init];

        imagePickerController.delegate = self;
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        
        NSArray *xibs = [[NSBundle mainBundle]  loadNibNamed:@"ImgSelectedOverView" owner:self options:nil];
        selectedOverView = (ImgSelectedOverView *)[xibs objectAtIndex:0];
        
        [selectedOverView setFrame:CGRectMake(0, self.view.frame.size.height - 20, self.view.frame.size.width, 120)];

        [selectedOverView awakeFromNib];
        
        [imagePickerController.view setFrame:CGRectMake(0, 0, imagePickerController.view.frame.size.width, imagePickerController.view.frame.size.height - 120 - 20)];
        
        [selectedOverView.doneBtn addTarget:self action:@selector(imageOcr) forControlEvents:UIControlEventTouchUpInside];
        [selectedOverView.upAndDownBtn addTarget:self action:@selector(menuUpDown) forControlEvents:UIControlEventTouchUpInside];
        
        [imagePickerController.view addSubview:selectedOverView];

        [self setPanGestuer];
        
        [self presentModalViewController:imagePickerController animated:YES];
        
    }else if(buttonIndex == 2){
        NSLog(@"지문 입력하기");
        
        if (textPasteView != nil) {
            [textPasteView removeFromParentViewController];
            textPasteView = nil;
        }
        
        textPasteView = [[TextPasteViewController alloc]init];
        
        [self presentModalViewController:textPasteView animated:YES];
    }else if(buttonIndex == 3){
        NSLog(@"파일 불러오기");
        
        if (textLoadView != nil) {
            [textLoadView removeFromParentViewController];
            textLoadView = nil;
        }
        textLoadView = [[TextFileLoadViewController alloc]init];
        
        [self presentModalViewController:textLoadView animated:YES];
    }
}

// 사진 고르기 취소
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

// 사진 찍기 취소
- (IBAction)closeCamer:(id)sender {
    [imagePickerController dismissModalViewControllerAnimated:YES];
}


// 사진 찍기 버튼 눌렀을 때
- (IBAction)tookPicture:(id)sender {
    [imagePickerController takePicture];
    //    SJ_DEBUG_LOG(@"Take Picture");
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        float resizeRatio_x = 1000 / image.size.width ;
        UIImage *smallImage = [self imageWithImage:image scaledToSize:CGSizeMake(1000, image.size.height*resizeRatio_x)];
        
        [imgArray insertObject:smallImage atIndex:imgArray.count];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:smallImage];
        
        [imageView setFrame:CGRectMake((imgArray.count - 1) * 123, 0, 123, 100)];
        imageView.tag = imgArray.count-1;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake((imgArray.count - 1) * 123, 0, 123, 100)];
        btn.tag = imgArray.count-1;
        
        [btn addTarget:self action:@selector(imageDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        [imgViewArray insertObject:imageView atIndex:imgViewArray.count];
        [btnArray insertObject:btn atIndex:btnArray.count];
        
        imageView = nil;
        btn = nil;
        
        [selectedOverView.selectedScrollView addSubview:[imgViewArray objectAtIndex:imgViewArray.count-1]];
        [selectedOverView.selectedScrollView addSubview:[btnArray objectAtIndex:btnArray.count-1]];
        
        [selectedOverView.selectedScrollView setContentSize:CGSizeMake(imgArray.count * 123, 0)];
        
        menuState = false;
        [self menuUpDown];
    }else {
        
        [imgArray insertObject:[self cropImage:image:cameraOverView.cropView] atIndex:imgArray.count];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[self cropImage:image:cameraOverView.cropView]];
        
        [imageView setFrame:CGRectMake((imgArray.count - 1) * 280 / 3.4, 0, 280 / 3.4, 100)];
        imageView.tag = imgArray.count-1;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake((imgArray.count - 1) * 280 / 3.4, 0, 280 / 3.4, 100)];
        btn.tag = imgArray.count-1;
        
        [btn addTarget:self action:@selector(imageDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        [imgViewArray insertObject:imageView atIndex:imgViewArray.count];
        [btnArray insertObject:btn atIndex:btnArray.count];
        
        imageView = nil;
        btn = nil;
        
        [selectedOverView.selectedScrollView addSubview:[imgViewArray objectAtIndex:imgViewArray.count-1]];
        [selectedOverView.selectedScrollView addSubview:[btnArray objectAtIndex:btnArray.count-1]];
        
        [selectedOverView.selectedScrollView setContentSize:CGSizeMake(imgArray.count * 123, 0)];
        
        menuState = false;
        [self menuUpDown];
        
    }
}

- (UIImage *)cropImage:(UIImage *)img:(UIView *)view{
    
    float ratio_x = img.size.width/320;
    float ratio_y = img.size.height/425;

    float x = ratio_x * view.frame.origin.x;
    float y = ratio_y * view.frame.origin.y;

    float width = ratio_x * view.frame.size.width;
    float heigth = ratio_y * view.frame.size.height;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], CGRectMake(x, y, heigth, width));

    
    UIImage *croppedImage =[UIImage imageWithCGImage:imageRef];
    
    UIImage *newImage = [[UIImage alloc] initWithCGImage: croppedImage.CGImage
                                          scale: 1.0
                                    orientation: UIImageOrientationRight];
    
    
    float resizeRatio_x = 1000 / newImage.size.width ;
    UIImage *smallImage = [self imageWithImage:newImage scaledToSize:CGSizeMake(1000, newImage.size.height*resizeRatio_x)];
    
    return smallImage;

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imageDelete:(UIButton *)btn{
    
    [[imgViewArray objectAtIndex:btn.tag] removeFromSuperview];
    [[btnArray objectAtIndex:btn.tag] removeFromSuperview];
    
    [imgViewArray removeObjectAtIndex:btn.tag];
    [btnArray removeObjectAtIndex:btn.tag];
    [imgArray removeObjectAtIndex:btn.tag];
    
    for (int i = btn.tag; i < btnArray.count; i++) {
        [[btnArray objectAtIndex:i]setTag:i];
        [self moveView2:[imgViewArray objectAtIndex:i] duration:0.2 curve:UIViewAnimationCurveLinear x:i * 123];
        [[btnArray objectAtIndex:i]setFrame:CGRectMake(i * 123, 0, 123, 100)];
    }
    
    [selectedOverView.selectedScrollView setContentSize:CGSizeMake(imgArray.count * 123, 0)];
}

- (void)imageOcr{
    if (imgArray.count != 0) {
        [imagePickerController dismissModalViewControllerAnimated:NO];
        
        
        OcrResultCheckViewController *ocrView = [[OcrResultCheckViewController alloc]init];
        
        [ocrView setimage:imgArray];
        [self presentModalViewController:ocrView animated:YES];
    }
}

- (void)setTableInit{
//    bookNumber = 0;
//    chapterNumber = 0;
//    pNumber = 0;
//    cNumber = 1;
    
    bArray = [dbMsg getBookIds:pNumber:cNumber:sNumber];
    
    [gArray removeAllObjects];
    [groupCountArray removeAllObjects];
    
    groupArray = [dbMsg getInsertBookGroup];
    if (groupArray.count != 0) {
        for (int i = 0; i < groupArray.count; i++) {
            NSArray *tempArray = [dbMsg getInsertBookFromGroup:[groupArray objectAtIndex:i]];
            [groupCountArray insertObject:[NSNumber numberWithInt:tempArray.count] atIndex:i];
            for (int j = 0; j < tempArray.count; j++) {
                [gArray insertObject:[tempArray objectAtIndex:j]atIndex:gArray.count];
            }
        }
    }
    
    tableCellCount = bArray.count;
    
    if (bArray.count + gArray.count != 0)
        [scrollView setHidden:NO];
    else
        [scrollView setHidden:YES];
        
    [bookTable reloadData];
}

- (void)tableReload{
    [gArray removeAllObjects];
    [groupCountArray removeAllObjects];
    
    groupArray = [dbMsg getInsertBookGroup];
    if (groupArray.count != 0) {
        for (int i = 0; i < groupArray.count; i++) {
            NSArray *tempArray = [dbMsg getInsertBookFromGroup:[groupArray objectAtIndex:i]];
            [groupCountArray insertObject:[NSNumber numberWithInt:tempArray.count] atIndex:i];
            for (int j = 0; j < tempArray.count; j++) {
                [gArray insertObject:[tempArray objectAtIndex:j]atIndex:gArray.count];
            }
        }
    }
    if (gArray.count != 0)
        [scrollView setHidden:NO];
    else
        [scrollView setHidden:YES];
    
    [bookTable reloadData];
}

- (void)viewDidUnload {
    publisherName = nil;
    className = nil;
    classNumber = nil;
    //    [self setSearchEvent:nil];
    bookTable = nil;
    chapterTable = nil;
    themeTable = nil;
    scrollView = nil;
    naviScroll = nil;
    [super viewDidUnload];
}

// ---------- Menu Up & Down Scroll ---------- //
/* -------------------------------------------
 menuUpDown 버튼을 클릭했을 경우 발생
 Menu 위 아래로 스크롤
 ------------------------------------------- */
-(void)menuUpDown{
    if (menuState) {
        [self moveView:selectedOverView duration:0.3 curve:UIViewAnimationCurveLinear y:self.view.frame.size.height - 20];
        menuState = false;
    }else{
        [self moveView:selectedOverView duration:0.3 curve:UIViewAnimationCurveLinear y:self.view.frame.size.height - 120];
        menuState = true;
    }
}


// -------------- setPanGestuer -------------- //
/* -------------------------------------------
 매뉴의 View 에 해당 제스터를 설정
 ------------------------------------------- */
-(void)setPanGestuer{
    UIPanGestureRecognizer* _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    _panGestureRecognizer.minimumNumberOfTouches = 1;
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    
    [_panGestureRecognizer setDelegate:self];
    
    [selectedOverView addGestureRecognizer:_panGestureRecognizer];
}

// ------------- panGestureAction ------------ //
/* -------------------------------------------
 PanGestuerAction 이벤트
 ------------------------------------------- */
- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer
{
    float _y = 0;
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:selectedOverView];
        
        CGRect newFrame = selectedOverView.frame;
        
        if (newFrame.origin.y + translation.y >= self.view.frame.size.height - 20 && newFrame.origin.y + translation.y <= self.view.frame.size.height - 120) {
            newFrame.origin.y = newFrame.origin.y + translation.y;
            _y = newFrame.origin.x;
        }
        selectedOverView.frame = newFrame;
        [recognizer setTranslation:CGPointZero inView:selectedOverView];
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        CGPoint translation = [recognizer translationInView:selectedOverView];
        
        CGRect newFrame = selectedOverView.frame;
        
        if (newFrame.origin.y + translation.y <= 0) {
            [self moveView:selectedOverView duration:0.1 curve:UIViewAnimationCurveLinear y:self.view.frame.size.height - 20];
        }else if (newFrame.origin.y + translation.y >= 1){
            [self moveView:selectedOverView duration:0.1 curve:UIViewAnimationCurveLinear y:self.view.frame.size.height - 120];
        }
    }
}


/* -------------------------------------------
 View Animation
 ------------------------------------------- */
- (void)moveView:(UIView *)view duration:(NSTimeInterval)duration
            curve:(int)curve y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    //    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    //    view.transform = transform;
    
    view.frame = CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height);
    // Commit the changes
    [UIView commitAnimations];
    
}

/* -------------------------------------------
 View Animation
 ------------------------------------------- */
- (void)moveView2:(UIView *)view duration:(NSTimeInterval)duration
           curve:(int)curve x:(CGFloat)x
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    //    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    //    view.transform = transform;
    
    view.frame = CGRectMake(x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    // Commit the changes
    [UIView commitAnimations];
    
}

// ---------------- MoveView ---------------- //
/* ------------------------------------------
 View Move Animation
 ------------------------------------------ */

//- (void)moveView:(UIView *)view duration:(NSTimeInterval)duration
//           curve:(int)curve x:(CGFloat)x y:(CGFloat)y
//{
//    // Setup the animation
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:duration];
//    [UIView setAnimationCurve:curve];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//
//    // The transform matrix
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
//    view.transform = transform;
//
//    // Commit the changes
//    [UIView commitAnimations];
//
//}
//
//- (void)moveView2:(UIView *)view duration:(NSTimeInterval)duration
//            curve:(int)curve x:(CGFloat)x
//{
//    // Setup the animation
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:duration];
//    [UIView setAnimationCurve:curve];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//
//    // The transform matrix
//    //    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
//    //    view.transform = transform;
//
//    view.frame = CGRectMake(x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
//    // Commit the changes
//    [UIView commitAnimations];
//    
//}

@end
