//
//  Tweet.m
//  twitter
//
//  Created by eazheng on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "DateTools.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        // yes, this is a re-tweet:
        if(originalTweet != nil){
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.replyCount = [dictionary[@"reply_count"] intValue];
        
        // initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        // Format and set createdAtString
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSLog(@"created at: %@", createdAtOriginalString);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        NSDate *now = [[NSDate date] dateByAddingDays:-1];
        BOOL postWasRecentBool = [date isLaterThan:now];
        
        //if post was less than 1 day ago
        if (postWasRecentBool) {
            self.createdAtString = date.shortTimeAgoSinceNow;
        }
        else {
            // Configure output format
            formatter.dateStyle = NSDateFormatterShortStyle;
            formatter.timeStyle = NSDateFormatterNoStyle;
            // Convert Date to String
            self.createdAtString = [formatter stringFromDate:date];
        }

        /*
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        self.createdAtString = [formatter stringFromDate:date];
        
        NSString *temp = [NSString stringWithFormat:@"%lu", formatter.dateStyle];
        
        NSLog(@"DATE: %@", temp);
        NSLog(@"Created string: %@", self.createdAtString);
         */
    }
    //NSLog(@"COMPLETED ENTRY: %@", self);
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        //NSLog(@"current entry: %@", dictionary);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    //NSLog(@"RESULTING ARRAY: %@", tweets);
    return tweets;
}

@end
