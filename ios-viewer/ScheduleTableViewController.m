//
//  ScheduleTableViewController.m
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "config.h"
#import "MatchTableViewCell.h"
#import "ios_viewer-Swift.h"
#import "UINavigationController+SGProgress.h"
#import <UserNotifications/UserNotifications.h>
@import Firebase;

@interface ScheduleTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cacheButton;

@property (weak, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger currentMatch;
@end

@implementation ScheduleTableViewController


- (IBAction)ourScheduleTapped:(id)sender {
    [self performSegueWithIdentifier:@"citrusSchedule" sender:sender];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    if(self.searchbarIsEnabled) {
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    }
    //if there are starred matches
    if(self.firebaseFetcher.currentMatchManager.starredMatchesArray != nil && [self.firebaseFetcher.currentMatchManager.starredMatchesArray count]){
        
        NSMutableArray *intMatches = [[NSMutableArray alloc] init];
        //iterate thru cached starred matches
        for(NSString *item in self.firebaseFetcher.currentMatchManager.starredMatchesArray) {
            //add the match number
            [intMatches addObject:[NSNumber numberWithInt:[item integerValue]]];
        }
        NSString *slackId = self.firebaseFetcher.currentMatchManager.slackId;
        if(slackId != nil) {
            [[[[[[FIRDatabase database] reference] child: @"slackProfiles"] child:slackId] child: @"starredMatches"] setValue:intMatches];
        }
    }

}

- (void)viewDidLoad {
    
    self.cacheButton.enabled = NO;
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToCurrentMatch:) name:@"currentMatchUpdated" object:nil];
}

- (void)scrollToCurrentMatch:(NSNotification*)note {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"currentMatchUpdated" object:nil];
    self.currentMatch = (NSInteger)self.firebaseFetcher.currentMatchManager.currentMatch;
    
    [NSTimer scheduledTimerWithTimeInterval:3 target: self selector:@selector(scroll:) userInfo:nil repeats:NO];
}

-(void)scroll:(NSTimer*)timer {
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    if([self.tableView numberOfRowsInSection:0] > self.currentMatch - 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentMatch - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    
    Match *match = data;
    NSArray *redTeams = [self.firebaseFetcher getTeamsFromNumbers:match.redAllianceTeamNumbers];
    NSArray *blueTeams = [self.firebaseFetcher getTeamsFromNumbers:match.blueAllianceTeamNumbers];
    
    MatchTableViewCell *matchCell = (MatchTableViewCell *)cell;
    //set matchNum label
    matchCell.matchLabel.attributedText = [self textForScheduleLabelForType:0 forString:[NSString stringWithFormat:@"%ld", (long)match.number]];
    
    //iterate thru 3 times
    for (int i = 0; i < 3; i++) {
        if(i < redTeams.count) {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[redTeams objectAtIndex:i]).number]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
            if(((Team *)[redTeams objectAtIndex:i]).calculatedData.dysfunctionalPercentage > 0) {
                switch(i) {
                    case 0:
                        matchCell.redOneLabel.backgroundColor = [UIColor greenColor];
                    case 1:
                        matchCell.redTwoLabel.backgroundColor = [UIColor greenColor];
                    case 2:
                        matchCell.redThreeLabel.backgroundColor = [UIColor greenColor];
                }
            } else {
                switch(i) {
                    case 0:
                        matchCell.redOneLabel.backgroundColor = [UIColor clearColor];
                    case 1:
                        matchCell.redTwoLabel.backgroundColor = [UIColor clearColor];
                    case 2:
                        matchCell.redThreeLabel.backgroundColor = [UIColor clearColor];
                }
            }
        } else {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"???"]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
        }
        
        if(i < blueTeams.count) {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[blueTeams objectAtIndex:i]).number]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
            if(((Team *)[blueTeams objectAtIndex:i]).calculatedData.dysfunctionalPercentage > 0) {
                switch(i) {
                    case 0:
                        matchCell.blueOneLabel.backgroundColor = [UIColor greenColor];
                    case 1:
                        matchCell.blueTwoLabel.backgroundColor = [UIColor greenColor];
                    case 2:
                        matchCell.blueThreeLabel.backgroundColor = [UIColor greenColor];
                }
            } else {
                switch(i) {
                    case 0:
                        matchCell.blueOneLabel.backgroundColor = [UIColor clearColor];
                    case 1:
                        matchCell.blueTwoLabel.backgroundColor = [UIColor clearColor];
                    case 2:
                        matchCell.blueThreeLabel.backgroundColor = [UIColor clearColor];
                }
            }
        } else {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"???"]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
        }
    }
    
    //if the red team has a valid score
    if (match.redScore != -1 && match.redScore != nil) {
        //set the red score
        matchCell.redScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.redScore];
        matchCell.slash.alpha = 1;
        matchCell.redScoreLabel.alpha = 1;
    } else {
        if (match.calculatedData.predictedRedScore != -1.0) {
            matchCell.redScoreLabel.text = [Utils roundValue: match.calculatedData.predictedRedScore toDecimalPlaces:1];
            matchCell.redScoreLabel.alpha = .3;
        } else {
            matchCell.redScoreLabel.text = @"?";
        }
        matchCell.redScoreLabel.alpha = .3;
        matchCell.slash.alpha = .3;
    }
    
    if (match.blueScore != -1 && match.blueScore != nil) {
        matchCell.blueScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.blueScore];
        matchCell.slash.alpha = 1;
        matchCell.blueScoreLabel.alpha = 1;
    } else {
        if (match.calculatedData.predictedBlueScore != -1.0) {
            matchCell.blueScoreLabel.text = [Utils roundValue: match.calculatedData.predictedBlueScore toDecimalPlaces:1];
        } else {
        matchCell.blueScoreLabel.text = @"?";
        }
        matchCell.blueScoreLabel.alpha = .3;
    }
    if(![matchCell.blueScoreLabel.text  isEqual: @"?"] && ![matchCell.redScoreLabel.text  isEqual: @"?"] && ![matchCell.blueScoreLabel.text isEqual:@"-1"] && ![matchCell.redScoreLabel.text isEqual:@"-1"]) {
        if ([matchCell.matchLabel.text integerValue] > self.currentNumber) {
            self.currentNumber = [matchCell.matchLabel.text integerValue];
        }
        //NSLog([NSString stringWithFormat:@"%ld",(long)self.currentNumber]);
    }
}

