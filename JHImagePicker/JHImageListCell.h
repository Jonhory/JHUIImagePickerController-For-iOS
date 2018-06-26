//
//  JHImageListCell.h
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import <UIKit/UIKit.h>
#import "JHImageListVC.h"

#define JHCellHeight 67.0

@interface JHImageListCell : UITableViewCell

@property(nonatomic, strong) JHListItem *item;

+ (JHImageListCell *)configWith:(UITableView *)table;

@end
