//
//  RecommendationVideoTableViewCell.m
//  MiniHeadline
//
//  Created by huangscar on 2019/5/8.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "RecommendationVideoTableViewCell.h"
#import "../Model/MyVideo.h"

@interface RecommendationVideoTableViewCell()
@property (strong, nonatomic) UIImageView *videoImage;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *detail;
@property (strong, nonatomic) UILabel *time;
@end

@implementation RecommendationVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(244, 4, 150, 100)];
    [self.contentView addSubview:self.videoImage];
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(20, 9, 216, 61)];
    [self.title setNumberOfLines:2];
    [self.title setFont:[UIFont systemFontOfSize:25]];
    [self.contentView addSubview:self.title];
    self.detail = [[UILabel alloc] initWithFrame:CGRectMake(20, 78, 211, 21)];
    [self.detail setTextColor:[UIColor lightGrayColor]];
    [self.detail setFont:[UIFont systemFontOfSize:17]];
    [self.contentView addSubview:self.detail];
    self.time = [[UILabel alloc] initWithFrame:CGRectMake(339, 70, 43, 24)];
    //[self.time setBackgroundColor:[UIColor darkGrayColor]];
    self.time.layer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.55].CGColor;
    
    [self.time setTextColor:[UIColor whiteColor]];
    [self.time setFont:[UIFont systemFontOfSize:12]];
    self.time.layer.cornerRadius = 12.0f;
    self.time.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.time];
}

- (void)setCellData:(MyVideo*) data {
    [self.title setText:data.title];
    NSURL *url = [NSURL fileURLWithPath:data.video];
    AVAsset * asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator * imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    CMTime cmtime = CMTimeMake(1,1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:cmtime actualTime:NULL error:NULL];
    UIImage * thumbnail = [UIImage imageWithCGImage:imageRef];
    [self.videoImage setImage:thumbnail];
    NSString *detailString = [NSString stringWithString:data.authorName];
    detailString = [detailString stringByAppendingString:@" "];
    NSString* playNumString;
    if(data.playNum >= 10000) {
        NSInteger num = data.playNum/10000;
        playNumString = [NSString stringWithFormat:@"%d万次播放", num];
    }
    else {
        playNumString = [NSString stringWithFormat:@"%d次播放", data.playNum];
    }
    detailString = [detailString stringByAppendingString:playNumString];
    [self.detail setText:detailString];
    AVURLAsset *avUrlAsset = [AVURLAsset assetWithURL:url];
    CMTime videoDuration = [avUrlAsset duration];
    float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:videoDurationSeconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"mm:ss"];  //you can vary the date string. Ex: "mm:ss"
    NSString* result = [dateFormatter stringFromDate:date];
    [self.time setText:result];
}

@end
