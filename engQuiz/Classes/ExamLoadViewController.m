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
#import "ExViewController.h"


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
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [self setScrollViewInit];
    [scrollView setHidden:YES];
    
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
    
    pArray = [dbMsg getPublisherIds];
    
    tableCellCount = pArray.count + 1;
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
    
    tableCellCount = 3;
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
    
    tableCellCount = 4;
    myView.tag = Class2Tag;
    myView.delegate = self;
    myView.dataSource = self;
    [alert addSubview:myView];
    
    [alert show];
}

- (IBAction)addSentence:(id)sender {
    ExViewController *exView = [[ExViewController alloc]init];
    
    [self presentModalViewController:exView animated:YES];
}


#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int index = [indexPath row];
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (tableView.tag == BookTableTag) {
        
        cell.textLabel.text = [dbMsg getBookName:[[bArray objectAtIndex:index]integerValue]];
        
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
        }else{
            cell.textLabel.text = [dbMsg getPublisherName:[[pArray objectAtIndex:index-1]integerValue]];
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




// ---------------- Section Count Setting ---------------- //

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    return tableCellCount;
    if (tableView.tag == PublicTag) {
        return pArray.count + 1;
    }else if (tableView.tag == Class1Tag) {
        return 3;
    }else if (tableView.tag == Class2Tag) {
        return 4;
    }else if ( tableView.tag == BookTableTag) {
        return bArray.count;
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
    
    if (tableView.tag == BookTableTag) {
        if (bookNumber == index + 1) {
            [cArray removeAllObjects];
            [self tableRePoz:2];
        }else{
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
            tArray = [dbMsg getThemeData:[[cArray objectAtIndex:index]integerValue]];
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
            [sentenceVeiw setInit:[dbMsg getBookName:[[bArray objectAtIndex:bookNumber - 1]integerValue]]:[tArray objectAtIndex:2]:0:0];
        }else {
            [sentenceVeiw setInit:[dbMsg getBookName:[[bArray objectAtIndex:bookNumber - 1]integerValue]]:[tArray objectAtIndex:index * 3 + 2]:0:0];
        }
        
        [self presentModalViewController:sentenceVeiw animated:YES];
    }
    else{
        if (tableView.tag == PublicTag) {
            if (index == 0) {
                pNumber = index;
                [publisherName setTitle: @"전체" forState:UIControlStateNormal];
                
            }else {
                pNumber = [[pArray objectAtIndex:index-1]integerValue];
                [publisherName setTitle:[dbMsg getPublisherName:pNumber] forState:UIControlStateNormal];

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
        
        else if (tableView.tag == Class2Tag) {
            
            switch (index) {
                case 0:
                    sNumber = index;
                    [classNumber setTitle: @"전체" forState:UIControlStateNormal];
                    break;
                    
                case 1:
                    sNumber = index;
                    [classNumber setTitle: @"1 학년" forState:UIControlStateNormal];
                    break;
                    
                case 2:
                    sNumber = index;
                    [classNumber setTitle: @"2 학년" forState:UIControlStateNormal];
                    break;
                    
                case 3:
                    sNumber = index;
                    [classNumber setTitle: @"3 학년" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
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

- (void)disAlert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    bookNumber = 0;
    chapterNumber = 0;
    
    bArray = [dbMsg getBookIds:pNumber:cNumber:sNumber];
    tableCellCount = bArray.count;
    
    if (bArray.count != 0)
        [scrollView setHidden:NO];
    else
        [scrollView setHidden:YES];
    
    [bookTable reloadData];
}
             
- (void)naviButtonEvent:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            [scrollView setContentOffset:CGPointMake(0,0) animated:YES];

            break;
        case 1:
            [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width,0) animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)setTableInit{
    bookNumber = 0;
    chapterNumber = 0;
    pNumber = 1;
    cNumber = 1;
    
    bArray = [dbMsg getBookIds:pNumber:cNumber:sNumber];
    tableCellCount = bArray.count;
    
    if (bArray.count != 0)
        [scrollView setHidden:NO];
    else
        [scrollView setHidden:YES];
    
    [bookTable reloadData];
}


////---------------------------------------------------
//// ScrollView Delegate
////---------------------------------------------------
//- (void)scrollViewDidScroll:(UIScrollView *)sender {
//    
//    // Update the page when more than 50% of the previous/next page is visible
//    //    CGFloat pageWidth = scrollView.frame.size.width;
//    //    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//}
//
//// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    //    SJ_DEBUG_LOG(@"page Number :%d", pageController.currentPage);
//    //    nowIndex = pageControl.currentPage;
////    pageControlUsed = NO;
//    
//}


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
