//
//  FirstPickTableViewController.h
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

#import "ArrayTableViewController.h"

@interface FirstPickTableViewController : ArrayTableViewController
@property (strong, nonatomic) FirebaseDataFetcher *firebaseFetcher;
@end
