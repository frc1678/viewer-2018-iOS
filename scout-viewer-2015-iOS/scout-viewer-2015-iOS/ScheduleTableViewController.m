//
//  ScheduleTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "RealmModels.h"
#import "config.h"
#import "MatchTableViewCell.h"
#import "ScoutDataFetcher.h"
#import "scout_viewer_2015_iOS-Swift.h"
#import "UINavigationController+SGProgress.h"

@interface ScheduleTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cacheButton;

@end

@implementation ScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cachePhotos:self.cacheButton];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Match *match = data;
    RLMArray *redTeams = match.redTeams;
    RLMArray *blueTeams = match.blueTeams;
    
    if([match.match isEqualToString:@"Q91"]) {
        NSLog(@"asd");
    }
    
    
    
    MatchTableViewCell *matchCell = (MatchTableViewCell *)cell;
    matchCell.matchLabel.attributedText = [self textForScheduleLabelForType:0 forString:match.match];
    
    for (int i = 0; i < 3; i++) {
        if(i < redTeams.count) {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[redTeams objectAtIndex:i]).number]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
        } else {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"???"]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
        }
    }
    
    
    for (int i = 0; i < 3; i++) {
        if(i < blueTeams.count) {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[blueTeams objectAtIndex:i]).number]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
        } else {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"???"]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
        }
    }
    

    
    
    if (match.officialRedScore != -1 || match.officialBlueScore != -1) {
        matchCell.redScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.officialRedScore];
        matchCell.blueScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.officialBlueScore];
        matchCell.redScoreLabel.alpha = 1;
        matchCell.slash.alpha = 1;
        matchCell.blueScoreLabel.alpha = 1;
    } else {
        matchCell.redScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.calculatedData.predictedRedScore];
        matchCell.blueScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.calculatedData.predictedBlueScore];
        matchCell.redScoreLabel.alpha = .3;
        matchCell.slash.alpha = .3;
        matchCell.blueScoreLabel.alpha = .3;
    }
}

- (NSString *)cellIdentifier {
    return MATCH_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [ScoutDataFetcher fetchMatches:shouldForce];
    NSLog(@"%lu", (unsigned long)returnData.count);
    return returnData;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"Match Segue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MatchTableViewCell *cell = sender;
    MatchDetailsViewController *detailController = (MatchDetailsViewController *)segue.destinationViewController;
    detailController.match = [ScoutDataFetcher fetchMatch:cell.matchLabel.text];
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Match *match, NSDictionary *bindings) {
        if (scope == 0) {
            return ([match.match rangeOfString:searchString].location == 0 || [match.match rangeOfString:searchString].location == 1);
        } else if (scope == 1) {
            for (Team *team in [ScoutDataFetcher allTeamsInMatch:match]) {
                NSString *numberText = [NSString stringWithFormat:@"%ld", (long)team.number];
                if ([numberText rangeOfString:searchString].location == 0) {
                    return YES;
                }
            }
        }
        return NO;
    }]];
}

- (NSArray *)scopeButtonTitles {
    return @[@"Matches", @"Teams"];
}

- (NSAttributedString *)textForScheduleLabelForType:(NSInteger)type forString:(NSString *)string {
    if (type == [self currentScope] && type == 0) {
        return [self textForLabelForString:string highlightOccurencesOfString:[self highlightedStringForScope]];
    } else if (type == [self currentScope] && type == 1) {
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
    [ScoutDataFetcher downloadAllwithProgressCallback:^(float progress, BOOL done) {
        [self.navigationController setSGProgressPercentage:progress * 100];
    
        if(done) {
            NSLog(@"Done caching images...");

            sender.enabled = YES;
        }
    }];
}

+ (NSArray *)mappings {
    return @[@"One", @"Two", @"Three"];
}

@end
