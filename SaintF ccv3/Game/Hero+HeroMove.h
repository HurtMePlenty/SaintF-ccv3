//
//  Hero+HeroMove.h
//  SaintF ccv3
//
//  Created by Alexey Semenov on 26/05/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "Hero.h"

@interface Hero (HeroMove)

-(void) startMoving: (MoveDirection)direction;
-(void) stopMoving;
@end
