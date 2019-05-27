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

//----------------------------------------------------------------------------------------------------------------------
// Basic types
//----------------------------------------------------------------------------------------------------------------------

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

//----------------------------------------------------------------------------------------------------------------------
// Keyboard interface
//----------------------------------------------------------------------------------------------------------------------

extern unsigned char Key;
extern unsigned char KFlags;
extern unsigned int Counter;

//----------------------------------------------------------------------------------------------------------------------
// Video API
//----------------------------------------------------------------------------------------------------------------------

void initVideo();

//----------------------------------------------------------------------------------------------------------------------
// Display API
//----------------------------------------------------------------------------------------------------------------------

void clearArea(u8 x, u8 y, u8 width, u8 height, u8 colour);
void write(u8 x, u8 y, u8 colour, const char* text);
void displayScreen();
void displayRow(u8 sy, u32 pos);

//----------------------------------------------------------------------------------------------------------------------
// Editor state

typedef enum
{
    MODE_NORMAL,
    MODE_INSERT,
    MODE_VISUAL,
    MODE_LINE_VISUAL,
    MODE_BLOCK_VISUAL,
}
Mode;

extern u8 mode;        // Current editing mode
extern u32 top;        // Virtual offset of character shown at start of top line
extern u32 topLine;    // Line number (0-based) of top of screen.
extern u16 dx;         // Horizontal scroll distance.
extern u8 cursorX;     // Cursor X position on screen.
extern u8 cursorY;     // Cursor Y position on screen.
