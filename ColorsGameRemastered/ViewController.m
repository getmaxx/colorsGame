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
    NSTimer* gameStateChangeTimer;
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
    
    [self preparationsForNewGame];
    
    self.lostGameView.alpha = 0.0f;
    
    gameIsFinished = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self loadScore];
    
}

#pragma mark - Actions

- (IBAction) colorButtonPressedAction: (UIButton*) sender {
    
    [game gameplay: sender.titleLabel.text vs:game.colorOfView.text];
    
    if (game.lives == 2)
        self.lifeView3.hidden = YES;
    else if (game.lives == 1)
        self.lifeView2.hidden = YES;
    else if (game.lives == 0)
        self.lifeView1.hidden = YES;
    
    [self changeGameState];
    [self setNewGameState];
    [self saveScoreAndLives];
    
}

- (IBAction) startNewGameAction:(UIButton *)sender {
    
    gameIsFinished = NO;
    [self preparationsForNewGame];
    [self hideLostGameView];
    [self changeGameState];
    [self setNewGameState];
}

#pragma mark - Gameplay

// подготовка к новой игре
- (void) preparationsForNewGame {
    
    self.colorView.alpha = 1.0f;
    
    game = [[IVGameState alloc] init];
    
    [self loadScore];
    
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
    else if (game.lives == 1)
        self.lifeView2.hidden = YES;
    else if (game.lives == 0)
        self.lifeView1.hidden = YES;

    
    gameIsFinished = NO;
    
}

- (void) nextGameState {
       
    [self animateInColorView];
    [game setColorsForButtonsAndWiew];
    NSArray* temp = [NSArray arrayWithArray:game.colorsForButtons];
    
    self.colorButton1.backgroundColor = ((IVColor*)[temp objectAtIndex:0]).color;
    self.colorButton2.backgroundColor = ((IVColor*)[temp objectAtIndex:1]).color;
    self.colorButton3.backgroundColor = ((IVColor*)[temp objectAtIndex:2]).color;
    self.colorButton4.backgroundColor = ((IVColor*)[temp objectAtIndex:3]).color;
    
    [self.colorButton1 setTitle:((IVColor*)[temp objectAtIndex:0]).text forState:UIControlStateNormal];
    [self.colorButton2 setTitle:((IVColor*)[temp objectAtIndex:1]).text forState:UIControlStateNormal];
    [self.colorButton3 setTitle:((IVColor*)[temp objectAtIndex:2]).text forState:UIControlStateNormal];
    [self.colorButton4 setTitle:((IVColor*)[temp objectAtIndex:3]).text forState:UIControlStateNormal];
    
    self.colorView.backgroundColor = game.colorOfView.color;
    
    for (IVColor* color in game.arrayOfColors) {
        if ([color.color isEqual: game.colorOfView.color]) {
            game.colorOfView.text = color.text;
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", game.score];
    
    if (game.lives == 0) {
        
        self.colorButton1.enabled = false;
        self.colorButton2.enabled = false;
        self.colorButton3.enabled = false;
        self.colorButton4.enabled = false;
                
        self.colorButton1.backgroundColor = [UIColor grayColor];
        self.colorButton2.backgroundColor = [UIColor grayColor];
        self.colorButton3.backgroundColor = [UIColor grayColor];
        self.colorButton4.backgroundColor = [UIColor grayColor];
        
        self.colorView.backgroundColor = [UIColor grayColor];
        self.colorView.alpha = 1.0f;
        
        self.lostGameScoreLabel.text = [NSString stringWithFormat:@"%d", game.score];
        
        [self showLostGameView];
        
        [gameStateChangeTimer invalidate];
        
        gameIsFinished = YES;
    }
    
}

- (void) setNewGameState {
    
    [gameStateChangeTimer invalidate];
    gameStateChangeTimer = nil;
    gameStateChangeTimer = [NSTimer scheduledTimerWithTimeInterval:IVDifficultyMedium
                                                          target:self
                                                        selector:@selector(changeGameState)
                                                        userInfo:nil
                                                         repeats:YES
                          ];
    
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
    self.colorView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: fadeTiming];
    self.colorView.alpha = 0.0f;
    [UIView commitAnimations];
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
    [defaults setObject: self.scoreLabel.text forKey:kSaveScoreKey];
    [defaults setInteger:game.lives forKey:kSaveLivesKey];
    NSLog(@"SAVE SCORE %@", self.scoreLabel.text);
    [defaults synchronize];
}

- (NSString*) loadScore {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* scoreString = [defaults objectForKey:kSaveScoreKey];
    NSLog(@"LOAD SCORE %@", scoreString);
    //[defaults synchronize];
    return scoreString;
}


- (NSInteger) loadLives {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger currentNumberOfLives = [defaults integerForKey:kSaveLivesKey];
    NSLog(@"LOAD LIVES %d", currentNumberOfLives);
    //[defaults synchronize];
    return currentNumberOfLives;
}

@end
