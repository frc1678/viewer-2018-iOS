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
            [[[[[[FIRDatabase database] reference] child: @"activeSlackProfiles"] child:slackId] child: @"starredMatches"] setValue:intMatches];
        }
    }

}

-(void) viewDidLayoutSubviews {
    [self.searchController.searchBar sizeToFit];
}

- (void)viewDidLoad {
    
    self.cacheButton.enabled = NO;
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToCurrentMatch:) name:@"currentMatchUpdated" object:nil];
    self.highlightDysfunc = NO;
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.searchController.searchBar setKeyboardType:UIKeyboardTypeDefault];
    [self.tableView addGestureRecognizer:pinchGestureRecognizer];
}

//This used to be used for Dysfunc Highlighting, but on options page now. I'll leave this here in case we want to pinch things in the future.
- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer {
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Ouch why did you pinch me");
    }
}

- (void)toggleDysfuncHighlight {
    self.highlightDysfunc = !self.highlightDysfunc;
    [self.tableView reloadData];
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
        //RED MATCH LABELS
        if(i < redTeams.count) {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[redTeams objectAtIndex:i]).number]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
            if(((Team *)[redTeams objectAtIndex:i]).calculatedData.dysfunctionalPercentage > 0 && self.firebaseFetcher.currentMatchManager.highlightDysfunc) {
                switch(i) {
                    case 0:
                        matchCell.redOneLabel.backgroundColor = [UIColor colorWithRed:0.00 green:0.75 blue:0.00 alpha:0.5];
                    case 1:
                        matchCell.redTwoLabel.backgroundColor = [UIColor colorWithRed:0.00 green:0.75 blue:0.00 alpha:0.5];
                    case 2:
                        matchCell.redThreeLabel.backgroundColor = [UIColor colorWithRed:0.00 green:0.75 blue:0.00 alpha:0.5];
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
        
        //BLUE MATCH LABELS
        if(i < blueTeams.count) {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[blueTeams objectAtIndex:i]).number]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
            if(((Team *)[blueTeams objectAtIndex:i]).calculatedData.dysfunctionalPercentage > 0 && self.firebaseFetcher.currentMatchManager.highlightDysfunc) {
                switch(i) {
                    case 0:
                        matchCell.blueOneLabel.backgroundColor = [UIColor colorWithRed:0.00 green:0.75 blue:0.00 alpha:0.5];
                    case 1:
                        matchCell.blueTwoLabel.backgroundColor = [UIColor colorWithRed:0.00 green:0.75 blue:0.00 alpha:0.5];
                    case 2:
                        matchCell.blueThreeLabel.backgroundColor = [UIColor colorWithRed:0.00 green:0.75 blue:0.00 alpha:0.5];
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
    
    //SETTING SCORE LABELS
    //if the red team has a valid score
    if (match.redScore != -1 && match.redScore != nil) {
        //set the red score
        matchCell.redScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.redScore];
        matchCell.slash.alpha = 1;
        matchCell.redScoreLabel.alpha = 1;
    } else {
        if (match.calculatedData.predictedRedScore != -1.0) {
            matchCell.redScoreLabel.text = [Utils roundValue: match.calculatedData.predictedRedScore toDecimalPlaces:0];
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
            matchCell.blueScoreLabel.text = [Utils roundValue: match.calculatedData.predictedBlueScore toDecimalPlaces:0];
        } else {
        matchCell.blueScoreLabel.text = @"?";
        }
        matchCell.blueScoreLabel.alpha = .3;
    }
    if(![matchCell.blueScoreLabel.text  isEqual: @"?"] && ![matchCell.redScoreLabel.text  isEqual: @"?"] && ![matchCell.blueScoreLabel.text isEqual:@"-1"] && ![matchCell.redScoreLabel.text isEqual:@"-1"]) {
        if ([matchCell.matchLabel.text integerValue] > self.currentNumber) {
            self.currentNumber = [matchCell.matchLabel.text integerValue];
        }
    }
    
    //EXTRA RP IMAGE VIEWS
    if(self.firebaseFetcher.currentMatchManager.showRP) {
        if(match.redDidAutoQuest) {
            matchCell.redAQ.alpha = 1.0;
        } else {
            matchCell.redAQ.alpha = 0.0;
        }
        if(match.blueDidAutoQuest) {
            matchCell.blueAQ.alpha = 1.0;
        } else {
            matchCell.blueAQ.alpha = 0.0;
        }
        if(match.redDidFaceBoss) {
            matchCell.redFTB.alpha = 1.0;
        } else {
            matchCell.redFTB.alpha = 0.0;
        }
        if(match.blueDidFaceBoss) {
            matchCell.blueFTB.alpha = 1.0;
        } else {
            matchCell.blueFTB.alpha = 0.0;
        }
    } else {
        matchCell.blueAQ.alpha = 0.0;
        matchCell.blueFTB.alpha = 0.0;
        matchCell.redAQ.alpha = 0.0;
        matchCell.redFTB.alpha = 0.0;
    }
}

- (NSString *)cellIdentifier {
    return MATCH_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = self.firebaseFetcher.currentMatchManager.matches;
    
    //[self.tableView setUserInteractionEnabled:YES];
    return returnData;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchTableViewCell *matchCell = (MatchTableViewCell *)cell;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    NSNumber *myNumber = [formatter numberFromString:matchCell.matchLabel.text];
    //Highlight starred matches
    if([self.firebaseFetcher.currentMatchManager.starredMatchesArray containsObject:myNumber]) {
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
    detailController.match = [self.firebaseFetcher.currentMatchManager.matches objectAtIndex:cell.matchLabel.text.integerValue-1];
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

}

- (NSArray *)scopeButtonTitles {
    return @[@"Teams", @"Matches"];
}

- (NSAttributedString *)textForScheduleLabelForType:(NSInteger)type forString:(NSString *)string {
    int bad = 0;
    UIColor *thing;
    NSArray *bois = [[self highlightedStringForScope] componentsSeparatedByString:@","];
    NSAttributedString *highlighted = [[NSAttributedString alloc] initWithString:string];
    if (type != [self currentScope] && type == 1) {
        for(NSString *boi in bois) {
            if(![boi isEqual: @""]) {
                if(bad==0) {thing=[UIColor greenColor];}else if(bad==1){thing=[UIColor yellowColor];} else if(bad==2) {thing=[UIColor orangeColor];} else {thing=[UIColor magentaColor];}
                highlighted = [self textForLabelForString:highlighted highlightOccurencesOfString:boi color:thing];
            }
            bad += 1;
        }
        return highlighted;
    } else if (type != [self currentScope] && type == 0) {
        for(NSString *boi in bois) {
            if(![boi isEqual: @""]) {
                if(bad==0) {thing=[UIColor greenColor];}else if(bad==1){thing=[UIColor yellowColor];} else if(bad==2) {thing=[UIColor orangeColor];} else {thing=[UIColor magentaColor];}
                highlighted = [self textForLabelForString:highlighted highlightOccurencesOfString:boi color:thing];
            }
            bad += 1;
        }
        return highlighted;
    }
    
    return [[NSAttributedString alloc] initWithString:string];
}

- (NSAttributedString *)textForLabelForString:(NSAttributedString *)string highlightOccurencesOfString:(NSString *)highlightString color:(UIColor *)color {
    NSMutableAttributedString *mutAttribString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    if (highlightString) {
        [mutAttribString addAttribute:NSBackgroundColorAttributeName value:color range:[[string string] rangeOfString:highlightString]];
    }
    
    return mutAttribString;
}

- (IBAction)cachePhotos:(UIBarButtonItem *)sender {
    sender.enabled = NO;
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
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            NSNumber *myNumber = [formatter numberFromString:cell.matchLabel.text];
            if([self.firebaseFetcher.currentMatchManager.starredMatchesArray containsObject:myNumber]) {
                //Remove the star
                NSMutableArray *a = [NSMutableArray arrayWithArray:self.firebaseFetcher.currentMatchManager.starredMatchesArray];
            
                [a removeObject:myNumber];
                self.firebaseFetcher.currentMatchManager.starredMatchesArray = a;
                cell.backgroundColor = [UIColor whiteColor];
                [[[[[[FIRDatabase database] reference] child:@"activeSlackProfiles"] child:slackId] child:@"starredMatches"] setValue:a];
            } else {
                //Create the star
                cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.64 blue:1.0 alpha:0.6];
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                NSNumber *myNumber = [formatter numberFromString:cell.matchLabel.text];
                self.firebaseFetcher.currentMatchManager.starredMatchesArray = [self.firebaseFetcher.currentMatchManager.starredMatchesArray arrayByAddingObject:myNumber];
                [[[[FIRDatabase database] reference] child:@"activeSlackProfiles"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    [[[[[[[FIRDatabase database] reference] child:@"activeSlackProfiles"] child:slackId] child:@"starredMatches"] child:[NSString stringWithFormat:@"%lu", (unsigned long)[[snapshot childSnapshotForPath:self.firebaseFetcher.currentMatchManager.slackId] childSnapshotForPath:@"starredMatches"].childrenCount]] setValue:[NSNumber numberWithInt:[cell.matchLabel.text integerValue]]];
                }];
            }
        } else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Link Slack" message:@"Please link your slack account before you star matches." preferredStyle:UIAlertControllerStyleAlert];
            
            [ac addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }]];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }
}


@end
