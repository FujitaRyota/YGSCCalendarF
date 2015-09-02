//
//  ViewController.m
//  YGSCCalendarF
//
//  Created by FujitaRyota on 2015/08/26.
//  Copyright (c) 2015年 FujitaRyota. All rights reserved.
//

#import "ViewController.h"
#import "YGSCDayCell.h"

@interface ViewController ()
{
    CGSize cellSize;
}

@property (weak, nonatomic) IBOutlet UICollectionView* montheCalendarView;
@property (nonatomic, strong) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UILabel* monthLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    cellSize = CGSizeMake(50, 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 指定した月の末日を設定する
    // 現在の日時から年と月を取得する
    NSDate* now = [NSDate date];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* dateComponents = [[NSCalendar currentCalendar]components:unitFlags fromDate:now];
    
    return [self monthLastDay:(int)dateComponents.year month:(int)dateComponents.month];
}

/**
 *  Controls what gets displayed in each cell
 *  Edit this function for customized calendar logic
 */

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YGSCDayCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YGSCDayCell"
                                                              forIndexPath:indexPath];
    
    NSString* dayStr = [NSString stringWithFormat:@"%zd", indexPath.row+1];
    
    cell.dayLabel.text = dayStr;
    cell.layer.cornerRadius = (cell.frame.size.width/2);
    return cell;
}

/*
 * Scale the collection view size to fit the frame
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (cellSize);
}

/*
 * Set all spaces between the cells to zero
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

/*
 * If the width of the calendar cannot be divided by 7, add offset to each side to fit the calendar in
 */
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 10);
    return (inset);

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSDate *)firstDateOfMonth
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.selectedDate];
    components.day = 1;
    
    NSDate *firstDateMonth = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return firstDateMonth;
}

- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath
{
    // 「月の初日が週の何日目か」を計算する
    NSInteger ordinalityOfFirstDay =
    [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                            inUnit:NSCalendarUnitWeekOfMonth
                                           forDate:self.firstDateOfMonth];
    
    // 「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = indexPath.item - (ordinalityOfFirstDay - 1);
    
    NSDate *date =
    [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                  toDate:self.firstDateOfMonth
                                                 options:0];
    return date;
}

// 末日を取得(1~12をmonthに指定する)
-(int)monthLastDay:(int)year month:(int)month
{
    int calcMonth = month + 1;
    int calcYear = year;
    // 年をまたぐ処理が必要
    if (calcMonth > 12) {
        calcYear ++;
        calcMonth = 1;
    }
    
    if(calcMonth >= 1 && calcMonth <= 12) {
        /*
        // 今の時刻を取得する
        NSDate *now = [NSDate date];
        
        // NSCalendarを取得する
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        NSInteger maxDay = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:now].length;
        */
        NSDateFormatter* inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm/ss"];
        
        NSString* sourceStr = [NSString stringWithFormat:@"%zd/%02d/01 00:00:00", calcYear, calcMonth];
        NSDate* firstDate = [inputDateFormatter dateFromString:sourceStr];
        NSDate* lastDate = [firstDate initWithTimeInterval:-(60*60*24) sinceDate:firstDate];
        
        NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        
        NSDateComponents* dateComponents = [[NSCalendar currentCalendar]components:unitFlags fromDate:lastDate];
        _monthLabel.text = [NSString stringWithFormat:@"【%zd年%zd月%zd日】", dateComponents.year, dateComponents.month, dateComponents.day];
        return ((int)dateComponents.day); // 月により変更される。
    } else {
        return (-1);
    }
    
}



@end
