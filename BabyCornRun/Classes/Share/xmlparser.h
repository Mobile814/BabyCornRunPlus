//
//  xmlparser.h
//  WebServiceGetLanguage
//
//  Created by Mac03 on 28/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSXMLParserDelegate;
@interface xmlparser : NSObject<NSXMLParserDelegate>
{
	NSMutableString *CurrentElement;
	NSMutableDictionary *dict;
	NSString *className;
	NSString *rootName;
	int tagValue;
	NSMutableArray *Items;
    NSMutableArray *nag;

}
@property(readwrite)int tagValue;
@property(nonatomic,retain)NSMutableArray *Items;
@property(nonatomic,retain)NSMutableArray *nag;

-(void)setClassName:(NSString *)cls withRootName:(NSString *)root tagNumber:(int)tag;
- (xmlparser *)initXMLParser;
@end
