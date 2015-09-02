//
//  YGSCDayCell.h
//  YGSCCalendarF
//
//  Created by FujitaRyota on 2015/08/26.
//  Copyright (c) 2015年 FujitaRyota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGSCDayCell : UICollectionViewCell
@property(weak, nonatomic) IBOutlet UILabel* dayLabel;
@property(strong, nonatomic) NSDate* day;
@property(assign, nonatomic) UIColor* background;

//@property(assign, nonatomic) NSInteger* yyyy;
//@property(assign, nonatomic) NSInteger* mm;
//@property(assign, nonatomic) NSInteger* dd;

@end
