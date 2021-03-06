//
//  GJGCInformationTextCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationTextCell.h"
#import "GJGCInformationCellContentModel.h"
#import "GJGCTagView.h"
#import "GJGCCommonAttributedStringStyle.h"

@interface GJGCInformationTextCell ()

@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;    // 长按手势

@end

@implementation GJGCInformationTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.tagBoradMargin = 13.f;
        self.topBordMargin = 15.5f;
        self.contentMargin = 16.f;
        
        self.tagLabel = [[GJCFCoreTextContentView alloc]init];
        self.tagLabel.gjcf_left = self.tagBoradMargin;
        self.tagLabel.gjcf_top =  self.topBordMargin;
        self.tagLabel.gjcf_width = 80;
        self.tagLabel.gjcf_height = 20;
        self.tagLabel.contentBaseWidth = self.tagLabel.gjcf_width;
        self.tagLabel.contentBaseHeight = self.tagLabel.gjcf_height;
        self.tagLabel.backgroundColor = [UIColor clearColor];
        [self.baseContentView addSubview:self.tagLabel];
        
        self.contentLabel = [[GJCFCoreTextContentView alloc]init];
        self.contentLabel.gjcf_left = self.tagLabel.gjcf_right + self.contentMargin;
        self.contentLabel.gjcf_top = self.tagLabel.gjcf_top;
        self.contentLabel.gjcf_width = GJCFSystemScreenWidth - 65 - self.contentMargin -2*self.tagBoradMargin - self.accessoryIndicatorView.gjcf_width;
        self.contentLabel.gjcf_height = 20;
        self.contentLabel.contentBaseWidth = self.contentLabel.gjcf_width;
        self.contentLabel.contentBaseHeight = self.contentLabel.gjcf_height;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        
        [self.baseContentView addSubview:self.contentLabel];
        
        // 显示 美女群主/妹子多
        _groupAttrTagView = [[GJGCTagView alloc] initWithFrame:CGRectZero];
        [self.baseContentView addSubview:_groupAttrTagView];
    }
    return self;
}

