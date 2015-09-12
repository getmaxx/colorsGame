//
//  IVTopScoreVC.m
//  ColorsGameRemastered
//
//  Created by Igor Vedeneev on 12.09.15.
//  Copyright (c) 2015 Igor Vedeneev. All rights reserved.
//

#import "IVTopScoreVC.h"
#import "IVTopScoreTableViewCell.h"

@interface IVTopScoreVC ()

@end

static NSString* kTopScoresArrayKey = @"topScoresArray";

@implementation IVTopScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *deviceType = [UIDevice currentDevice].model;
    NSLog(@"%@", deviceType);
    
    if([deviceType containsString: @"iPad"]) {
        
        [self backButton].hidden = YES;
        
    }
    
    self.topScoreTableView.delegate = self;
    self.topScoreTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;// 10 мест и 1 строка для пояснений
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray* temp = [NSMutableArray arrayWithArray:
                                            [defaults objectForKey:kTopScoresArrayKey]];
    
    IVTopScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if ([indexPath row] == 0) {
        cell.placeLabel.text = @"МЕСТО";
        cell.scoreLabel.text = @"ОЧКИ";
    }
    else {
        cell.scoreLabel.text = [NSString stringWithFormat:@"%@", [temp objectAtIndex: [indexPath row] - 1]];
        cell.placeLabel.text = [NSString stringWithFormat:@"%ld", (long)[indexPath row]];
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyle.None;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
