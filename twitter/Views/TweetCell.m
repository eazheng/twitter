//
//  TweetCell.m
//  twitter
//
//  Created by eazheng on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state


}

- (IBAction)didTapFavorite:(id)sender {
    // to favorite
    if (self.tweet.favorited == NO) {
        // TODO: Update the local tweet model
        self.tweet.favorited = YES;
        NSLog(@"TWEET: %d", self.tweet.favoriteCount);
        self.tweet.favoriteCount += 1;
        NSLog(@"TWEET AFTER: %d", self.tweet.favoriteCount);
    
        // TODO: Update cell UI
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        //self.favorited = YES;
        
        //refresh like data
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    // to unfavorite (was alrady favorited before)
    else {
        // TODO: Update the local tweet model
        self.tweet.favorited = NO;
        //NSLog(@"TWEET: %d", self.tweet.favoriteCount);
        self.tweet.favoriteCount -= 1;
        //NSLog(@"TWEET AFTER: %d", self.tweet.favoriteCount);
        
        // TODO: Update cell UI
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        //self.favorited = NO;
        
        //refresh like data
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    // to retweet
    if (self.tweet.retweeted == NO) {
        // TODO: Update the local tweet model
        self.tweet.retweeted = YES;
        NSLog(@"TWEET: %d", self.tweet.retweetCount);
        self.tweet.retweetCount += 1;
        NSLog(@"TWEET AFTER: %d", self.tweet.retweetCount);
        
        // TODO: Update cell UI
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        
        //refresh retweet data
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeting the following Tweet: %@", tweet.text);
            }
        }];
    }
    // to unfavorite (was alrady favorited before)
    else {
        // TODO: Update the local tweet model
        self.tweet.retweeted = NO;
        //NSLog(@"TWEET: %d", self.tweet.favoriteCount);
        self.tweet.retweetCount -= 1;
        //NSLog(@"TWEET AFTER: %d", self.tweet.favoriteCount);
        
        // TODO: Update cell UI
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        
        //refresh retweet data
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeted tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}





@end
