//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "Tweet.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *tweets;
//view controller has tableView as a subview
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchTimeline];
    
    //view controller becomes dataSource and deleagate of tableview
    self.timelineTableView.dataSource = self;
    self.timelineTableView.delegate = self;
 
    //UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTimeline) forControlEvents:UIControlEventValueChanged];
    [self.timelineTableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void) fetchTimeline {
    // Get timeline with API request
    // ^ indicates block/completion is coming -> we pass the completion block
    //      to the API manager function so it can call it later in background
    //  allows us to keep executing code -> don't block the code
    //  deferred execution
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            NSLog(@"Dictionary: %@", tweets);
            //for (Tweet *curTweet in tweets) {
            //    NSString *text = curTweet[@"text"];
            //    NSLog(@"Dictionary text: %@", text);
            //}
            
            //view controller stores the data passed into the completion handler
            self.tweets = (NSMutableArray *) tweets;
            //reload the table view
            [self.timelineTableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//provide a cell object for each row
//table view asks dataSource for cellForRowAt
// returns an instance of the custom cell with the reuse identifier with it's
//      elements populated with data at the index asked for
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //TweetCell *cell = [[TweetCell alloc] init];
    //TODO: implement this method
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    //cell = [timelineTableView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = self.tweets[indexPath.item];
    //NSLog(@"Current text: %@", tweet.text);
    cell.authorLabel.text = tweet.user.name;
    cell.contentLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    cell.handleLabel.text = tweet.user.screenName;
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%d",tweet.retweetCount];
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
    //cell.tweet = tweet;
    cell.replyCountLabel.text = [NSString stringWithFormat:@"%d",tweet.replyCount];
    
    
    NSString *profilePicString = tweet.user.profilePic;
    NSURL *profilePicURL = [NSURL URLWithString:profilePicString];
    cell.profileImage.image = nil;
    [cell.profileImage setImageWithURL:profilePicURL];
    
    cell.tweet = tweet;
    
    //load correct favorite button icon
    if (tweet.favorited) {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    else {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        }
    //load correct retweet button icon
    if (tweet.retweeted) {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    else {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    return cell;
    
}

//table view asks dataSource for numberOfRows
// returns number of items returned from the API
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)didTweet:(Tweet *)tweet {
    NSLog(@"TWEETING");
    [self.tweets insertObject:tweet atIndex:0];
    [self.timelineTableView reloadData];
}

@end
