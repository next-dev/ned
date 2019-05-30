// Video driver
#include <arch/zxn.h>
#include "ned.h"

u8 kPaletteColours[] = {
    0x00,
    0x02,
    0x80,
    0x82,
    0x10,
    0x12,
    0x90,
    0x92,
    0x6d,
    0x03,
    0xe0,
    0xe3,
    0x1c,
    0x1f,
    0xfc,
    0xff,
};


void setColour(u8 slot, u8 paper, u8 ink)
{
    ZXN_NEXTREG(0x43,0x30);     // Choose tilemap palette 0

    // Choose palette index
    ZXN_NEXTREGA(0x40,slot * 16);

    ZXN_NEXTREGA(0x41,kPaletteColours[paper]);
    ZXN_NEXTREGA(0x41,kPaletteColours[ink]);
}

void initVideo()
{
    zx_border(INK_BLACK);
    zx_cls(INK_WHITE+PAPER_BLACK);

    setColour(0, 0x00, 0x07);
    setColour(1, 0x07, 0x00);
    setColour(2, 0x0a, 0x0f);

    // Set up the tile map
    ZXN_NEXTREG(0x07,2);        // Set clock to 14Mhz
    ZXN_NEXTREG(0x6b,0xc1);     // Tile map control
    ZXN_NEXTREG(0x6e,0);        // Tile map base offset
    ZXN_NEXTREG(0x6f,0x20);     // Tiles base offset
    ZXN_NEXTREG(0x4c,8);        // Transparency colour (bright black)
    ZXN_NEXTREG(0x68,0x80);     // Disable ULA output
}

