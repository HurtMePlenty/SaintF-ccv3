//
//  BGObjectInfo.h
//  SaintF
//
//  Created by Alexey Semenov on 02/05/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGObjectInfo : NSObject

@property (nonatomic) NSString* fileName;
@property (nonatomic) bool canSpawnCreep;
@property (nonatomic) CGPoint birdSpawnPosition;

+(BGObjectInfo*)BgObjWithFileName:(NSString*)fileName spawnPos:(CGPoint)creepSpawnPosition;
+(BGObjectInfo*)BgObjWithFileName:(NSString*)fileName;

@end
