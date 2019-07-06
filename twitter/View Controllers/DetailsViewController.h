//
//  DetailsViewController.h
//  twitter
//
//  Created by eazheng on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;
@property (strong, nonatomic) UITableView *timelineTableView;

@end

NS_ASSUME_NONNULL_END
