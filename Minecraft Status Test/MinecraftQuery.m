//
//  MinecraftQuery.m
//  Minecraft Status
//
//  Created by Joshua Barrow on 12/23/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "MinecraftQuery.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>

#include "pack.h"

static NSString *const STATISTIC = @"0x00";
static NSString *const HANDSHAKE = @"0x09";

@interface MinecraftQuery () <GCDAsyncUdpSocketDelegate>
@property (strong, nonatomic) GCDAsyncUdpSocket *socket;
@end

@implementation MinecraftQuery

-(instancetype)init
{
    if (self = [super init]) {
        _socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return self;
}

-(void)connectToIP:(NSString *)ip port:(uint16_t)port timeout:(int)timeout
{
    if (timeout < 0) {
        [NSException raise:@"Invalid timeout" format:@"timeout %d is invalid", timeout];
    }
    
    NSError *error = nil;
    
    [[self socket] bindToPort:port error:&error];
    [[self socket] setDelegate:self];
    
    BOOL didConnect = [[self socket] connectToHost:[NSString stringWithFormat:@"%@", ip]  onPort:port error:&error];
    
    [[self socket] beginReceiving:&error];

    if (didConnect) {
        if (error) {
            [NSException raise:@"Could not create socket." format:@"%@", [error localizedDescription]];
        }
        
        @try {
            id challenge = [self getChallenge];
            
            [self getStatus:challenge];
        }
        @catch (NSException *exception) {
            [[self socket] close];
            
            [NSException raise:@"There was an exception issuing the challenge." format:@"%@", [exception debugDescription]];
        }
    }
}

-(void)getInfo
{
    
}

-(void)getPlayers
{
    
}

-(id)getChallenge
{
    id data = [self writeData:HANDSHAKE tag:1];
    
    if (!data) {
        [NSException raise:@"Failed to receive challenge." format:nil];
    }
    return data;
}

-(void)getStatus:(id)challenge
{
    id data = [self writeData:STATISTIC tag:2];
    
    if (!data) {
        [NSException raise:@"Failed to receive status." format:nil];
    }
}

-(id)writeData:(NSString *)command tag:(int)tag
{
    command = [@[@"0x09", @"0xFD", command, @"0x01", @"0x02", @"0x03", @"0x04"] componentsJoinedByString:@""];
    
    NSData *data = [command dataUsingEncoding:NSUTF8StringEncoding];
    
    [[self socket] sendData:data withTimeout:-1 tag:tag];
    
    return data;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSLog(@"Did connect");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (tag == 1) {
        NSLog(@"Challenge Sent");
    }
    else if (tag == 2) {
        NSLog(@"Status sent");
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end
