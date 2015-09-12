//
//  IVTopScoreVC.h
//  ColorsGameRemastered
//
//  Created by Igor Vedeneev on 12.09.15.
//  Copyright (c) 2015 Igor Vedeneev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IVTopScoreVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *topScoreTableView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end
