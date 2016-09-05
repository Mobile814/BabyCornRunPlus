//
//  LoadingLayer_ipad.h
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadingLayer_ipad : CCLayer {
    NSMutableArray *textures;
    int numberOfLoadedTextures;

}

@property (nonatomic, retain) NSMutableArray *textures;

+ (id)scene;

@end
