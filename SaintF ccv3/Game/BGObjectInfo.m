//
//  BGObjectInfo.m
//  SaintF
//
//  Created by Alexey Semenov on 02/05/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "BGObjectInfo.h"

@implementation BGObjectInfo
@synthesize birdSpawnPosition, canSpawnBird, fileName;

+(BGObjectInfo*)BgObjWithFileName:(NSString*)fileName spawnPos:(CGPoint)birdSpawnPosition {
    BGObjectInfo* objInfo = [[BGObjectInfo alloc] init];
    objInfo.fileName = fileName;
    objInfo.canSpawnBird = true;
    objInfo.birdSpawnPosition = birdSpawnPosition;
    return objInfo;
}

+(BGObjectInfo*)BgObjWithFileName:(NSString*)fileName {
    BGObjectInfo* objInfo = [[BGObjectInfo alloc] init];
    objInfo.fileName = fileName;
    objInfo.canSpawnBird = false;
    return objInfo;
}

@end