- (NSString *)cellIdentifier {
    return MATCH_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = self.firebaseFetcher.matches;
    
    //NSLog(@"%lu", (unsigned long)returnData.count);
    //[self.tableView setUserInteractionEnabled:YES];
    return returnData;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchTableViewCell *matchCell = (MatchTableViewCell *)cell;
    if([self.firebaseFetcher.currentMatchManager.starredMatchesArray containsObject:matchCell.matchLabel.text]) {
        matchCell.backgroundColor = [UIColor colorWithRed:1.0 green:0.64 blue:1.0 alpha:0.6];
    }
    else {
        matchCell.backgroundColor = [UIColor whiteColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"Match Segue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier  isEqual: @"citrusSchedule"]) {
        SpecificTeamScheduleTableViewController *dest = (SpecificTeamScheduleTableViewController *)segue.destinationViewController;
        dest.teamNumber = 1678;
    } else if ([segue.identifier isEqual: @"slackSegue"]) {
        SlackTableViewController *dest = (SlackTableViewController *)segue.destinationViewController;
        //init dest
    } else {
    MatchTableViewCell *cell = sender;
    MatchDetailsViewController *detailController = (MatchDetailsViewController *)segue.destinationViewController;
    //NSLog([NSString stringWithFormat:@"%lu",(unsigned long)self.firebaseFetcher.matches.count]);
    detailController.match = [self.firebaseFetcher.matches objectAtIndex:cell.matchLabel.text.integerValue-1];
    detailController.matchNumber = cell.matchLabel.text.integerValue;
    }
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    if(scope == 1) {
        return [self.firebaseFetcher filteredMatchesForMatchSearchString:searchString];
    } else if(scope == 0) {
        return [self.firebaseFetcher filteredMatchesforTeamSearchString:searchString];
    }
    return @[@"ERROR"];
    
//    return [firebaseFetcher.matches filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Match *match, NSDictionary *bindings) {
//        if (scope == 0) {
//            return ([match.matchName rangeOfString:searchString].location == 0 || [match.matchName rangeOfString:searchString].location == 1);
//        } else if (scope == 1) {
//            for (Team *team in [firebaseFetcher allTeamsInMatch:match]) {
//                NSString *numberText = [NSString stringWithFormat:@"%ld", (long)team.number];
//                if ([numberText rangeOfString:searchString].location == 0) {
//                    return YES;
//                }
//            }
//        }
//        return NO;
//    }]];

}

- (NSArray *)scopeButtonTitles {
    return @[@"Teams", @"Matches"];
}

- (NSAttributedString *)textForScheduleLabelForType:(NSInteger)type forString:(NSString *)string {
    if (type != [self currentScope] && type == 1) {
        return [self textForLabelForString:string highlightOccurencesOfString:[self highlightedStringForScope]];
    } else if (type != [self currentScope] && type == 0) {
        if ([string rangeOfString:[self highlightedStringForScope]].location == 0) {
            return [self textForLabelForString:string highlightOccurencesOfString:[self highlightedStringForScope]];
        }
    }
    
    return [[NSAttributedString alloc] initWithString:string];
}

- (NSAttributedString *)textForLabelForString:(NSString *)string highlightOccurencesOfString:(NSString *)highlightString {
    NSMutableAttributedString *mutAttribString = [[NSMutableAttributedString alloc] initWithString:string];
    if (highlightString) {
        [mutAttribString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:[string rangeOfString:highlightString]];
    }
    
    return mutAttribString;
}

- (IBAction)cachePhotos:(UIBarButtonItem *)sender {
    sender.enabled = NO;


    // Prepare PDF file
    //[self.firebaseFetcher downloadAllImages];
}

+ (NSArray *)mappings {
    return @[@"One", @"Two", @"Three"];
}

//aha! new system is better
-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        
        CGPoint p = [sender locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        MatchTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *slackId = self.firebaseFetcher.currentMatchManager.slackId;
        if(slackId != nil) {
            if([self.firebaseFetcher.currentMatchManager.starredMatchesArray containsObject:cell.matchLabel.text]) {
                //Remove the star
                NSMutableArray *a = [NSMutableArray arrayWithArray:self.firebaseFetcher.currentMatchManager.starredMatchesArray];
            
                [a removeObject:cell.matchLabel.text];
                self.firebaseFetcher.currentMatchManager.starredMatchesArray = a;
                cell.backgroundColor = [UIColor whiteColor];
                [[[[[[FIRDatabase database] reference] child:@"slackProfiles"] child:slackId] child:@"starredMatches"] setValue:a];
            } else {
                //Create the star
                cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.64 blue:1.0 alpha:0.6];
                self.firebaseFetcher.currentMatchManager.starredMatchesArray = [self.firebaseFetcher.currentMatchManager.starredMatchesArray arrayByAddingObjectsFromArray:@[cell.matchLabel.text]];
                [[[[FIRDatabase database] reference] child:@"slackProfiles"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    [[[[[[[FIRDatabase database] reference] child:@"slackProfiles"] child:slackId] child:@"starredMatches"] child:[NSString stringWithFormat:@"%lu", (unsigned long)[[snapshot childSnapshotForPath:self.firebaseFetcher.currentMatchManager.slackId] childSnapshotForPath:@"starredMatches"].childrenCount]] setValue:[NSNumber numberWithInt:[cell.matchLabel.text integerValue]]];
                }];
            }
        } else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Link Slack" message:@"Please link your slack account before you star matches." preferredStyle:UIAlertControllerStyleAlert];
            
            [ac addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }]];
            [self presentViewController:ac animated:YES completion:nil];
        }
        /*if([self.firebaseFetcher.currentMatchManager.starredMatchesArray containsObject:cell.matchLabel.text]) {
            NSMutableArray *a = [NSMutableArray arrayWithArray:self.firebaseFetcher.currentMatchManager.starredMatchesArray];
    
            [a removeObject:cell.matchLabel.text];
            self.firebaseFetcher.currentMatchManager.starredMatchesArray = a;
            cell.backgroundColor = [UIColor whiteColor];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [defaults valueForKey:@"NotificationToken"];
            //NSPredicate *isStarred = [NSPredicate predicateWithFormat:@"self.firebaseFetcher.currentMatchManager.starredMatchesArray contains[c] 'SELF'"];
            NSMutableArray *starredMatches = [[NSMutableArray alloc] init];
            [[[[[[FIRDatabase database] reference] child:@"AppTokens"] child:token] child:@"starredMatches"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                for (FIRDataSnapshot *item in [snapshot children]) {
                    if ([self.firebaseFetcher.currentMatchManager.starredMatchesArray containsObject: [NSString stringWithFormat: @"%@",item.value]]) {
                        [starredMatches addObject: [NSNumber numberWithInt:[(NSString *)item.value integerValue]]];
                    }
                }
                [[[[[[FIRDatabase database] reference] child:@"AppTokens"] child:token] child:@"starredMatches"] setValue:nil];
                for (NSNumber *item in starredMatches) {
                    [[[[[[[FIRDatabase database] reference] child:@"AppTokens"] child:token] child:@"starredMatches"] childByAutoId] setValue:item];
                }
            }];
            
            
        } else {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.64 blue:1.0 alpha:0.6];
            self.firebaseFetcher.currentMatchManager.starredMatchesArray = [self.firebaseFetcher.currentMatchManager.starredMatchesArray arrayByAddingObjectsFromArray:@[cell.matchLabel.text]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [defaults valueForKey:@"NotificationToken"];
            [[[[[[[FIRDatabase database] reference] child:@"AppTokens"] child:token] child:@"starredMatches"] childByAutoId] setValue: [NSNumber numberWithInt:[cell.matchLabel.text integerValue]]];
        }*/
    }
}


@end
