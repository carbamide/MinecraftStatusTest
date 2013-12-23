//
//  pack.h
//  Minecraft Status Test
//
//  Created by Joshua Barrow on 12/23/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

#define TOINT(a, b, c, d) ((d << 24) + (c << 16) + (b << 8) + (a))
#define TOSHORT(a, b) ((b << 8) + (a))

unsigned char* pack(unsigned char* a, ...);
int   unpack(unsigned char* a, unsigned char* data, ...);
int   catInt(int pos, int endian, unsigned char* ret, int src);
int   catChar(int pos, unsigned char* ret, int src);
int   catShort(int pos, int endian, unsigned char* ret, int src);
