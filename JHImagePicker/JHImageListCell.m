//
//  JHImageListCell.m
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import "JHImageListCell.h"

#define JHImageListCellID @"JHImageListCellID"

@interface JHImageListCell()

@property(nonatomic, strong) UIImageView *iconIV;
@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) UILabel *countLabel;
@property(nonatomic, strong) UIImageView *arrowIV;

@end

@implementation JHImageListCell

+ (JHImageListCell *)configWith:(UITableView *)table {
    JHImageListCell * cell = [table dequeueReusableCellWithIdentifier:JHImageListCellID];
    if (cell == nil) {
        cell = [[JHImageListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JHImageListCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadUI];
    }
    return self;
}

- (void)setItem:(JHListItem *)item {
    _item = item;
    self.titleL.text = item.title;
    self.countLabel.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)item.result.count];
    
    [self.titleL sizeToFit];
    self.titleL.center = CGPointMake(self.titleL.center.x, JHCellHeight/2);
    
    self.countLabel.frame = CGRectMake(CGRectGetMaxX(self.titleL.frame) + 10, 0, 10, JHCellHeight);
    [self.countLabel sizeToFit];
    self.countLabel.center = CGPointMake(self.countLabel.center.x, JHCellHeight/2);
}

- (void)loadUI {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.arrowIV];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:0.5];
    line.frame = CGRectMake(20, JHCellHeight - 0.5, jhSCREEN.width - 20, 0.5);
    [self.contentView addSubview:line];
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]init];
        _iconIV.frame = CGRectMake(10, 0, JHCellHeight, JHCellHeight);
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.image = [UIImage imageNamed:@"jh_defaultIV"];
    }
    return _iconIV;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconIV.frame)+5.0, 0, 10, JHCellHeight)];
        _titleL.font = [UIFont systemFontOfSize:17];
        _titleL.textColor = UIColor.blackColor;
    }
    return _titleL;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleL.frame)+5.0, 0, 10, JHCellHeight)];
        _countLabel.font = [UIFont systemFontOfSize:16];
        _countLabel.textColor = UIColor.lightGrayColor;
    }
    return _countLabel;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        _arrowIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jh_arrow"]];
        _arrowIV.frame = CGRectMake(jhSCREEN.width - 11 - 16, (JHCellHeight - 16)/2, 16, 16);
    }
    return _arrowIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