- (void)setContentInformationModel:(GJGCInformationBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    
    if (contentModel) {
        GJGCInformationCellContentModel *cellContentModel = (GJGCInformationCellContentModel*)contentModel;
        NSString *tagNameStr = cellContentModel.tag.string;
        if (tagNameStr) {
            // 是否支持长按 添加长按
            if (cellContentModel.haveLongPress) {
                // 增加手势
                if (!_longPressGesture) {
                    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(cellLongPressed:)];
                    _longPressGesture.minimumPressDuration = 0.8;
                }
                [self removeGestureRecognizer:_longPressGesture];
                [self addGestureRecognizer:_longPressGesture];
            }
        }
    }
    
    [super setContentInformationModel:contentModel];
    
    GJGCInformationCellContentModel *informationModel = (GJGCInformationCellContentModel *)contentModel;
    
    
    if (informationModel.seprateStyle == GJGCInformationSeprateLineStyleTopFullBottomFull || informationModel.seprateStyle == GJGCInformationSeprateLineStyleTopNoneBottomFull) {
        self.tagLabel.gjcf_left = 16.f;
    }else{
        self.tagLabel.gjcf_left = self.baseSeprateLine.gjcf_left;
    }
    self.tagLabel.contentAttributedString = informationModel.tag;
    self.tagLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:informationModel.tag forBaseContentSize:self.tagLabel.contentBaseSize];
    
    self.contentLabel.contentAttributedString = informationModel.baseContent;
    self.contentLabel.gjcf_left = self.tagLabel.gjcf_right + self.contentMargin;
    if (informationModel.isIconShowGroupOwner && informationModel.isShowOwnerIcon) {
        self.contentLabel.contentBaseWidth = GJCFSystemScreenWidth - 4*16 - 28 - self.tagLabel.gjcf_width;
    }else{
        self.contentLabel.contentBaseWidth = GJCFSystemScreenWidth - 4*16 - 22 - self.tagLabel.gjcf_width;
    }
    
    if (informationModel.groupAttrTagStr.length > 0) {
        // 美女群主/妹子多 宽度
        NSInteger groupAttrTagViewWidth = 25;
        if (informationModel.groupAttrTagStr.length > 3) {
            groupAttrTagViewWidth = 35;
        }
        NSInteger groupAttrTagViewLeft = self.accessoryIndicatorView.gjcf_left - 14 - groupAttrTagViewWidth;
        self.contentLabel.gjcf_width = groupAttrTagViewLeft - (self.tagLabel.gjcf_right + 16 + 28 + 8);
        self.contentLabel.contentBaseWidth = self.contentLabel.gjcf_width;
    }
    self.contentLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:informationModel.baseContent forBaseContentSize:self.contentLabel.contentBaseSize];
    if (informationModel.isIconShowGroupOwner && informationModel.isShowOwnerIcon) {
        self.contentLabel.gjcf_left = self.tagLabel.gjcf_right + 16 + 28 + 8;
        self.baseContentView.gjcf_height = self.tagLabel.gjcf_bottom + self.topBordMargin;
    }else{
        self.contentLabel.gjcf_left = self.tagLabel.gjcf_right + 16;
        self.baseContentView.gjcf_height = self.tagLabel.gjcf_bottom + self.topBordMargin;
    }
    
    self.baseContentView.gjcf_height = self.contentLabel.gjcf_bottom + self.topBordMargin;
    
    // 美女群主/妹子多
    if (informationModel.groupAttrTagStr.length > 0) {
        _groupAttrTagView.hidden = NO;
        _groupAttrTagView.gjcf_width = 25;
        if (informationModel.groupAttrTagStr.length > 3) {
            _groupAttrTagView.gjcf_width = 35;
        }
        _groupAttrTagView.gjcf_height = 15;
        _groupAttrTagView.gjcf_left =  self.accessoryIndicatorView.gjcf_left - 16 - _groupAttrTagView.gjcf_width;
        _groupAttrTagView.gjcf_centerY = self.contentLabel.gjcf_centerY+2;
        
        NSAttributedString *typeString = [GJGCCommonAttributedStringStyle getGroupTypeAttributedString:informationModel.groupAttrTagStr];
        [_groupAttrTagView setContent:typeString];
        [_groupAttrTagView setImageName:[NSString stringWithFormat:@"标签-bg-%@",informationModel.groupAttrTagStr]];
        //[_groupAttrTagView setImageName:[NSString stringWithFormat:@"标签-bg-妹子多"]];
    }
    else {
        _groupAttrTagView.hidden = YES;
    }
    
    self.tagLabel.gjcf_top = self.contentLabel.gjcf_top;
    
    self.topSeprateLine.gjcf_top = informationModel.topLineMargin;
    self.baseContentView.gjcf_top = self.topSeprateLine.gjcf_bottom-0.5;
    self.baseSeprateLine.gjcf_bottom = self.baseContentView.gjcf_bottom;
    
    self.accessoryIndicatorView.gjcf_centerY = self.topLineToCellTopMargin + self.baseContentView.gjcf_height/2;

}

-(void)cellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.baseContentView setHighlighted:YES];
        CGRect menuFrame = CGRectMake(self.contentLabel.gjcf_left, self.contentLabel.gjcf_centerY+5, 20, 20);
        
        [self becomeFirstResponder];
        NSMutableArray *itmeArr = [[NSMutableArray alloc] init];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(acctounCopy:)];
        [itmeArr addObject:copyItem];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:nil];
        [menu setMenuItems:itmeArr];
        
        [menu setTargetRect:menuFrame inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    else {
        [self.baseContentView setHighlighted:NO];
    }
}

-(void)acctounCopy:(UIMenuController*)aMenu
{
    [aMenu setMenuVisible:NO animated:NO];
    [UIPasteboard generalPasteboard].string = self.contentLabel.contentAttributedString.string;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL isShow = NO;
    if (action == @selector(acctounCopy:)) {
        isShow = YES;
    }
    return isShow;
}

@end
