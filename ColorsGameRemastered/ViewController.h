//
//  ViewController.h
//  ColorsGameRemastered
//
//  Created by Igor Vedeneev on 12.07.15.
//  Copyright (c) 2015 Igor Vedeneev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// цветные кнопки с названиями цветов
@property (strong, nonatomic) IBOutlet UIButton *colorButton1;
@property (strong, nonatomic) IBOutlet UIButton *colorButton2;
@property (strong, nonatomic) IBOutlet UIButton *colorButton3;
@property (strong, nonatomic) IBOutlet UIButton *colorButton4;
@property (strong, nonatomic) IBOutlet UIView *colorView; // большой цветной прямоугольник

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;// счет игры

@property (strong, nonatomic) IBOutlet UIButton *startNewGameButton;// перезапустить игру

- (IBAction) colorButtonPressedAction: (UIButton*) sender;// сменить цвета и счет по нажатию одной из кнопок

- (IBAction) startNewGameAction:(UIButton *)sender;//запустить новую игру
// окно проигранной игры и его элементы
@property (strong, nonatomic) IBOutlet UIView *lostGameView;
@property (strong, nonatomic) IBOutlet UILabel *lostGameScoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *lostViewNewGameButton;
// контейнер с жизнями
@property (strong, nonatomic) IBOutlet UIView *lifeView1;
@property (strong, nonatomic) IBOutlet UIView *lifeView2;
@property (strong, nonatomic) IBOutlet UIView *lifeView3;
// сохранить счет и жизни при выходе
- (void) saveScoreAndLives;
// загрузить счет и жизни при выходе
- (NSInteger) loadLives;
- (NSString*) loadScore;

@end

