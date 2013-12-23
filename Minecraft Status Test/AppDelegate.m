//
//  AppDelegate.m
//  Minecraft Status Test
//
//  Created by Joshua Barrow on 12/23/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "AppDelegate.h"
#import "MinecraftQuery.h"

@interface AppDelegate ()
@property (strong, nonatomic) MinecraftQuery *query;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

-(IBAction)doStuff:(id)sender
{
    if (![self query]) {
        [self setQuery:[[MinecraftQuery alloc] init]];
    }
    
    [[self query] connectToIP:@"108.174.48.200" port:25665 timeout:3];
}

@end
