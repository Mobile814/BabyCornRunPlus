//
//  xmlparser.m
//  WebServiceGetLanguage
//
//  Created by Mac03 on 28/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "xmlparser.h"

@implementation xmlparser
@synthesize Items,tagValue,nag;

- (xmlparser *)initXMLParser 
{
	Items=[[NSMutableArray alloc]init];
    [super init];
	return self;
}
-(void)setClassName:(NSString *)class withRootName:(NSString *)root tagNumber:(int)tag {
	className = class;
	rootName = root;
	tagValue=tag;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
	if(![elementName isEqualToString:rootName])
	{
		if([elementName isEqualToString:@"result"])
        {
//			dict=[[NSMutableDictionary alloc]init];
            [Items addObject:attributeDict];
		}
        else if([elementName isEqualToString:@"nag"])
        {
            nag =[[NSMutableArray alloc]init];
//            dict=[[NSMutableDictionary alloc]init];
            [nag addObject:attributeDict];
        }
    }
	NSLog(@"Start Element : %@",elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(!CurrentElement){
		CurrentElement=[[NSMutableString alloc]initWithString:string];
	}
	else {
		[CurrentElement appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName;
{
//	NSString *str;
//	if([elementName isEqualToString:elementName]){
//		if(dict!=nil){
//			[Items addObject:dict];
//			dict = nil;
//		}
//	}
//	
//	else if([elementName isEqualToString:elementName] )
//	{
//		str=[CurrentElement stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//		str=[CurrentElement stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//		str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//		str=[str stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
//		
//		if([str isEqualToString:@""] || str==nil){
//			NSLog(@"Null Entry came from XML File -  Online records");
//		}
//		else{
//			[dict setValue:str forKey:elementName];
//			NSLog(@"%@",[dict objectForKey:elementName]);
//		}
//	}
	[CurrentElement release];
	CurrentElement=nil;
	NSLog(@"End Element : %@",elementName);
}
-(void)dealloc
{
    [super dealloc];
}
@end
