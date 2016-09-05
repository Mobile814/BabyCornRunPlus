//
//  LoadingLayer.m
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingLayer.h"
#import "MainMenu.h"
#import "FullLayer.h"
#import "globals.h"

@implementation LoadingLayer

@synthesize textures;

+ (id)scene
{
	CCScene *scene = [CCScene node];
    LoadingLayer *layer = [LoadingLayer node];
    
    [scene addChild:layer];
    
    return scene;
}

- (id)init
{
    if ((self = [super init]))
    {   
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bestScore=[prefs integerForKey:@"bestscore"];
        
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"splash.png"]];
        background.position = ccp(240, 160);
        
        [self addChild:background z:0];
    }
    
    return self;
}

- (void)onEnter
{
    [super onEnter];
    
	self.textures = [NSMutableArray arrayWithCapacity:0];
    
    [textures addObject:@"ground_004.png"];            

	numberOfLoadedTextures = 0;
	[[CCTextureCache sharedTextureCache] addImageAsync:[textures objectAtIndex:numberOfLoadedTextures] target:self selector:@selector(imageDidLoad:)];
}

- (void) imageDidLoad:(CCTexture2D*)tex 
{
	NSString *plistFile = [[(NSString*)[textures objectAtIndex:numberOfLoadedTextures] stringByDeletingPathExtension] stringByAppendingString:@".plist"];
    
	//if([[NSFileManager defaultManager] fileExistsAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:plistFile]]) 
    //{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistFile];
    NSLog(@"loading %@", plistFile);
	//}
    
	numberOfLoadedTextures++;
    
	if(numberOfLoadedTextures == [textures count]) 
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3 scene:[MainMenu scene] withColor:ccBLACK]];
	} 
    
    else 
    {
		[[CCTextureCache sharedTextureCache] addImageAsync:[textures objectAtIndex:numberOfLoadedTextures] target:self selector:@selector(imageDidLoad:)];
	}
}

- (void) dealloc 
{    
    [textures release];
    
    [super dealloc];
}

@end
