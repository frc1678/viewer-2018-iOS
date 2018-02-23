//
//  ArrayTableViewController.h
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirebaseDataFetcher;
@interface ArrayTableViewController : UITableViewController
    <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate>

@property (nonatomic) UIKeyboardType *keyboardType;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *filteredArray;
@property (strong, nonatomic) FirebaseDataFetcher *firebaseFetcher;
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;
@property (nonatomic) NSInteger currentNumber;
@property (strong,nonatomic) UISearchController *searchController;
@property (nonatomic) BOOL searchbarIsEnabled;

//Subclasses need to override these methods:
- (NSArray *)loadDataArray:(BOOL)shouldForce;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView;
- (NSString *)cellIdentifier;
- (NSString *)notificationName;
-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender;

- (NSArray *)filteredArrayForSearchText:(NSString *)text inScope:(NSInteger)scope;
- (NSArray *)scopeButtonTitles;
- (NSString *)highlightedStringForScope;
- (NSInteger)currentScope;


@end
