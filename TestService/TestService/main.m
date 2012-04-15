//
//  main.m
//  TestService
//
//  Created by Mateus Armando on 30.03.12.
//  Copyright (c) 2012 Sean Coorp. INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>
#import <XPCKit/XPCKit.h>

//int main(int argc, const char *argv[])
//{
//	return macruby_main("rb_main.rb", argc, argv);
//    
//}

int main(int argc, const char *argv[])
{
	[XPCService runServiceWithConnectionHandler:^(XPCConnection *connection){
		[connection _sendLog:@"Multiply received a connection"];
		[connection setEventHandler:^(NSDictionary *message, XPCConnection *connection){
        [connection _sendLog:[NSString stringWithFormat:@"Multiply received a message! %@", message]];
			if([[message objectForKey:@"operation"] isEqual:@"multiply"]){
				NSArray *values = [message objectForKey:@"values"];
                
				// calculate the product
				double product = 1.0;
				for(NSUInteger index=0; index < values.count; index++){
					product = product * [(NSNumber *)[values objectAtIndex:index] doubleValue];
				}
                
				[connection sendMessage:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:product] forKey:@"result"]];
			}
			
			if([[message objectForKey:@"operation"] isEqual:@"read"]){
				NSString *path = [message objectForKey:@"path"];
				NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
				NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
				
                [connection _sendLog:[NSString stringWithFormat:@"data %i bytes handle %@",data.length, fileHandle]];
				
				[connection sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:
										 data, @"data",
										 fileHandle, @"fileHandle",
										 nil]];
			}
			
			if([[message objectForKey:@"operation"] isEqual:@"whatTimeIsIt"]){
				[connection sendMessage:[NSDictionary dictionaryWithObject:[NSDate date] forKey:@"date"]];
			}
		}];
	}];
		
	return 0;
}
