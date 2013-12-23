//
//  MinecraftQuery.h
//  Minecraft Status
//
//  Created by Joshua Barrow on 12/23/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinecraftQuery : NSObject
-(void)connectToIP:(NSString *)ip port:(uint16_t)port timeout:(int)timeout;
@end
