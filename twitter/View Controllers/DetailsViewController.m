//
//  DetailsViewController.m
//  twitter
//
//  Created by eazheng on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "APIManager.h"
#import "Tweet.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    NSLog(@"HELLOOOO");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //cell = [timelineTableView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];

    Tweet *tweet = self.tweet;
    //NSLog(@"Current text: %@", tweet.text);
    self.authorLabel.text = tweet.user.name;
    self.contentLabel.text = tweet.text;
    self.timestampLabel.text = tweet.createdAtString;
    self.handleLabel.text = [NSString stringWithFormat:@"%@%@", @"@", tweet.user.screenName];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
    NSString *profilePicString = tweet.user.profilePic;
    NSURL *profilePicURL = [NSURL URLWithString:profilePicString];
    self.profileView.image = nil;
    [self.profileView setImageWithURL:profilePicURL];
    
    self.tweet = tweet;
    //load correct favorite button icon
    if (tweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    //load correct retweet button icon
    if (tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }

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
    [self.timelineTableView reloadData];
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
    [self.timelineTableView reloadData];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
