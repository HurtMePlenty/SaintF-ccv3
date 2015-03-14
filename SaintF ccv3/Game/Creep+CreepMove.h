//
//  Creep+CreepMove.h
//  SaintF ccv3
//
//  Created by Alexey Semenov on 04/06/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "Creep.h"

@interface Creep (CreepMove)

-(void)startMoving:(MoveDirection)direction;
-(void)pauseMoveForGameOver;

@end
