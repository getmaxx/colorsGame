//
//  IVGameState.h
//  ColorsGameRemastered
//
//  Created by Igor Vedeneev on 21.07.15.
//  Copyright (c) 2015 Igor Vedeneev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IVColor;

@interface IVGameState : NSObject

@property (assign, nonatomic) int score;
@property (assign, nonatomic) int lives;
@property (strong, nonatomic) NSMutableArray* arrayOfColors;
@property (strong, nonatomic) NSArray* colorsForButtons;
@property (strong, nonatomic) IVColor* colorOfView;
@property (strong, nonatomic) NSMutableArray* arrayOfTopScores;


- (void) setColorsForButtonsAndWiew;
- (BOOL) gameplay:(NSString*) chosenColor vs:(NSString*) colorOfView;
- (int) addNewTopScore: (int) score;

+ (int) numberOfLives;

@end
