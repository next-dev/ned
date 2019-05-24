//
// Common types and external APIs
//

#pragma once

#ifdef __SCCZ80
#   define BREAK asm("defw 0x01dd\n")
#else
#   define BREAK \
        __asm \
        defw 0x01dd \
        __endasm;
#endif

//
// Basic types
//

#include <stdint.h>

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;

typedef int8_t i8;
typedef int16_t i16;
typedef int32_t i32;

typedef uint8_t bool;

#define YES (1)
#define NO (0)

//
// Keyboard interface
//

extern unsigned char Key;
extern unsigned char KFlags;
extern unsigned int Counter;

//
// Video API
//

void initVideo();
