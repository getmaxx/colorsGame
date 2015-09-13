//
//  ViewController.m
//  ColorsGameRemastered
//
//  Created by Igor Vedeneev on 12.07.15.
//  Copyright (c) 2015 Igor Vedeneev. All rights reserved.
//

#import "ViewController.h"
#import "IVColor.h"
#import "IVGameState.h"

static double IVDifficultyMedium = 5.0f;
static NSString* kSaveScoreKey = @"score";
static NSString* kSaveLivesKey = @"lives";

@interface ViewController () {

    IVGameState *game;
    UIView* testView;
    BOOL gameIsFinished;
    //NSTimer* gameStateChangeTimer;
    UIColor* backgroundColor;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    backgroundColor = [UIColor colorWithRed:1 green:1 blue:.85f alpha:1];
    self.view.backgroundColor = backgroundColor;
    [self.startNewGameButton setTitleColor: backgroundColor
                                  forState: UIControlStateNormal
    ];
    
    self.colorButton1.layer.borderWidth = 3.0f;
    self.colorButton1.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f] CGColor];
    self.colorButton2.layer.borderWidth = 3.0f;
    self.colorButton2.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f] CGColor];
    self.colorButton3.layer.borderWidth = 3.0f;
    self.colorButton3.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f] CGColor];
    self.colorButton4.layer.borderWidth = 3.0f;
    self.colorButton4.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f] CGColor];
    
    game = [[IVGameState alloc] init];
    
    game.score = [self loadScore];
    game.lives = [self loadLives];

    
    [self preparationsForNewGame];
    
    self.lostGameView.alpha = 0.0f;
    self.lostGameResultsLabel.textColor = [UIColor colorWithRed:1.0f green:0.38f blue:0.266f alpha:1.0f];
    
    gameIsFinished = NO;
    
    NSLog(@"viewdidload");
    
    UIGraphicsBeginImageContext(self.lifeView1.frame.size);
    [[UIImage imageNamed:@"LiveHeart.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.lifeView1.backgroundColor = [UIColor colorWithPatternImage:image];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - Actions

- (IBAction) colorButtonPressedAction: (UIButton*) sender {
    
    [game gameplay: sender.titleLabel.text vs:game.colorOfView.text];
    
    if (game.lives == 2)
        self.lifeView3.hidden = YES;
    else if (game.lives == 1) {
        
        self.lifeView3.hidden = YES;
        self.lifeView2.hidden = YES;
        
    }
    
    else if (game.lives == 0) {
        
        self.lifeView1.hidden = YES;
        self.lifeView2.hidden = YES;
        self.lifeView3.hidden = YES;
        
    }
    
    [self changeGameState];
    [self setNewGameState];
    [self saveScoreAndLives];
    
}

- (IBAction) startNewGameAction:(UIButton *)sender {
    
    gameIsFinished = NO;
    
    game.lives = [IVGameState numberOfLives];
    game.score = 0;
    
    [self preparationsForNewGame];
    [self hideLostGameView];
    [self changeGameState];
    [self setNewGameState];
}

#pragma mark - Gameplay

// подготовка к новой игре
- (void) preparationsForNewGame {
    
    self.colorView.alpha = 1.0f;
    self.view.alpha = 1.0f;
    
    [self nextGameState];
    
    self.colorButton1.enabled = true;
    self.colorButton2.enabled = true;
    self.colorButton3.enabled = true;
    self.colorButton4.enabled = true;
    
    self.lifeView3.hidden = NO;
    self.lifeView2.hidden = NO;
    self.lifeView1.hidden = NO;
    if (game.lives == 2)
        
        self.lifeView3.hidden = YES;
    
    else if (game.lives == 1) {
        
        self.lifeView3.hidden = YES;
        self.lifeView2.hidden = YES;
    }
    else if (game.lives == 0) {
        
        self.lifeView1.hidden = YES;
        self.lifeView2.hidden = YES;
        self.lifeView3.hidden = YES;
        
    }
    
    gameIsFinished = NO;
    
}
// новый игровой раунд и что делать, если проиграл
- (void) nextGameState {
       
    [self animateInColorView];
    [game setColorsForButtonsAndWiew];
    NSArray* temp = [NSArray arrayWithArray:game.colorsForButtons];
    
    self.colorButton1.backgroundColor = ((IVColor*)[temp objectAtIndex:0]).color;
    self.colorButton2.backgroundColor = ((IVColor*)[temp objectAtIndex:1]).color;
    self.colorButton3.backgroundColor = ((IVColor*)[temp objectAtIndex:2]).color;
    self.colorButton4.backgroundColor = ((IVColor*)[temp objectAtIndex:3]).color;
    
    [self.colorButton1 setTitle: ((IVColor*)[temp objectAtIndex:0]).text
                       forState: UIControlStateNormal];
    [self.colorButton2 setTitle: ((IVColor*)[temp objectAtIndex:1]).text
                       forState: UIControlStateNormal];
    [self.colorButton3 setTitle: ((IVColor*)[temp objectAtIndex:2]).text
                       forState: UIControlStateNormal];
    [self.colorButton4 setTitle: ((IVColor*)[temp objectAtIndex:3]).text
                       forState: UIControlStateNormal];
    
    self.colorView.backgroundColor = game.colorOfView.color;
    
    for (IVColor* color in game.arrayOfColors) {
        if ([color.color isEqual: game.colorOfView.color]) {
            game.colorOfView.text = color.text;
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", game.score];
    
    [self saveScoreAndLives];
    
    if (game.lives == 0) {
        
        self.colorButton1.enabled = false;
        self.colorButton2.enabled = false;
        self.colorButton3.enabled = false;
        self.colorButton4.enabled = false;
                
        self.colorButton1.backgroundColor = [UIColor grayColor];
        self.colorButton2.backgroundColor = [UIColor grayColor];
        self.colorButton3.backgroundColor = [UIColor grayColor];
        self.colorButton4.backgroundColor = [UIColor grayColor];
        
        [self.colorButton1 setTitle: @"" forState: UIControlStateNormal];
        [self.colorButton2 setTitle: @"" forState: UIControlStateNormal];
        [self.colorButton3 setTitle: @"" forState: UIControlStateNormal];
        [self.colorButton4 setTitle: @"" forState: UIControlStateNormal];
       
        
        self.colorView.backgroundColor = [UIColor grayColor];
        self.colorView.alpha = 1.0f;
        //self.view.alpha = 0.5f;
        //self.lostGameView.alpha = 1.0f;
        
        self.lostGameScoreLabel.text = [NSString stringWithFormat:@"%d", game.score];
        
        if (([game addNewTopScore:game.score] != 11) && (game.score != 0)) {
            
            self.lostGameResultsLabel.text = @"НОВЫЙ РЕКОРД!";
            self.lostGameResultsLabel.textColor = [UIColor greenColor];
            
        }
        
        [self showLostGameView];
        
        [self.gameStateChangeTimer invalidate];
        
        gameIsFinished = YES;
        
            }
    
}

- (void) setNewGameState {
    
    if (!gameIsFinished) {
        
        [self.gameStateChangeTimer invalidate];
        self.gameStateChangeTimer = nil;
        self.gameStateChangeTimer = [NSTimer scheduledTimerWithTimeInterval:IVDifficultyMedium
                                                                     target:self
                                                                   selector:@selector(changeGameState)
                                                                   userInfo:nil
                                                                    repeats:YES
                                     ];

    }
    
}

// вспомогательная функция для объединения переключения игрового состояния и затухания colorView
- (void) changeGameState {
    
    [self nextGameState];
    
    if (!gameIsFinished) {
        [self fadeAwayColorView: IVDifficultyMedium];
    }
    
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

#pragma mark - Animations

- (void) showLostGameView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    self.lostGameView.alpha = 1.0f;
    [UIView commitAnimations];

}

- (void) hideLostGameView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    self.lostGameView.alpha = 0.0f;
    [UIView commitAnimations];
}

// анимация исчезновения colorView
- (void) fadeAwayColorView: (double) fadeTiming {
    
    if (gameIsFinished) {
        
        self.colorView.alpha = 1.0f;
        
    }
    else {
        
        self.colorView.alpha = 1.0f;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: fadeTiming];
        self.colorView.alpha = 0.0f;
        [UIView commitAnimations];
        
    }
}

// анимация появления colorView
-(void) animateInColorView {
    
    self.colorView.alpha = 0.0f;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.3f];
    self.colorView.alpha = 1.0f;
    [UIView commitAnimations];
    
    //NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Saving & loading score and lives

- (void) saveScoreAndLives {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (game.lives != 0) {
        
        [defaults setInteger: game.lives forKey: kSaveLivesKey];
        [defaults setInteger: game.score forKey: kSaveScoreKey];
    }
    else {
        
        [defaults setInteger: [IVGameState numberOfLives] forKey: kSaveLivesKey];
        [defaults setInteger: 0 forKey: kSaveScoreKey];
        
    }
    
    [defaults synchronize];
}

- (int) loadScore {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int currentScore = [defaults integerForKey:kSaveScoreKey];
    NSLog(@"LOAD SCORE %d", currentScore);
    //[defaults synchronize];
    return currentScore;
}

- (int) loadLives {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger currentNumberOfLives = [defaults integerForKey:kSaveLivesKey];
    
    if (currentNumberOfLives == 0) {
        
        currentNumberOfLives = [IVGameState numberOfLives];
        
    }
    NSLog(@"LOAD LIVES %ld", (long)currentNumberOfLives);
    return currentNumberOfLives;
}

@end
