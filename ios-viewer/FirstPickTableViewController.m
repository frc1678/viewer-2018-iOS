//
//  FirstPickTableViewController.m
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

#import "FirstPickTableViewController.h"
#import "MultiCellTableViewCell.h"
#import "config.h"
#import "ios_viewer-Swift.h"

@interface FirstPickTableViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation FirstPickTableViewController

- (void)viewDidLoad {
    self.ref = [[FIRDatabase database] reference];
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot childSnapshotForPath:@"FirstPicklist"].value) {
            if ([[snapshot childSnapshotForPath:@"FirstPicklist"].value isEmpty]) {
                firstPicklist = [NSMutableArray arrayWithArray:[self.firebaseFetcher getFirstPickList]];
                [[self.ref child:@"FirstPicklist"] setValue:firstPicklist];
            } else {
                firstPicklist = snapshot.value;
            }
        } else {
            NSMutableArray *firstPick = [NSMutableArray arrayWithArray:[self.firebaseFetcher getFirstPickList]];
            for (int i = 0; i < sizeof(firstPick)/sizeof(firstPick[0]); i++) {
                [firstPicklist addObject:firstPick[i]];
            }
            [[self.ref child:@"SecondPicklist"] setValue:firstPicklist];
        }
    }];
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    return [self.firebaseFetcher getFirstPickList];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TeamDetailsTableViewController class]]) {
        MultiCellTableViewCell *multiCell = sender;
        
        TeamDetailsTableViewController *teamDetailsController = segue.destinationViewController;
        Team *team = [self.firebaseFetcher getTeam:[multiCell.teamLabel.text integerValue]];
        NSLog(@"This is the passed team Number:");
        teamDetailsController.team = team;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    MultiCellTableViewCell *multiCell = (MultiCellTableViewCell *)cell;
    
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.firebaseFetcher rankOfTeam:team withCharacteristic:@"calculatedData.firstPickAbility"]];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number];
    if(team.calculatedData.firstPickAbility != -1.0) {
        multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                     [Utils roundValue:team.calculatedData.firstPickAbility toDecimalPlaces:2]];
    } else {
        multiCell.scoreLabel.text = @"";
    }
}

BOOL inPicklist = NO;
NSMutableArray *firstPicklist = nil;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"TeamDetails" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.firebaseFetcher filteredTeamsForSearchString:searchString];
}

-(NSString *)notificationName {
    return @"updatedLeftTable";
}

- (IBAction)togglePicklistMode:(id)sender {
    inPicklist = !inPicklist;
    [self.tableView setEditing:true animated:false];
    if(!inPicklist) {
        [[self.ref child:@"SecondPicklist"] setValue:firstPicklist];
    }
    self.dataArray = [self loadDataArray:false];
    [self.tableView reloadData];
}


@end
