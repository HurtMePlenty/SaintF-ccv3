//
//  NodeUtils.h
//  SaintF ccv3
//
//  Created by Alexey Semenov on 23/07/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#include "cocos2d.h"

#ifndef SaintF_ccv3_NodeUtils_h
#define SaintF_ccv3_NodeUtils_h


static CGRect centeredBoundingBox (CCNode* node) {
    float x = - node.contentSize.width / 2;
    float y = - node.contentSize.height / 2;
    CGRect collisionRect = CGRectMake(x, y, node.contentSize.width, node.contentSize.height);
    return CGRectApplyAffineTransform(collisionRect, [node nodeToParentTransform]);
}


#endif
