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

NSString *fbpassword = @"";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.firebaseFetcher getPicks];
    self.firebaseFetcher = [AppDelegate getAppDelegate].firebaseFetcher;
    self.ref = [[FIRDatabase database] reference];
    fbpassword = self.firebaseFetcher.picklistPassword;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Picklist" style:UIBarButtonItemStylePlain target:self action:@selector(toggleInPicklist)];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray *) loadDataArray:(BOOL)shouldForce {
    if (!inPicklist) {
        if(self.firebaseFetcher == nil) {
            NSLog(@"STUPID");
        }
        NSArray *tempFirstPick = nil;
        tempFirstPick = [self.firebaseFetcher getFirstPickList];
        return tempFirstPick;
    }
    NSMutableArray *sortedTeams = [NSMutableArray new];
    for(int i = 0; i < [firstPicklist count]; i++) {
        [sortedTeams addObject:[self.firebaseFetcher getTeam:[firstPicklist[i] integerValue]]];
    }
    return (NSArray *)sortedTeams;
}
//[[]]
- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
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
    multiCell.showsReorderControl = YES;
    
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.firebaseFetcher rankOfTeam:team withCharacteristic:@"calculatedData.firstPickAbility"]];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number];
    if(team.calculatedData.firstPickAbility != -1.0) {
        multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                     [Utils roundValue:team.calculatedData.firstPickAbility toDecimalPlaces:2]];
    } else {
        multiCell.scoreLabel.text = @"";
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSNumber *movedObject = firstPicklist[sourceIndexPath.row];
    [firstPicklist removeObjectAtIndex: sourceIndexPath.row];
    [firstPicklist insertObject:movedObject atIndex:destinationIndexPath.row];
    self.firebaseFetcher.firstPicklist = firstPicklist;
    [[self.ref child:@"FirstPicklist"] setValue:firstPicklist];
    if(sourceIndexPath.row > destinationIndexPath.row) {
        for(int j = destinationIndexPath.row; j <= sourceIndexPath.row; j++){
            [[[[self.ref child:@"Teams"] child: [firstPicklist[j] stringValue]] child:@"firstPicklistPosition"] setValue:[NSNumber numberWithInteger:j]];
        }
    } else {
        for(int j = sourceIndexPath.row; j <= destinationIndexPath.row; j++){
            [[[[self.ref child:@"Teams"] child: [firstPicklist[j] stringValue]] child:@"firstPicklistPosition"] setValue:[NSNumber numberWithInteger:j]];
        }
    }
    // NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(secondPicklist)")
    // To check for correctness enable: self.tableView.reloadData()
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

BOOL inPicklist = NO;
NSMutableArray<NSNumber *> *firstPicklist = nil;

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

- (void)toggleInPicklist {
    if(!inPicklist){
        [self.firebaseFetcher getPicks];
        fbpassword = self.firebaseFetcher.picklistPassword;
        if (self.firebaseFetcher.firstPicklist.count == 0) {
            NSMutableArray<Team *> *tempPicklist = [NSMutableArray arrayWithArray:[self.firebaseFetcher getFirstPickList]];
            NSMutableArray *tempFirstPicklist = [[NSMutableArray alloc] init];
            for(int i = 0; i < [tempPicklist count]; i++) {
                NSNumber *tempNum = @(tempPicklist[i].number);
                [tempFirstPicklist addObject:tempNum];
            }
            firstPicklist = tempFirstPicklist;
            //[[self.ref child:@"FirstPicklist"] setValue:firstPicklist];
        } else {
            firstPicklist = [[NSMutableArray alloc] initWithArray: self.firebaseFetcher.firstPicklist];
        }
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Password" message:@"Please enter the password for access to picklists." preferredStyle:UIAlertControllerStyleAlert];
        [ac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Password";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        
        [ac addAction:[UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = ac.textFields;
            UITextField * password = textfields[0];
            if ([password.text isEqual: fbpassword]) {
                inPicklist = !inPicklist;
                [self.tableView setEditing:(BOOL *)inPicklist animated:false];
                self.editing = inPicklist;
                if(!inPicklist) {
                    [[self.ref child:@"FirstPicklist"] setValue:firstPicklist];
                }
                self.dataArray = [self loadDataArray:false];
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(clearPicklist)];
                [self.tableView reloadData];
            }
            
        }]];
        [self presentViewController:ac animated:YES completion:nil];
    } else {
        [self.firebaseFetcher getPicks];
        inPicklist = !inPicklist;
        [self.tableView setEditing:(BOOL *)inPicklist animated:false];
        self.editing = inPicklist;
        if(!inPicklist) {
            [[self.ref child:@"FirstPicklist"] setValue:firstPicklist];
        }
        self.dataArray = [self loadDataArray:false];
        self.navigationItem.leftBarButtonItem = nil;
        [self.tableView reloadData];
    }
}

-(void)clearPicklist {
    NSMutableArray<NSNumber *> *tempPicklist = [[NSMutableArray alloc] init];
    for(Team *i in [self.firebaseFetcher getFirstPickList]) {
        [tempPicklist addObject:[NSNumber numberWithInt:i.number]];
    }
    [[self.ref child:@"FirstPicklist"] setValue:tempPicklist];
    self.firebaseFetcher.firstPicklist = tempPicklist;
    firstPicklist = tempPicklist;
    for(int i = 0; i < tempPicklist.count; i++) {
        NSString* myNewString = [NSString stringWithFormat:@"%@", tempPicklist[i]];
        [[[[self.ref child:@"Teams"] child: myNewString] child:@"secondPicklistPosition"] setValue: [NSNumber numberWithInt:i]];
    }
    self.dataArray = [self loadDataArray:false];
    [self.tableView reloadData];
}

@end
