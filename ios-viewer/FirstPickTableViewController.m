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
FIRDatabaseReference *firebase;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.firebaseFetcher getPicks];
    self.firebaseFetcher = [AppDelegate getAppDelegate].firebaseFetcher;
    self.ref = [[FIRDatabase database] reference];
    fbpassword = self.firebaseFetcher.picklistPassword;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Picklist" style:UIBarButtonItemStylePlain target:self action:@selector(toggleInPicklist)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"pickBoi" object:nil];
    self.tableView.allowsSelectionDuringEditing = YES;
    firebase = [[FIRDatabase database] reference];
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
    for(int i = 0; i < [self.firebaseFetcher.firstPicklist count]; i++) {
        [sortedTeams addObject:[self.firebaseFetcher getTeam:labs([self.firebaseFetcher.firstPicklist[i] integerValue])]];
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
    if (inPicklist) {
        if ([self.firebaseFetcher.firstPicklist[path.row] intValue] < 0) {
            NSLog(@"%ld",(long)path.row);
            NSLog(@"%d",[self.firebaseFetcher.firstPicklist[path.row] intValue]);
            cell.backgroundColor = [UIColor colorWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        } else {
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor]; 
        }
        multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", team.calculatedData.actualSeed];
    } else {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
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
    [[self.ref child:@"picklist"] setValue:firstPicklist];
    if(sourceIndexPath.row > destinationIndexPath.row) {
        for(int j = destinationIndexPath.row; j <= sourceIndexPath.row; j++){
            [[[[self.ref child:@"Teams"] child: [[NSNumber numberWithDouble:fabs([firstPicklist[j] doubleValue])] stringValue]] child:@"picklistPosition"] setValue:[NSNumber numberWithInteger:j]];
        }
    } else {
        for(int j = sourceIndexPath.row; j <= destinationIndexPath.row; j++){
            [[[[self.ref child:@"Teams"] child: [[NSNumber numberWithDouble:fabs([firstPicklist[j] doubleValue])] stringValue]] child:@"picklistPosition"] setValue:[NSNumber numberWithInteger:j]];
        }
    }
    // NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(secondPicklist)")
    // To check for correctness enable: self.tableView.reloadData()
}

-(void)reloadTableView:(NSNotification *)note {
    NSLog(@"A little birdie told me that we reloading");
    //NSLog(@"Picklist1: %@", self.firebaseFetcher.firstPicklist[0]);
    self.dataArray = [self loadDataArray:false];
    //NSLog(@"Picklist2: %@", self.firebaseFetcher.firstPicklist[0]);
    //NSLog(@"DataArray: %ld", (long)((Team *)self.dataArray[0]).number);
    [self.tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

BOOL inPicklist = NO;
NSMutableArray<NSNumber *> *firstPicklist = nil;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*if (inPicklist) {
        
    } else {*/
        [self performSegueWithIdentifier:@"TeamDetails" sender:[tableView cellForRowAtIndexPath:indexPath]];
    //}
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.firebaseFetcher filteredTeamsForSearchString:searchString];
}

-(NSString *)notificationName {
    return @"updatedLeftTable";
}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        if(inPicklist) {
            CGPoint p = [sender locationInView:self.tableView];
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.firebaseFetcher.firstPicklist];
            tempArray[indexPath.row] = @(-1 * [self.firebaseFetcher.firstPicklist[indexPath.row] intValue]);
            self.firebaseFetcher.firstPicklist = tempArray;
            NSLog(@"%@",tempArray[indexPath.row]);
            [[[firebase child:@"picklist"] child:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] setValue:[NSNumber numberWithInt:([self.firebaseFetcher.firstPicklist[indexPath.row] intValue])]];
            firstPicklist[indexPath.row] = @(-1 * [firstPicklist[indexPath.row] intValue]);
        }
    }
}

- (void)toggleInPicklist {
    [self.firebaseFetcher getPicks];
    if(!inPicklist){
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
                    [[self.ref child:@"picklist"] setValue:firstPicklist];
                }
                self.dataArray = [self loadDataArray:false];
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(clearPicklist)];
                [self.tableView reloadData];
                self.navigationItem.title = @"Live Picklist";
            }
            
        }]];
        [self presentViewController:ac animated:YES completion:nil];

    } else {
        inPicklist = !inPicklist;
        [self.tableView setEditing:(BOOL *)inPicklist animated:false];
        self.editing = inPicklist;
        self.dataArray = [self loadDataArray:false];
        self.navigationItem.leftBarButtonItem = nil;
        [self.tableView reloadData];
        self.navigationItem.title = @"First Pick";
    }
}

-(void)clearPicklist {
    NSMutableArray<NSNumber *> *tempPicklist = [[NSMutableArray alloc] init];
    for(Team *i in [self.firebaseFetcher getFirstPickList]) {
        [tempPicklist addObject:[NSNumber numberWithInt:i.number]];
    }
    [[self.ref child:@"picklist"] setValue:tempPicklist];
    self.firebaseFetcher.firstPicklist = tempPicklist;
    firstPicklist = tempPicklist;
    for(int i = 0; i < tempPicklist.count; i++) {
        NSString* myNewString = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:fabs([tempPicklist[i] doubleValue])]];
        [[[[self.ref child:@"Teams"] child: myNewString] child:@"picklistPosition"] setValue: [NSNumber numberWithInt:i]];
    }
    self.dataArray = [self loadDataArray:false];
    [self.tableView reloadData];
}

@end
