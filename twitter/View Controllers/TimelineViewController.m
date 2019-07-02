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

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timelineTableView.dataSource = self;
    self.timelineTableView.delegate = self;
    
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            NSLog(@"Dictionary: %@", tweets);
            //for (Tweet *curTweet in tweets) {
            //    NSString *text = curTweet[@"text"];
            //    NSLog(@"Dictionary text: %@", text);
            //}
            
            self.tweets = tweets;
            [self.timelineTableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //TweetCell *cell = [[TweetCell alloc] init];
    //TODO: implement this method
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    //cell = [timelineTableView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = self.tweets[indexPath.item];
    NSLog(@"Current text: %@", tweet.text);
    cell.authorLabel.text = tweet.user.name;
    cell.contentLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    cell.handleLabel.text = tweet.user.screenName;
    //cell.tweet = tweet;
    
    NSString *profilePicString = tweet.user.profilePic;
    NSURL *profilePicURL = [NSURL URLWithString:profilePicString];
    cell.profileImage.image = nil;
    [cell.profileImage setImageWithURL:profilePicURL];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

@end
