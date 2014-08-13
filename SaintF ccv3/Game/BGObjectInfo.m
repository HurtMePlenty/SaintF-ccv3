//
//  BGObjectInfo.m
//  SaintF
//
//  Created by Alexey Semenov on 02/05/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "BGObjectInfo.h"

@implementation BGObjectInfo
@synthesize birdSpawnPosition, canSpawnCreep, fileName;

+(BGObjectInfo*)BgObjWithFileName:(NSString*)fileName spawnPos:(CGPoint)creepSpawnPosition {
    BGObjectInfo* objInfo = [[BGObjectInfo alloc] init];
    objInfo.fileName = fileName;
    objInfo.canSpawnCreep = true;
    objInfo.birdSpawnPosition = creepSpawnPosition;
    return objInfo;
}

+(BGObjectInfo*)BgObjWithFileName:(NSString*)fileName {
    BGObjectInfo* objInfo = [[BGObjectInfo alloc] init];
    objInfo.fileName = fileName;
    objInfo.canSpawnCreep = false;
    return objInfo;
}

@end
