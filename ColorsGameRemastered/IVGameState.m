//
//  IVGameState.m
//  ColorsGameRemastered
//
//  Created by Igor Vedeneev on 21.07.15.
//  Copyright (c) 2015 Igor Vedeneev. All rights reserved.
//

#import "IVGameState.h"
#import "IVColor.h"

@implementation IVGameState

static int NUMBER_OF_LIVES = 3;
static int NUMBER_OF_BUTTONS = 4;
static int NUMBER_OF_TOP_SCORES = 10;

static NSString* kTopScoresArrayKey = @"topScoresArray";

- (id) init {
    
    self = [super init];
    
    if (self) {
        
        self.score = 0;
        self.arrayOfColors = [IVGameState configureArrayOfColors];
        self.lives = NUMBER_OF_LIVES;
        
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //загрузить лучшие счета или создать их
    if ([defaults objectForKey: kTopScoresArrayKey] == nil) {
        
        self.arrayOfTopScores = [[NSMutableArray alloc] init];
        for (int i = 0; i < NUMBER_OF_TOP_SCORES; i++) {
            [self.arrayOfTopScores addObject: [NSNumber numberWithInt: 0]];// дефолтные лучшие счета
        }
        
        [defaults setObject: self.arrayOfTopScores forKey: kTopScoresArrayKey];
        [defaults synchronize];
        
    }
    else {
        
        [[self arrayOfTopScores] removeAllObjects];
        self.arrayOfTopScores = [NSMutableArray arrayWithArray:[defaults objectForKey:kTopScoresArrayKey]];
                                 
        
    }
    NSLog(@"ARRAY OF TOP SCORES %@", self.arrayOfTopScores);

    return self;
}

+ (NSArray *) configureArrayOfColors {
    
    IVColor* red = [[IVColor alloc] init];
    red.color = [UIColor colorWithRed: 0.901f green: 0.196f blue: 0.232 alpha: 1];
    red.text = @"КРАСНЫЙ";
    
    IVColor* blue = [[IVColor alloc] init];
    blue.color = [UIColor colorWithRed: 0.196f green: 0.227f blue: 0.901 alpha: 1];
    blue.text = @"СИНИЙ";
    
    IVColor* green = [[IVColor alloc] init];
    green.color = [UIColor colorWithRed: 0.184f green: 0.76f blue: 0.443 alpha: 1];
    green.text = @"ЗЕЛЕНЫЙ";
    
    IVColor* orange = [[IVColor alloc] init];
    orange.color = [UIColor colorWithRed: 0.913f green: 0.623f blue: 0.0063 alpha: 1];
    orange.text = @"ОРАНЖЕВЫЙ";
    
    IVColor* magneta = [[IVColor alloc] init];
    magneta.color = [UIColor colorWithRed: 0.913f green: 0.0063f blue: 0.843 alpha: 1];
    magneta.text = @"РОЗОВЫЙ";
    
    IVColor* lightBlue = [[IVColor alloc] init];
    lightBlue.color = [UIColor colorWithRed: 0.501f green: 0.6f blue: 0.99 alpha: 1];
    lightBlue.text = @"ГОЛУБОЙ";
    
    IVColor* black = [[IVColor alloc] init];
    black.color = [UIColor colorWithRed: 0.1f green: 0.1f blue: 0.1 alpha: 1];
    black.text = @"ЧЕРНЫЙ";
    
    NSArray *arrayOfColors = [NSMutableArray arrayWithObjects:red, blue, green, orange, magneta, lightBlue, black, nil];
        
    return arrayOfColors;
}

- (void) setColorsForButtonsAndWiew {
    
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    
    //выбрать 4 цвета для кнопок
    for (int i = 0; i < NUMBER_OF_BUTTONS; i++) {
        
        IVColor* tempColor = [[IVColor alloc] init];
        
        int indexOfColor = arc4random() % ([self.arrayOfColors count] - i);
        
        tempColor.color = ((IVColor*)[self.arrayOfColors objectAtIndex: indexOfColor]).color;
        tempColor.text = ((IVColor*)[self.arrayOfColors objectAtIndex: indexOfColor]).text;
        [self.arrayOfColors exchangeObjectAtIndex: ([self.arrayOfColors count] - 1 - i)
                                withObjectAtIndex:indexOfColor];
        [temp addObject: tempColor];
        
    }
    
    //выбрать среди них цвет для вьюхи
    int indexOfColorOfView = arc4random() % ([temp count]);
    IVColor* tempColor = [[IVColor alloc] init];
    tempColor = (IVColor*)[temp objectAtIndex:indexOfColorOfView];
    self.colorOfView = tempColor;
        
    //перемешать названия цветов
    for (int i = 0; i < [temp count]; i++) {
        
        int indexOfText = arc4random() % ([temp count] - i);
        NSString* tempString = [NSString stringWithString:((IVColor*)[temp objectAtIndex:i]).text];
        
        ((IVColor*)[temp objectAtIndex:i]).text = ((IVColor*)[temp objectAtIndex:indexOfText]).text;
        ((IVColor*)[temp objectAtIndex:indexOfText]).text = tempString;
        [temp exchangeObjectAtIndex: ([temp count] - i - 1)
                  withObjectAtIndex:indexOfText];
       
    }
    
    self.colorsForButtons = temp;
}

- (BOOL) gameplay:(NSString*) chosenColor vs:(NSString*) colorOfView {
    
    //NSLog(@"chosen:%@ view:%@", chosenColor, colorOfView);
    if ([chosenColor isEqualToString: colorOfView])
        self.score++;
    else {
        if (self.lives == 0) {
            //NSLog(@"proigral");
            return NO;
        }
        else {
            self.score--;
            
            if (self.score < 0) {
                
                self.score = 0;
                
            }

            
            self.lives--;
        }
    }
    //NSLog(@"LIVES %d", self.lives);
    return YES;
}

+ (int) numberOfLives {
    
    return NUMBER_OF_LIVES;
    
}
// позиция счета в таблице или число 11, если счет не попал в таблицу рекордов
- (int) addNewTopScore: (int) score {
    
    for (int i = 0; i < NUMBER_OF_TOP_SCORES; i++) {
        
        int scoreAtIndex = [(NSNumber*)[self.arrayOfTopScores objectAtIndex: i] intValue];
        if (score >= scoreAtIndex) {
            
           [self.arrayOfTopScores insertObject:
                                        [NSNumber numberWithInt: score]
                                         atIndex:i];
            
           [[self arrayOfTopScores] removeLastObject];
            
           NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
           [defaults setObject: self.arrayOfTopScores forKey: kTopScoresArrayKey];
           [defaults synchronize];
           return i;
        }
    }
       
    return 11;
}

@end
