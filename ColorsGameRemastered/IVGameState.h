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


- (void) setColorsForButtonsAndWiew;
- (BOOL) gameplay:(NSString*) chosenColor vs:(NSString*) colorOfView;
- (BOOL) gameplay:(NSArray *)args;

+ (int) numberOfLives;

@end
